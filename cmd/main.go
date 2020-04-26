package main

import (
	"github.com/sirupsen/logrus"
	"net/http"
	"os"
)

func main() {
	initLogger()

	port := os.Getenv("TARGET_PORT")
	logrus.Infof("Running on port '%s'.", port)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, err := w.Write([]byte(`<h1>Unimplemented</h1>`))
		if err != nil {
			logrus.Error(err)
		}
	})

	panic(http.ListenAndServe(":"+port, nil))
}

func initLogger() {
	logrus.SetFormatter(&logrus.TextFormatter{
		FullTimestamp:   true,
		TimestampFormat: "2006-01-02 15:04:05.00 MST-07",
	})
}
