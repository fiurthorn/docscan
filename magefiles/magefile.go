// docscan project
package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"time"

	mage "fiurthorn.software/docscan/magefiles/lib"
	"github.com/lithammer/fuzzysearch/fuzzy"
	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/parse"
	"github.com/magefile/mage/sh"
	"github.com/magefile/mage/target"
)

var (
	Default = Complete
)

// androidIp, wlanPort, pairingPort, pairingCode
func AdbWlan(ip, port, pairCode, pairPort string) (err error) {
	err = mage.NewTask("adb", "pair", fmt.Sprintf("%s:%s", ip, pairPort), pairCode).Run()
	if err != nil {
		return
	}

	err = mage.NewTask("adb", "connect", fmt.Sprintf("%s:%s", ip, port)).Run()
	if err != nil {
		return
	}

	return
}

func AdbQrcode(port string) (err error) {
	err = mage.NewTask("adb-wifi", port).Run()
	if err != nil {
		fmt.Println("maybe install 'npm i adb-wifi -g'")
		return
	}
	return
}

func OptimizePng() (err error) {
	err = mage.NewTask("find", "android", "icons", "-name", "*.png", "-exec", "zopflipng", "-m", "-y", "{}", "{}", ";").WorkingDir(".").Run()
	return
}

func BuildApk() (err error) {
	err = mage.NewTask("flutter", "build", "apk", "--flavor", "prod").Run()
	return
}

func BuildAppBundle() (err error) {
	err = mage.NewTask("flutter", "build", "appbundle", "--flavor", "prod").Run()
	return
}

// call the dart build runner
func BuildRunner() error {
	return mage.NewTask("dart", "run", "build_runner", "build", "--delete-conflicting-outputs").Run()
}

func DartAnalyse() error {
	return mage.NewTask("dart", "analyze", "--fatal-infos").Run()
}

// run pub get to pre-compile executables
func CreateVersion() (err error) {
	version, now, err := buildVersion()
	if err != nil {
		return
	}

	buildNumber, err := getVersionYamlKeyValue()
	if err != nil {
		return
	}

	return os.WriteFile("lib/core/version.g.dart", []byte(fmt.Sprintf(`// Generated file. Do not edit.

import 'package:flutter/foundation.dart';

const buildVersion = "%s${kDebugMode ? '-debug' : ''}";
const buildNumber = %d;
final buildDate = DateTime(%s);
final copyright = 'Copyright ${_span(DateTime.now().year)} fiurthorn';

String _span(int now) => %s == now ? '%s' : '%s-$now';
`,
		version,
		buildNumber,
		now.Format("2006, 1, 2, 15, 4, 5"),
		now.Format("2006"),
		now.Format("2006"),
		now.Format("2006"),
	)), 0666)
}

func flutterAllPackages(args ...string) (err error) {
	plugins, err := filepath.Glob("plugins/*/*/pubspec.yaml")
	if err != nil {
		return
	}

	packages := []string{""}
	for _, dir := range plugins {
		packages = append(packages, filepath.Dir(dir))
	}

	for _, pkg := range packages {
		fmt.Println("--- enter", pkg)
		err := mage.NewTask("flutter", args...).WorkingDir(pkg).Run()
		if err != nil {
			return err
		}
	}

	return nil

}

// run pub get to pre-compile executables
func PubGet() error {
	return flutterAllPackages("pub", "get")
}

// run pub get to upgrade dependencies
func PubUpgrade() error {
	return flutterAllPackages("pub", "upgrade")
}

// run pub get to upgrade dependencies major versions
func PubUpgradeMajor() error {
	return flutterAllPackages("pub", "upgrade", "--major-versions")
}

func PubGlobalUpgrade() (err error) {
	err = mage.NewTask("flutter", "pub", "global", "activate", "license_checker").Run()
	if err != nil {
		return
	}

	return mage.NewTask("flutter", "pub", "global", "activate", "arb_utils").Run()
}

// run pub get to pre-compile executables
func PackagesPubGet() error {
	return mage.NewTask("flutter", "packages", "pub", "get").Run()
}

// generate icons
func Icons() error {
	return mage.NewTask("flutter", "pub", "run", "flutter_launcher_icons_maker:main").Run()
}

// smart cleanup
func Clean() (err error) {
	err = mage.NewTask("flutter", "clean").Run()
	if err != nil {
		return
	}
	err = mage.NewTask("flutter", "pub", "get").Run()
	return
}

