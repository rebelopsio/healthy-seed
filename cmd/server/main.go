package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"

	"gopkg.in/yaml.v2"
)

// Function to handle errors. From Go by Example
func check(e error) {
	if e != nil {
		panic(e)
	}
}

// Version place holder
var Version = "0.0.1"

// Create a struct for config file
type envConfig struct {
	DSN           string `yaml:"dsn"`
	JwtSigningKey string `yaml:"jwt_signing_key"`
}

// Create a var for the struct
var configParams envConfig

func main() {
	// Config file flag
	var configPtr string
	flag.StringVar(&configPtr, "config", "local.yml", "config file path")
	flag.Parse()
	dat, err := os.ReadFile(configPtr)
	check(err)

	err = yaml.Unmarshal(dat, &configParams)
	check(err)

	// fmt.Println(&configParams.DSN, &configParams.JwtSigningKey)
	http.HandleFunc("/", handler) // Each request calls handler
	log.Fatal(http.ListenAndServe("localhost:8000", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "URL.Path = %q\nDSN = %q\nJWT = %q\n", r.URL.Path, configParams.DSN, configParams.JwtSigningKey)
}
