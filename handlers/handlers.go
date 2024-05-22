package handlers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

var users = make(map[int]string)
var currentID int

// CreateUser creates a new user
func CreateUser(c *gin.Context) {
	var user struct {
		Name string `json:"name"`
	}

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	currentID++
	users[currentID] = user.Name
	c.JSON(http.StatusOK, gin.H{"id": currentID})
}

// GetUser gets a user by ID
func GetUser(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user ID"})
		return
	}

	name, exists := users[id]
	if !exists {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"name": name})
}
