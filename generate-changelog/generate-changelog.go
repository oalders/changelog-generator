package main

import (
	"fmt"

	"github.com/davecgh/go-spew/spew"
	giturls "github.com/whilp/git-urls"
	"gopkg.in/src-d/go-git.v4"
)

func main() {
	repo, err := git.PlainOpen("../")
	if err != nil {
		spew.Dump(err)
	}

	remotes, _ := repo.Remotes()
	spew.Dump(remotes[0].Config())

	var originURL string
	for i, v := range remotes {
		fmt.Printf("i: %v, name: %v urls: %v", i, v.Config().Name, v.Config().URLs)
		if v.Config().Name == "origin" {
			originURL = v.Config().URLs[0]
			fmt.Printf("got it %v\n", originURL)
			break
		} else {
			fmt.Printf("did not get it %v\n", v.Config().Name)
		}
	}
	spew.Dump(originURL)
	url, err := giturls.Parse(originURL)
	if err != nil {
		spew.Dump(err)
	}
	spew.Dump(url.EscapedPath())
}
