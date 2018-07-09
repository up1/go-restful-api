package repository

import (
	"gopkg.in/mgo.v2"
	"model"
)

// Store is an interface used for interacting with the backend datastore
type Store interface {
	Search(name string) []model.Product
}

// MongoStore is a MongoDB data store which implements the Store interface
type MongoStore struct {
	session *mgo.Session
}

// Search returns Products from the MongoDB instance which have the name
func (m *MongoStore) Search(name string) []model.Product {
	s := m.session.Clone()
	defer s.Close()

	var results []model.Product
	c := s.DB("productserver").C("products")
	err := c.Find(model.Product{Name: name}).All(&results)
	if err != nil {
		return nil
	}

	return results
}

// NewMongoStore creates an instance of MongoStore with the given connection string
func NewMongoStore(connection string) (*MongoStore, error) {
	session, err := mgo.Dial(connection)
	if err != nil {
		return nil, err
	}

	return &MongoStore{session: session}, nil
}
