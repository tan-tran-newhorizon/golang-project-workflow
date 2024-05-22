// In this example, models.go is empty, but you could define your data models here if needed.

package models

// User represents a user in the system
type User struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}
