package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tan-tran-newhorizon/golang-project-workflow/handlers"
)

func main() {
	// Seed the random number generator with the current time
	rand.Seed(time.Now().UnixNano())

	// Generate a random token for authentication
	token := generateToken()
	fmt.Println("Generated token:", token)

	router := gin.Default()

	// Basic health check endpoint
	router.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	// User endpoints
	router.POST("/users", handlers.CreateUser)
	router.GET("/users/:id", handlers.GetUser)

	// Example of an unhandled error (errcheck will catch this)
	f, _ := os.Open("somefile.txt") // This is intentionally incorrect
	defer f.Close()

	router.Run(":8022")
}

func generateToken() string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	token := make([]byte, 32)
	for i := range token {
		token[i] = charset[rand.Intn(len(charset))]
	}
	return string(token)
}
