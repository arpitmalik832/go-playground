package main

import (
	"fmt"

	"arpitmalik832/golang-playground/octocat"
)

func main() {
	greeting()

	var o octocat.Octocat
	err := octocat.Get(&o)

	if err != nil {
		panic(err)
	}

	fmt.Printf("%s, based in %s, has %d followers. For more info, see: %s.\n", o.Name, o.Location, o.Followers, o.URL)
}
