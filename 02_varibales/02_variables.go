package main

import (
	"errors"
	"fmt"
	"strings"
)

const (
	BranchCSE = "CSE"
	BranchECE = "ECE"
)

var ErrInvalidProfile = errors.New("invalid student profile")

type Student struct {
	Name        string
	Age         int
	IsDeveloper bool
	Branch      string
}

// StudentConfig holds constructor args — avoids positional argument confusion at call sites.
type StudentConfig struct {
	Name        string
	Age         int
	IsDeveloper bool
	Branch      string
}

func NewStudent(cfg StudentConfig) (*Student, error) {
	name := strings.TrimSpace(cfg.Name)
	if name == "" {
		return nil, fmt.Errorf("%w: name cannot be empty", ErrInvalidProfile)
	}
	return &Student{
		Name:        name,
		Age:         cfg.Age,
		IsDeveloper: cfg.IsDeveloper,
		Branch:      strings.ToUpper(strings.TrimSpace(cfg.Branch)),
	}, nil
}

func (s *Student) IsCSE() bool { return s.Branch == BranchCSE }

// String implements fmt.Stringer — works with fmt.Println, fmt.Sprintf, logs, everywhere.
func (s *Student) String() string {
	status := fmt.Sprintf("Not in CSE (Current: %s)", s.Branch)
	if s.IsCSE() {
		status = "In CSE branch"
	}
	const w = 9 // longest label = "Developer"
	return fmt.Sprintf(`--- Student Profile ---
%-*s : %s
%-*s : %d
%-*s : %t
%-*s : %s
%-*s : %s
-----------------------`,
		w, "Name", s.Name,
		w, "Age", s.Age,
		w, "Developer", s.IsDeveloper,
		w, "Branch", s.Branch,
		w, "Status", status,
	)
}

func main() {
	student, err := NewStudent(StudentConfig{
		Name:        "Deepansh Gangwar",
		Age:         21,
		IsDeveloper: true,
		Branch:      BranchECE,
	})
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		return
	}
	fmt.Println(student)
}
