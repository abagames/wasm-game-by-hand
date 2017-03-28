(module
  (memory (export "ram") 1)
  (func (export "update")
    (if (i32.load8_u (i32.const 293))
      (then (i32.store8 (i32.const 0) (i32.const 1)))
      (else (i32.store8 (i32.const 0) (i32.const 0)))
    )
  )
)
