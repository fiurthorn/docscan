@echo off
go mod download
go run cmd/mage/mage.go -compile ../mage.exe