// create translation files
func CreateI18n() error {
	mage.NewTask("dart", "lib/arb_clean.dart", ".").Run()
	mage.NewTask("arb_utils", "generate-meta", "lib/l10n/app_en.arb").Run()
	for _, lang := range []string{"de", "en"} {
		mage.NewTask("arb_utils", "sort", "-i", "lib/l10n/app_"+lang+".arb").Run()
	}
	return mage.NewTask(
		"flutter",
		"gen-l10n",
		"--arb-dir=lib/l10n",
		"--template-arb-file=app_en.arb",
		"--output-dir=lib/l10n/translations",
		"--output-class=S",
		"--no-nullable-getter",
		"--output-localization-file=translations.dart",
		"--untranslated-messages-file=lib/l10n/missing.json",
		"--no-synthetic-package",
		"--header=// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers",
	).Run()
}

// create translation files
func CreateI18nSynthetic() error {
	mage.NewTask("dart", "lib/arb_clean.dart", ".").Run()
	return mage.NewTask(
		"flutter",
		"gen-l10n",
		"--arb-dir=lib/l10n",
		"--template-arb-file=app_en.arb",
		"--output-dir=lib/l10n/translations",
		"--output-class=S",
		"--output-localization-file=S.dart",
		"--untranslated-messages-file=lib/l10n/missing.json",
	).Run()
}

// build all dependencies
func Deps() {
	mg.SerialDeps(
		CreateVersion,
		PubGet,
		CreateI18n,
		Icons,
		BuildRunner,
	)
}

func DevelopDeps() {
	mg.SerialDeps(
		PubGet,
		PubGlobalUpgrade,
		CreateI18nSynthetic,
		CreateVersion,
		CreateI18n,
		Icons,
		BuildRunner,
	)
}

// start tests
func Tests() error {
	return mage.NewTask("flutter", "test").Run()
}

type completion struct {
	name string
	desc string
}

// bash auto complete
func Mage() error {
	return Complete()
}

// // bash auto complete
func Complete() (err error) {
	line, hasLine := os.LookupEnv("COMP_LINE")
	if !hasLine {
		line = ""
	}
	point, ok := os.LookupEnv("COMP_POINT")
	if !ok {
		point = fmt.Sprintf("%d", len(line))
	}
	stop, err := strconv.Atoi(point)
	if err != nil {
		panic(err)
	}
	return complete(line, stop, hasLine)
}

func complete(line string, stop int, hasLine bool) (err error) {
	path, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	pkgs, err := parse.Package(path+"/magefiles", []string{"magefile.go"})
	if err != nil {
		panic(err)
	}

	_, zsh := os.LookupEnv("ZSH")
	_, debug := os.LookupEnv("DEBUG")

	start := strings.LastIndex(line[:stop], " ")
	word := line[start+1 : stop]
	word = strings.ToLower(word)

	max := func(a, b int) int {
		if a > b {
			return a
		}
		return b
	}

	coalesc := func(a, b string) string {
		if len(a) == 0 {
			return b
		}
		return a
	}

	targets, pad := []completion{}, 0
	prefixes, pPad := []completion{}, 0
	contains, cPad := []completion{}, 0
	fuzz, fPad := []completion{}, 0

	for _, f := range pkgs.Funcs {
		name := strings.ToLower(f.TargetName())
		c := completion{name: f.TargetName(), desc: coalesc(f.Comment, "-")}
		l := len(c.name)
		pad = max(pad, l)
		targets = append(targets, c)

		if len(word) > 0 {
			if strings.HasPrefix(name, word) {
				prefixes, pPad = append(prefixes, c), max(pPad, l)
			}
			if strings.Contains(name, word) {
				contains, cPad = append(contains, c), max(cPad, l)
			}
			if fuzzy.MatchFold(word, name) {
				fuzz, fPad = append(fuzz, c), max(fPad, l)
			}
		}
	}

	if debug {
		fmt.Printf("line (%s:%v) point(%d)\n", line, hasLine, stop)
		fmt.Printf("prefixes(%3d) %-5v pad(%3d)\n", len(prefixes), len(prefixes) > 0, pPad)
		fmt.Printf("contains(%3d) %-5v pad(%3d)\n", len(contains), len(contains) > 0, cPad)
		fmt.Printf("fuzz    (%3d) %-5v pad(%3d)\n", len(fuzz), len(fuzz) > 0, fPad)
		fmt.Printf("targets (%3d) %-5v pad(%3d)\n", len(targets), len(targets) > 0, pad)
	}

	if len(prefixes) > 0 {
		targets, pad = prefixes, pPad
	} else if len(contains) > 0 {
		targets, pad = contains, cPad
	} else if len(fuzz) > 0 {
		targets, pad = fuzz, fPad
	} else if len(word) > 0 {
		targets, pad = targets[:0], 0
	}

	if debug {
		fmt.Printf("selected(%3d) %-5v pad(%3d)\n", len(targets), len(targets) > 0, pad)
	}

	if len(targets) == 1 {
		fmt.Println(targets[0].name)
	} else if len(targets) > 1 {
		for _, target := range targets {
			if debug || !hasLine {
				fmt.Printf("%-*s (%s)\n", pad, target.name, target.desc)
			} else if zsh && !debug {
				// fmt.Printf("%s:%s\n", target.name, target.desc)
				fmt.Printf("%s\n", target.name)
			} else {
				fmt.Printf("%-*s (%s)\n", pad, target.name, target.desc)
			}
		}
	}

	return
}

