// based on: https://github.com/rhmoller/wast-loader
var wast2wasm = require("wast2wasm");

module.exports = function (wast) {
  this.cacheable();
  var callback = this.async();

  wast2wasm(wast, true).then(function (out) {
    var buffer = Buffer.from(out.buffer);
    buffer[4] = 1; // patch the version number to 0x01
    var hex = buffer.toString("hex");
    callback(null, "module.exports = Buffer.from('" + hex + "', 'hex');");
  }).catch(function (err) {
    // Add a callback for an error handling
    callback(err, null);
  });
};
