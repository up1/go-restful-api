package main

import (
  "net/http"
  "fmt"
  "log"
)

func main() {
  port := 8080
  http.HandleFunc("/hello", helloHandler)
  log.Printf("Server starting on port %v\n", port)
  log.Fatal(http.ListenAndServe(fmt.Sprintf(":%v", port), nil))
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
  log.Printf("Called helloHandler\n")
  fmt.Fprint(w, "Hello World")
}
