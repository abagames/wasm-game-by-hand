(module
  (func $random (import "imports" "random") (result f32))
  (memory (export "ram") 1)

  (global $scene (mut i32) (i32.const 0))
  (global $ticks (mut i32) (i32.const 0))
  (global $score (mut f32) (f32.const 0))
  (global $scroll_ticks (mut f32) (f32.const 0))
  (global $scroll_speed (mut f32) (f32.const 40))
  (global $add_rock_ticks (mut f32) (f32.const 0))
  (global $add_rock_speed (mut f32) (f32.const 80))
  (global $player_x (mut f32) (f32.const 0))
  (global $player_speed (mut f32) (f32.const 0))

  (func $begin_title
    (set_global $scene (i32.const 0))
    (if (f32.le (get_global $score) (f32.const 0))
      (then
        (set_global $scroll_speed (f32.const 40))
        (set_global $add_rock_speed (f32.const 80))
      )
      (else
        (call $clear_screen)
      )
    )
  )

  (func $begin_game
    (set_global $scene (i32.const 1))
    (set_global $scroll_ticks (f32.const 0))
    (set_global $scroll_speed (f32.const 20))
    (set_global $add_rock_ticks (f32.const 0))
    (set_global $add_rock_speed (f32.const 30))
    (set_global $player_x (f32.const 7))
    (set_global $player_speed (f32.const 0.1))
    (set_global $score (f32.const 0))
    (call $clear_screen)
  )

  (func $begin_game_over
    (set_global $scene (i32.const 2))
    (set_global $ticks (i32.const 0))
    (set_global $scroll_ticks (f32.const 9999999))
    (set_global $add_rock_ticks (f32.const 9999999))
  )

  (func $update (export "update")
    (if (i32.eq (get_global $scene) (i32.const 0))
      (then
        (call $show_score)
      )
    )
    (if (i32.eq (get_global $scene) (i32.const 1))
      (then
        (call $move_player)
        (set_global $scroll_speed (f32.sub (get_global $scroll_speed) (f32.const 0.007)))
        (set_global $add_rock_speed (f32.sub (get_global $add_rock_speed) (f32.const 0.011)))
        (set_global $player_speed (f32.add (get_global $player_speed) (f32.const 0.0001)))
        (set_global $score (f32.add (get_global $score) (f32.const 0.03)))
      )
    )
    (if (i32.eq (get_global $scene) (i32.const 2))
      (then
        (call $disp_player
          (i32.gt_u (i32.rem_u (get_global $ticks) (i32.const 20)) (i32.const 10))
        )
        (if (i32.gt_u (get_global $ticks) (i32.const 90))
          (then
            (call $begin_title)
          )
        )
      )
    )
    (set_global $scroll_ticks (f32.sub (get_global $scroll_ticks) (f32.const 1)))
    (if (f32.le (get_global $scroll_ticks) (f32.const 0))
      (then
        (call $scroll)
        (set_global $scroll_ticks
          (f32.add (get_global $scroll_ticks) (get_global $scroll_speed))
        )
      )
    )
    (set_global $add_rock_ticks (f32.sub (get_global $add_rock_ticks) (f32.const 1)))
    (if (f32.le (get_global $add_rock_ticks) (f32.const 0))
      (then
        (call $add_rock)
        (set_global $add_rock_ticks
          (f32.add (get_global $add_rock_ticks) (get_global $add_rock_speed))
        )
      )
    )
    (set_global $ticks (i32.add (get_global $ticks) (i32.const 1)))
    (if
      (i32.and
        (i32.eq (get_global $scene) (i32.const 0))
        (i32.or
          (i32.load8_u (i32.const 293))
          (i32.load8_u (i32.const 295))
        )
      )
      (then
        (call $begin_game)
      )
    )
  )

  (func $move_player
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
    (call $disp_player (i32.const 1))
  )

  (func $disp_player (param $is_visible i32)
    (local $o i32)
    (call $clear_line (i32.const 15))
    (if (i32.eqz (get_local $is_visible))
      (then
        (return)
      )
    )
    (set_local $o (i32.add (i32.trunc_u/f32 (get_global $player_x)) (i32.const 240)))
    (i32.store8 (get_local $o) (i32.const 1))
  )

  (func $add_rock
    (local $rnd i32)
    (set_local $rnd (i32.trunc_u/f32 (f32.mul (call $random) (f32.const 16))))
    (i32.store8 (get_local $rnd) (i32.const 1))
  )

  (func $scroll
    (local $from i32)
    (local $to i32)
    (set_local $from (i32.const 240))
    (set_local $to (i32.const 256))
    (block $collide_break
      (loop $collide
        (set_local $from (i32.sub (get_local $from) (i32.const 1)))
        (set_local $to (i32.sub (get_local $to) (i32.const 1)))
        (if
          (i32.and
              (i32.load8_u (get_local $from))
              (i32.load8_u (get_local $to))
          )
          (then
            (call $begin_game_over)
            (return)
          )
        )
        (br_if $collide_break (i32.eq (get_local $to) (i32.const 240)))
        (br $collide)
      )
    )
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

  (func $clear_screen
    (local $i i32)
    (set_local $i (i32.const 256))
    (block $clear_break
      (loop $clear
        (set_local $i (i32.sub (get_local $i) (i32.const 1)))
        (i32.store8 (get_local $i) (i32.const 0))
        (br_if $clear_break (i32.eqz (get_local $i)))
        (br $clear)
      )
    )
  )

  (func $show_score
    (local $i i32)
    (local $o i32)
    (set_local $i (i32.trunc_u/f32 (get_global $score)))
    (set_local $o (i32.const 0))
    (block $clear_break
      (loop $clear
        (br_if $clear_break (i32.eqz (get_local $i)))
        (i32.store8 (get_local $o) (i32.const 1))
        (set_local $o (i32.add (get_local $o) (i32.const 1)))
        (set_local $i (i32.sub (get_local $i) (i32.const 1)))
        (br $clear)
      )
    )
  )
)
