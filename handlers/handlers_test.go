package handlers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strconv"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// TestCreateUser checks the /users POST endpoint
func TestCreateUser(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := setupRouter()

	w := httptest.NewRecorder()
	body := bytes.NewBufferString(`{"name": "John Doe"}`)
	req, _ := http.NewRequest("POST", "/users", body)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), `"id"`)
}

// TestGetUser checks the /users/:id GET endpoint
func TestGetUser(t *testing.T) {
	gin.SetMode(gin.TestMode)
	router := setupRouter()

	// Create a user first
	w := httptest.NewRecorder()
	body := bytes.NewBufferString(`{"name": "John Doe"}`)
	req, _ := http.NewRequest("POST", "/users", body)
	router.ServeHTTP(w, req)

	// Get the user ID from the response
	assert.Equal(t, http.StatusOK, w.Code)
	var jsonResponse map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &jsonResponse)
	assert.NoError(t, err)
	userID := jsonResponse["id"].(float64)

	// Test the GET /users/:id endpoint
	w = httptest.NewRecorder()
	req, _ = http.NewRequest("GET", "/users/"+strconv.Itoa(int(userID)), nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), `"name"`)
}

// setupRouter sets up the router for testing
func setupRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	router := gin.Default()

	router.POST("/users", CreateUser)
	router.GET("/users/:id", GetUser)

	return router
}
