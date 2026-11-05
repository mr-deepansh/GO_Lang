package main

import (
	"fmt"
	"strings"
)

const (
	appName = "Go Language Learning"
	version = "1.0.0"
)

func greet(name string) {
	fmt.Printf("Hello, %s!\n", name)
}

func main() {
	const width = 40
	eq := strings.Repeat("=", width)
	dash := strings.Repeat("-", width)

	fmt.Println(eq)
	fmt.Printf("%s\n", center("GO LANGUAGE PROGRAM", width))
	fmt.Println(eq)

	fmt.Printf("%-*s\n", width, fmt.Sprintf("Application : %s", appName))
	fmt.Printf("%-*s\n", width, fmt.Sprintf("Version     : %s", version))

	fmt.Println(dash)
	greet("World")
	fmt.Println(dash)

	fmt.Printf("%-*s\n", width, "Program executed successfully!")
}

// center pads s with spaces so it sits in the middle of width chars.
func center(s string, width int) string {
	if len(s) >= width {
		return s
	}
	pad := width - len(s)
	left := pad / 2
	return strings.Repeat(" ", left) + s + strings.Repeat(" ", pad-left)
}
