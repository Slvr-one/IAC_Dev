package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	name := fmt.Sprintf("%s-%d", randomWord(), time.Now().Unix())
	result := map[string]string{
		"name": name,
	}
	jsonResult, _ := json.Marshal(result)
	fmt.Println(string(jsonResult))
}

func randomWord() string {
	words := []string{"apple", "banana", "orange", "grape", "strawberry"}
	return words[rand.Intn(len(words))]
}
