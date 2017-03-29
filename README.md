wasm-game-by-hand ([Demo](https://abagames.github.io/wasm-game-by-hand/index.html))
======================
Write a WebAssembly (wast) game by hand.

### Architecture

```
WebAssembly                             JavaScript
 game.wat     ----------------           index.ts
=====         I              I          =========
i   i ---> M  I              I  U --->  i  Can  i
i G i         I     VRAM     I  i       i  vas  i
i a i      e  I              I  n       =========
i m i         I              I  t
i e i      m  I              I  8
i   i         ----------------  A 
i L i      o  I              I  r
i o i         I              I  r       =========
i g i <--- r  I    Key Map   I  a <---  i Key   i
i i i         I              I  y       i Event i
i c i      y  I              I          =========
i   i         I              I
i   i         ----------------    
i   i
i $update <--                       <-- request
i   i                                   Animation
i   i                                   Frame
i   i
i $random -->                      --> Math.
i   i                                  random
=====
```

### Reference

[wasm-by-hand] (https://github.com/rhmoller/wasm-by-hand)
