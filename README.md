# shrub
🌳 A high-level, strongly-typed language that compiles to WebAssembly.

## Example

Functions 
```shrub
let add x y = x + y

let rec fib n =
    if (n == 0 || n == 1)
        n
    else
        fib (n - 1) + fib (n - 2)
```

Types/Matching

```shrub
type Animal = variant
    | Dog { name: String }
    | Human { name: String, thumbCount: Num }

let woof anim = anim
    | Dog -> "Woof, I am " ^ anim.name
    | Human -> "I am a human. I do not woof."

let () =
    let billy = Human {name: "Billy", thumbCount: 2};
    print (woof billy)
```