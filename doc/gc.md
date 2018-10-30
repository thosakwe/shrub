# Garbage Collection
Shrub abstracts away the concept of memory management from programmers.

Values passed between functions exist as doubles (A.K.A. NaN boxing); primitive
types, namely Num, Bool, Null, and specific other cases, are passed as-is, without any boxing.

Complex data, however, may not fit into a double, and is thus represented as a pointer to data in memory/heap.
In some languages, you are responsible for releasing held memory; Shrub abstracts that away, and performs
both allocation and deallocation automatically.

Take, for example, a program with a composite class `C(A, B)`:

```shrub
type A = class {}, B = class {}

type C = class {
    a: A;
    b: B;
    constructor(this.a, this.b);
}
```

```shrub
main() {
    // Allocates a new C on the heap.
    // The total size of C = (sizeof(A) + sizeof(B)).
    var c = new C
}
```

When `c` is allocated, it is `marked`
(it's just a mark-sweep GC). The important question to ask is,
when should blocks be swept?

At least at this point, the answer seems simple, and can be
generalized into a few rules:
* A pointer is alive throughout the entire scope it was created
in, ex. `c` is guaranteed to be marked until the end of `main`.
* By extension of the above, a pointer used as a function
parameter is guaranteed to be marked until the end of that
function.
* Marking any of an instance's members should actually just
mark the instance itself, ex. a reference to `c.a` just becomes
a reference to `c`.

There are a few complications, however. Closures are one. A
potential implementation of a closure might actually create
a custom class behind-the-scenes. This closure class would
have each variable it captures as a member; therefore, accessing
captured variables would just run through the GC like any other
object.

The most complicated problem, however, is the problem of
circular references. What if two objects point to each other?
It is certainly possible for a static analyzer to detect a
reference cycle. The question then becomes, how can this be
handled?

The answer is to implement a combination between a simple
mark-and-sweep and a more advanced tracing garbage collector.

In fact, Shrub's GC will mostly rely on generational GC
techniques, occasionally stepping into mark-and-sweep, and
at times compacting the memory to avoid fragmentation.