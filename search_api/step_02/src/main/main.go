package main

import (
	"log"
	"net/http"
	"os"

	"api"
	"repository"
)

func main() {
	serverURI := "localhost"
	if os.Getenv("MONGODB_SERVER") != "" {
		serverURI = os.Getenv("MONGODB_SERVER")
	}

	store, err := repository.NewMongoStore(serverURI)
	if err != nil {
		log.Fatal(err)
	}

	handler := api.Search{DataStore: store}
	err = http.ListenAndServe(":8080", &handler)
	if err != nil {
		log.Fatal(err)
	}
}
