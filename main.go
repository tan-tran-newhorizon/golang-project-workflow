package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/tan-tran-newhorizon/golang-project-workflow/docs"
)

func main() {
	r := gin.Default()

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})

	r.GET("/hello/:name", func(c *gin.Context) {
		name := c.Param("name")
		c.JSON(http.StatusOK, gin.H{
			"message": "Hello " + name,
		})
	})

	r.Run(":3006")
	// Capture the error returned by r.Run and handle it
	// if err := r.Run(":3006"); err != nil {
	// 	log.Fatalf("Failed to run server: %v", err)
	// }
}
