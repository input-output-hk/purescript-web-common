export function _traceTime() {
  return function (label) {
    return function (action) {
      console.time(label);
      var result = action();
      console.timeEnd(label);
      return result;
    };
  };
}
