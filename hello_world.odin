package main

import "core:fmt"

main :: proc() {
    fmt.println("Hello World!")

    x := "I'm doing great!"

    defer fmt.println(x)
    fmt.println("How are you doing?")

    fmt.println("Cause me?")
}
