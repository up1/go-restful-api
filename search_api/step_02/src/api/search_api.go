package api

import (
	"encoding/json"
	"net/http"

	"model"
	"repository"
)

type searchRequest struct {
	Query string `json:"q"`
}

type searchResponse struct {
	Products []model.Product `json:"products"`
}

// Search is an http handler for our microservice
type Search struct {
	DataStore repository.Store
}

func (s *Search) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	defer r.Body.Close()

	request := new(searchRequest)
	err := decoder.Decode(request)
	if err != nil || len(request.Query) < 1 {
		http.Error(rw, "Bad Request", http.StatusBadRequest)
		return
	}

	products := s.DataStore.Search(request.Query)

	encoder := json.NewEncoder(rw)
	encoder.Encode(searchResponse{Products: products})
}
