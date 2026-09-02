package main

import "core:fmt"

Vector3 :: distinct [3]f32

main ::proc() {
    a := Vector3{1, 2, 3}
    b := Vector3{5, 6, 7}
    c := (a * b)/2 + 1
    d := c.x + c.y + c.z
    fmt.printf("%.1f\n", d)

    x := cross(a, b)
    fmt.println(cross(a, b))
    fmt.println(short_cross(a, b))
}

cross :: proc(left, right: Vector3) -> Vector3 {
    i := swizzle(left, 1, 2, 0) * swizzle(right, 2, 0, 1)
    j := swizzle(left, 2, 0, 1) * swizzle(right, 1, 2, 0)
    return i - j
}

short_cross :: proc(left, right: Vector3) -> (out: Vector3) {
    i := left.yzx * right.zxy
    j := left.zxy * right.yzx
    out = i - j
    return
}

