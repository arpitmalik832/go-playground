package octocat

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

// Octocat type represents the Octocat user
type Octocat struct {
	Login     string
	ID        int
	URL       string `json:"html_url"`
	Name      string
	Followers int
	Following int
	Company   string
	Location  string
}

// Get retrieves the @octocat profile from GitHub.com
func Get(octocat *Octocat) error {
	url := "https://api.github.com/users/octocat"

	// Instantiate an HTTP client so we can add request headers
	client := &http.Client{}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return err
	}
	req.Header.Add("User-Agent", "arpitmalik832/golang-playground")
	req.Header.Add("Authorization", fmt.Sprintf("bearer %s", os.Getenv("GITHUB_TOKEN")))

	// Perform the request
	resp, err := client.Do(req)
	if err != nil {
		return err
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("Unexpected status code, %d, when fetching %s", resp.StatusCode, url)
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	err = json.Unmarshal(body, octocat)
	if err != nil {
		return err
	}

	return nil
}
