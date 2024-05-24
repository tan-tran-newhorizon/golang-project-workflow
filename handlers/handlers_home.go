package handlers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

var homes = make(map[int]string)
var currentHomeID int

// CreateHome creates a new home
func CreateHome(c *gin.Context) {
	var home struct {
		Address string `json:"address"`
	}

	if err := c.ShouldBindJSON(&home); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	currentHomeID++
	homes[currentHomeID] = home.Address
	c.JSON(http.StatusOK, gin.H{"id": currentHomeID})
}

// GetHome gets a home by ID
func GetHome(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid home ID"})
		return
	}

	address, exists := homes[id]
	if !exists {
		c.JSON(http.StatusNotFound, gin.H{"error": "home not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"address": address})
}
