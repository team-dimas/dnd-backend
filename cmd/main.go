package main

import (
	"github.com/sirupsen/logrus"
)

func main() {
	initLogger()

	logrus.Warn("Unimplemented.")
}

func initLogger() {
	logrus.SetFormatter(&logrus.TextFormatter{
		FullTimestamp:   true,
		TimestampFormat: "2006-01-02 15:04:05.00 MST-07",
	})
}
