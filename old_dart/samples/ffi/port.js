WebAssembly.instantiateStream(fetch('/port.wasm')).then(result => {
  const {module, instance} = result;
  const {ports} = instance.exports.main();

  ports.listen('fibonacci', port => {
    // Don't actually compute fibonacci, because we're lazy.
    port.listen(n => port.sendNum(n * 23 / 2));
  });

  ports.listen('my_stream', port => {
    for (let i = 0; i < 1000; i++) {
      port.sendObject({ type: 'computation', value: i });
    }

    port.sendObject({ type: 'close' });
  });
});