// auto complete helper (recompile if needed)
func Check() (err error) {
	changed, err := target.Glob(
		"mage",
		"magefiles/*",
		"magefiles/lib/*",
		// "server/magefiles/lib/*/*",
	)
	if err != nil {
		panic(err)
	}
	if changed {
		fmt.Fprintln(os.Stderr, "compiling...")
		sh.Rm("mage")
		err = mage.NewTask(
			"go",
			"run",
			"magefiles/cmd/mage.go",
			"-compile",
			executableName("../mage"),
		).WorkingDir(".").
			Run()

		//os.Exit(66)
	}
	return
}

func Version() (err error) {
	winVer, ver, err := fullVersion()
	if err != nil {
		return
	}
	fmt.Println(ver)

	if err != nil {
		return
	}
	fmt.Println(winVer)

	return
}

func executableName(name string) string {
	if runtime.GOOS != "windows" {
		return name
	}

	return name + ".exe"
}

func buildVersion() (version string, now time.Time, err error) {
	version, err = gitVersion()
	if err != nil {
		return
	}
	now = time.Now()

	if strings.ContainsRune(version, '+') {
		version += now.Format("-060021504")
	}

	return
}

var _gitVersion string

func fullVersion() (winVer, version string, err error) {
	version, err = gitVersion()
	if err != nil {
		return
	}

	winVer, _, _ = strings.Cut(version, "-g")
	if strings.Index(winVer, "+") > 0 {
		winVer = strings.Replace(winVer, "+", ".", 1)
	}
	for strings.Count(winVer, ".") < 3 {
		winVer += ".0"
	}

	for strings.Count(winVer, ".") > 3 {
		winVer = winVer[:strings.LastIndexByte(winVer, '.')]
	}

	return
}

func checkGitReposClean() bool {
	cmd := exec.Command("git", "status", "--porcelain")
	result, err := cmd.Output()
	if err != nil {
		fmt.Println("git error", err)
		return false
	}
	if len(result) > 0 {
		fmt.Println("git result", string(result))
		return false
	}

	return true
}

func getVersionYamlKeyValue() (versionCode int, err error) {
	data, err := os.ReadFile("pubspec.yaml")
	if err != nil {
		fmt.Println(err)
		return
	}
	versionCodeMatcher, err := regexp.Compile(`version: \d+\.\d+\.\d+(?:\+(\d+))?`)
	if err != nil {
		return
	}

	match := versionCodeMatcher.FindStringSubmatch(string(data))
	if len(match) < 2 {
		versionCode = 0
	} else {
		versionCode, err = strconv.Atoi(match[1])
		if err != nil {
			return
		}
	}

	return
}

func replaceVersionYamlKeyValue(path, version string) (err error) {
	data, err := os.ReadFile(path)
	if err != nil {
		fmt.Println(err)
		return
	}
	versionCodeMatcher, err := regexp.Compile(`version: \d+\.\d+\.\d+(?:\+(\d+))?`)
	if err != nil {
		return
	}

	var versionCode int

	match := versionCodeMatcher.FindStringSubmatch(string(data))
	if len(match) < 2 {
		versionCode = 0
	} else {
		versionCode, err = strconv.Atoi(match[1])
		if err != nil {
			return
		}
	}
	versionCode++

	replacer, err := regexp.Compile(`version: .*`)
	if err != nil {
		return
	}

	result := replacer.ReplaceAllString(string(data), fmt.Sprintf("version: %s+%d", version, versionCode))
	err = os.WriteFile(path, []byte(result), 0666)

	return
}

