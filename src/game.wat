(module
  (func $random (import "imports" "random") (result f32))
  (memory (export "ram") 1)

  (global $ticks (mut i32) (i32.const 0))
  (global $scroll_ticks (mut f32) (f32.const 0))
  (global $scroll_speed (mut f32) (f32.const 20))
  (global $player_x (mut f32) (f32.const 7))
  (global $player_speed (mut f32) (f32.const 0.1))

  (func $update (export "update")
    (call $move_player)
    (set_global $scroll_ticks (f32.sub (get_global $scroll_ticks) (f32.const 1)))
    (if (f32.le (get_global $scroll_ticks) (f32.const 0))
      (then
        (call $scroll)
        (set_global $scroll_ticks (get_global $scroll_speed))
      )
    )
    (set_global $ticks (i32.add (get_global $ticks) (i32.const 1)))
  )

  (func $move_player
    (local $o i32)
    (call $clear_line (i32.const 15))
    (if (i32.load8_u (i32.const 293)) 
      (then 
        (set_global $player_x (f32.sub (get_global $player_x) (get_global $player_speed)))
      )
    )
    (if (i32.load8_u (i32.const 295))
      (then 
        (set_global $player_x (f32.add (get_global $player_x) (get_global $player_speed)))
      )
    )
    (if (f32.lt (get_global $player_x) (f32.const 0))
      (then
        (set_global $player_x (f32.add (get_global $player_x) (f32.const 16)))
      )
    )
    (if (f32.gt (get_global $player_x) (f32.const 16))
      (then
        (set_global $player_x (f32.sub (get_global $player_x) (f32.const 16)))
      )
    )
    (set_local $o (i32.add (i32.trunc_u/f32 (get_global $player_x)) (i32.const 240)))
    (i32.store8 (get_local $o) (i32.const 1))
  )

  (func $scroll
    (local $from i32)
    (local $to i32)
    (local $rnd i32)
    (set_local $from (i32.const 224))
    (set_local $to (i32.const 240))
    (block $slide_break
      (loop $slide
        (set_local $from (i32.sub (get_local $from) (i32.const 1)))
        (set_local $to (i32.sub (get_local $to) (i32.const 1)))
        (i32.store8 (get_local $to) (i32.load8_u (get_local $from)))
        (br_if $slide_break (i32.eqz (get_local $from)))
        (br $slide)
      )
    )
    (call $clear_line (i32.const 0))
    (set_local $rnd (i32.trunc_u/f32 (f32.mul (call $random) (f32.const 16))))
    (i32.store8 (get_local $rnd) (i32.const 1))
  )

  (func $clear_line (param $y i32)
    (local $i i32)
    (local $o i32)
    (set_local $i (i32.const 16))
    (set_local $o (i32.mul (get_local $y) (i32.const 16)))
    (block $clear_break
      (loop $clear
        (br_if $clear_break (i32.eqz (get_local $i)))
        (i32.store8 (get_local $o) (i32.const 0))
        (set_local $i (i32.sub (get_local $i) (i32.const 1)))
        (set_local $o (i32.add (get_local $o) (i32.const 1)))
        (br $clear)
      )
    )
  )
)
