package main

import (
	"fmt"

	"arpitmalik832/golang-playground/octocat"
)

func main() {
	// fmt.Println(quote.Opt())
	// fmt.Println("The meaning of life:", life.Meaning())

	var o octocat.Octocat
	err := octocat.Get(&o)

	if err != nil {
		panic(err)
	}

	fmt.Printf("%s, based in %s, has %d followers. For more info, see: %s.\n", o.Name, o.Location, o.Followers, o.URL)
}