func writeChangelog(path, changelog, version string) (err error) {
	fmt.Println("write changeLog", path)
	previous, err := os.ReadFile("ChangeLog.md")
	if err != nil {
		return
	}

	os.WriteFile(path, []byte("## Version "+version+"\n\n"+changelog+"\n"+string(previous)), 0666)

	return
}

func GitChangelog() (err error) {
	lastVersionBytes, err := exec.Command("git", "describe", "--tags", "--abbrev=0").Output()
	if err != nil {
		return err
	}
	lastVersion := strings.TrimSpace(string(lastVersionBytes))
	fmt.Println("get last Version", lastVersion)

	changeLogBytes, err := exec.Command("git", "log", string(lastVersion)+"..HEAD", "--oneline").Output()
	if err != nil {
		return err
	}
	fmt.Println(string(changeLogBytes))

	return
}

func SetVersion(version string) (err error) {
	if err = DartAnalyse(); err != nil {
		return
	}

	pat, err := regexp.Compile("[0-9]+.[0-9]+.[0-9]+")
	if err != nil {
		return
	}

	if !pat.MatchString(version) {
		err = fmt.Errorf("version must match [0-9]+.[0-9]+.[0-9]+")
		return
	}

	if !checkGitReposClean() {
		err = fmt.Errorf("git repository not clean")
		fmt.Println(err.Error())
		return
	}

	fmt.Println("get last Version")
	lastVersionBytes, err := exec.Command("git", "describe", "--tags", "--abbrev=0").Output()
	if err != nil {
		return err
	}
	lastVersion := strings.TrimSpace(string(lastVersionBytes))

	fmt.Println("get ChangeLog since", lastVersion)
	fmt.Println("git", "log", string(lastVersion)+"..HEAD", "--oneline")
	changeLogBytes, err := exec.Command("git", "log", string(lastVersion)+"..HEAD", "--oneline").Output()
	if err != nil {
		return err
	}
	writeChangelog("ChangeLog.md", string(changeLogBytes), version)

	replaceVersionYamlKeyValue("pubspec.yaml", version)
	files, err := filepath.Glob("plugins/*/*/pubspec.yaml")
	if err != nil {
		return err
	}
	for _, file := range files {
		fmt.Println("upgrade version", file)
		replaceVersionYamlKeyValue(file, version)
	}

	fmt.Println("git add")
	err = exec.Command("git", "add", ".").Run()
	if err != nil {
		return
	}

	fmt.Println("git commit")
	err = exec.Command("git", "commit", "-a", "-m", "New Version "+version).Run()
	if err != nil {
		return
	}

	fmt.Println("git tag")
	err = exec.Command("git", "tag", "-f", "-a", "-m", "New Release "+version+"\n\n"+string(changeLogBytes), "v"+version).Run()
	if err != nil {
		return
	}

	fmt.Println("git push with tags")
	err = exec.Command("git", "push", "-f", "--follow-tags").Run()
	if err != nil {
		return
	}

	fmt.Println("update dart version file")
	mg.SerialDeps(CreateVersion)
	return nil
}

// // get git version for tagging, packaging etc.
func gitVersion() (string, error) {
	if len(_gitVersion) > 0 {
		return _gitVersion, nil
	}
	gv, err := sh.Output("git", "describe", "--tags", "--always", "--match=v*")
	gv, _, _ = strings.Cut(gv[1:], "-g")
	if strings.ContainsRune(gv, '+') {
		_gitVersion = strings.Replace(gv, "-", ".", 1)
	} else {
		_gitVersion = strings.Replace(gv, "-", "+", 1)
	}
	return _gitVersion, err
}

func Base64Decode(envName, output string) (err error) {
	content, ok := os.LookupEnv(envName)
	if !ok || len(content) == 0 {
		err = fmt.Errorf("env %s not found", envName)
		return
	}

	data, err := base64.RawStdEncoding.DecodeString(content)
	if err != nil {
		return
	}

	err = os.WriteFile(output, data, 0666)
	return
}
