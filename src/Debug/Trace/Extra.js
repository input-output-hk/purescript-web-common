/*eslint-env node*/
"use strict";

exports._traceTime = function () {
  return function (label) {
    return function (action) {
      console.time(label);
      var result = action();
      console.timeEnd(label);
      return result;
    };
  };
};
