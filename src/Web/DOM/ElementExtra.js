export function _scrollTo(options) {
  return function (element) {
    return function () {
      element.scrollTo(options);
    };
  };
}

export function _scrollIntoView(options) {
  return function (element) {
    return function () {
      element.scrollIntoView(options);
    };
  };
}

export function throttledOnScroll(waitWindow) {
  return function (element) {
    return function (cb) {
      return function () {
        let lastCall = 0;
        const inner = function () {
          window.requestAnimationFrame(function (currentTime) {
            if (currentTime - lastCall > waitWindow) {
              lastCall = currentTime;
              cb({ left: element.scrollLeft, top: element.scrollTop })();
            }
          });
        };
        element.addEventListener("scroll", inner);
        return function () {
          element.removeEventListener("scroll", inner);
        };
      };
    };
  };
}

export function debouncedOnScroll(waitWindow) {
  return function (element) {
    return function (cb) {
      return function () {
        let timeoutId;
        const inner = function () {
          if (timeoutId) clearTimeout(timeoutId);
          timeoutId = setTimeout(function () {
            cb({ left: element.scrollLeft, top: element.scrollTop })();
          }, waitWindow);
        };
        element.addEventListener("scroll", inner);
        return function () {
          if (timeoutId) clearTimeout(timeoutId);
          element.removeEventListener("scroll", inner);
        };
      };
    };
  };
}
