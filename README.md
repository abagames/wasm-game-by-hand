wasm-game-by-hand ([Demo](https://abagames.github.io/wasm-game-by-hand/index.html))
======================
Write a WebAssembly (wast) game by hand.

### Architecture

```
WebAssembly                             JavaScript
 game.wat     ┌──────────────┐           index.ts
┌───┐         │              │          ┌───────┐
│   │ ───→ M  │              │  U ────→   Can  │
│ G │         │     VRAM     │  i       │  vas  │
│ a │      e  │              │  n       └───────┘
│ m │         │              │  t
│ e │      m  │              │  8
│   │         ┝──────────────┥  A 
│ L │      o  │              │  r
│ o │         │              │  r       ┌───────┐
│ g │ ←─── r  │    Key Map   │  a ←────  Key   │
│ i │         │              │  y       │ Event │
│ c │      y  │              │          └───────┘
│   │         │              │
│   │         └──────────────┘    
│   │
│ $update ←──────────────────────────── request
│   │                                   Animation
│   │                                   Frame
│   │
│ $random ────────────────────────────→ Math.
│   │                                  random
└───┘
```

### Reference

[wasm-by-hand](https://github.com/rhmoller/wasm-by-hand)
