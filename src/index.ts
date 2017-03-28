import * as game from './game.wat';

declare const WebAssembly: any;

window.onload = init;

function init() {
  instantiate(game, {}).then(instance => {
    update(instance);
  });
}

function update(instance) {
  instance.exports.update();
  requestAnimationFrame(() => update(instance));
}

function instantiate(wastBuffer, imports) {
  return WebAssembly.instantiate(wastBuffer, imports).then(result => result.instance);
}
