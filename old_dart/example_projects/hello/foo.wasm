(module
  (func $yep (param $nope i32) (result i32)
    i32.const 2
    get_local $nope
    i32.add
  )
  (func $oops (result i32)
    i32.const 2
    call $yep
  )
  (func $line (param $x i32) (result i32)
    i32.const 5
    get_local $x
    i32.const 3
    i32.mul
    i32.add
  )
  (func $main (result i32)
    i32.const 32
    call $line
  )
  (export "yep" (func $yep))
  (export "oops" (func $oops))
  (export "line" (func $line))
  (export "main" (func $main))
)
