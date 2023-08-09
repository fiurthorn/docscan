#! /bin/sh

go mod download && go run magefiles/cmd/mage.go -compile ../mage
