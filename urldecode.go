package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"log"
	"net/url"
)

func main() {
	fmt.Println("data is from pipe")
	bytes, _ := ioutil.ReadAll(os.Stdin)
	str := string(bytes)
	fmt.Print(str)
	path := (str)
	unescapedPath, err := url.PathUnescape(path)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(unescapedPath)
}
