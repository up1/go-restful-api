package main

import (
  "net/http"
  "fmt"
  "log"
  "encoding/json"
)

type helloWorldResponse struct {
  Header headerResponse  `json:"header"`
  Body bodyResponse `json:"body"`
}

type headerResponse struct {
  Code int `json:"code"`
  Description string `json:"description"`
}

type bodyResponse struct {
  Message string `json:"message"`
}

func main() {
  port := 8080
  http.HandleFunc("/hello", helloHandler)
  log.Printf("Server starting on port %v\n", port)
  log.Fatal(http.ListenAndServe(fmt.Sprintf(":%v", port), nil))
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
  log.Printf("Called helloHandler\n")
  response := helloWorldResponse {
    Header: headerResponse{
      Code: 200,
      Description: "Success",
    },
    Body: bodyResponse { Message: "Hello World" },
  }
  encoder := json.NewEncoder(w)
  encoder.Encode(&response)
}
