import * as game from './game.wat';

declare const WebAssembly: any;
let context: CanvasRenderingContext2D;
let ram: Uint8Array;

window.onload = init;

function init() {
  instantiate(game, {
    imports: {
      random: () => Math.random()
    }
  }).then(instance => {
    new WebAssembly.Memory({ initial: 512 / 4 });
    ram = new Uint8Array(instance.exports.ram.buffer);
    document.onkeydown = e => {
      ram[e.keyCode + 256] = 1;
    };
    document.onkeyup = e => {
      ram[e.keyCode + 256] = 0;
    };
    const canvas = <HTMLCanvasElement>document.getElementById('main');
    context = canvas.getContext('2d');
    context.fillStyle = 'white';
    update(instance);
  });
}

function update(instance) {
  instance.exports.update();
  context.clearRect(0, 0, 16, 16);
  for (let i = 0; i < 256; i++) {
    const x = i % 16;
    const y = Math.floor(i / 16);
    if (ram[i] > 0) {
      context.fillRect(x, y, 1, 1);
    }
  }
  requestAnimationFrame(() => update(instance));
}

function instantiate(wastBuffer, imports) {
  return WebAssembly.instantiate(wastBuffer, imports).then(result => result.instance);
}
