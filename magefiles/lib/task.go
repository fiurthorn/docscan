package mage

import (
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"syscall"
	"time"
)

func NewTasks() *Tasks {
	c := &Tasks{
		wg: &sync.WaitGroup{},
	}
	c.wg.Add(1)
	return c
}

type Tasks struct {
	tasks []*Task

	stop bool
	wg   *sync.WaitGroup
}

func (t *Tasks) Wait() {
	t.wg.Wait()
}

func (t *Tasks) Launch(task *Task) {
	t.wg.Add(1)
	task.Start()
	t.tasks = append(t.tasks, task)

	go t.waitProc(task)
}

func (t *Tasks) waitProc(task *Task) {
	defer t.wg.Done()
	task.process.Wait()
	fmt.Println(task.Command, "done")
	task.Done()
	if !t.stop {
		fmt.Println(task.Command, "restart")
		go t.Launch(task)
	}
}

func (t *Tasks) SignalHandler() {
	t.stop = true
	t.sendSignal(syscall.SIGTERM)
	fmt.Println("Wait 5 Sec to SIGKILL")
	time.Sleep(5 * time.Second)
	t.sendSignal(syscall.SIGKILL)

	t.wg.Done()
}

func (t *Tasks) sendSignal(signal syscall.Signal) {
	if t.checkAlive() {
		for _, task := range t.tasks {
			if task.process != nil && !task.done {
				fmt.Printf("send %s to '%v'\n", signal.String(), task.Command)
				err := task.process.Process.Signal(signal)
				if err != nil {
					fmt.Println("int", err.Error())
				}
			}
		}
	}
}

func (t *Tasks) checkAlive() bool {
	for _, command := range t.tasks {
		if !command.done {
			return true
		}
	}
	return false
}

type Task struct {
	Command          string
	Args             []string
	Environment      map[string]string
	WorkingDirectory string

	process *exec.Cmd
	done    bool
}

func (t *Task) Done() {
	t.done = true
}

func NewTask(command string, args ...string) *Task {
	return &Task{
		Command: command,
		Args:    args,
	}
}

func (t *Task) WithEnv(env map[string]string) *Task {
	t.Environment = env
	return t
}

func (t *Task) WorkingDir(dir string) *Task {
	t.WorkingDirectory = dir
	return t
}

func (t *Task) Stop() {
	t.process.Process.Kill()
}

func (t *Task) Result(out io.Writer, in io.Reader) (err error) {
	err = t.start(out, out, in)
	if err != nil {
		return
	}
	err = t.process.Wait()

	return
}

func (t *Task) Run() (err error) {
	err = t.Start()
	if err != nil {
		return
	}

	err = t.process.Wait()
	return
}

func (t *Task) Start() (err error) {
	return t.start(os.Stdout, os.Stderr, os.Stdin)
}

func (t *Task) lookup(workingDir, executable string) (result string, err error) {
	if strings.Contains(executable, "/") {
		result = filepath.Join(workingDir, executable)
		if _, err := os.Stat(result); !errors.Is(err, os.ErrNotExist) {
			return result, nil
		}
	}

	result, err = exec.LookPath(executable)
	if ee, ok := err.(*exec.Error); ok && ee.Err == exec.ErrNotFound {
		result = filepath.Join(workingDir, t.Command)
		if _, err = os.Stat(result); errors.Is(err, os.ErrNotExist) {
			result = ""
			return
		}
	} else if err != nil {
		result = ""
		return
	}

	return
}

func (t *Task) start(stdout, stderr io.Writer, stdin io.Reader) (err error) {
	t.done = false

	env := os.Environ()
	for key, value := range t.Environment {
		env = append(env, fmt.Sprintf("%s=%s", key, value))
	}

	var workingDir string
	if filepath.IsAbs(t.WorkingDirectory) {
		workingDir = t.WorkingDirectory
	} else {
		workingDir, err = os.Getwd()
		if err != nil {
			return
		}
		workingDir, err = filepath.Abs(filepath.Join(workingDir, t.WorkingDirectory))
		if err != nil {
			return
		}
	}

	args := make([]string, 0, len(t.Args)+1)
	args = append(args, t.Command)
	args = append(args, t.Args...)
	fmt.Println("$ " + workingDir + "> '" + strings.Join(args, "' '") + "'")

	executable, err := t.lookup(workingDir, t.Command)
	if err != nil {
		return
	}

	t.process = &exec.Cmd{
		Path:   executable,
		Args:   args,
		Env:    env,
		Stdin:  stdin,
		Stdout: stdout,
		Stderr: stderr,
		Dir:    workingDir,
	}

	err = t.process.Start()
	return
}
