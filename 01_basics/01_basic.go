package main

import "fmt"

const (
	appName = "Go Language Learning"
	version = "1.0.0"
)

// greet prints a welcome message.
func greet(name string) {
	fmt.Printf("Hello, %s!\n", name)
}

func main() {
	fmt.Println("================================")
	fmt.Println("       GO LANGUAGE PROGRAM      ")
	fmt.Println("================================")

	fmt.Printf("Application : %s\n", appName)
	fmt.Printf("Version     : %s\n", version)

	fmt.Println("--------------------------------")

	greet("World")

	fmt.Println("--------------------------------")
	fmt.Println("Program executed successfully!")
}
