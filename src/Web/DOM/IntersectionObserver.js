export function _intersectionObserver(config) {
  return function (cb) {
    return function () {
      return new IntersectionObserver(function (entries, observer) {
        return cb(entries)(observer)();
      }, config);
    };
  };
}

export function observe(element) {
  return function (observer) {
    return function () {
      return observer.observe(element);
    };
  };
}

export function unobserve(element) {
  return function (observer) {
    return function () {
      return observer.unobserve(element);
    };
  };
}

export function disconnect(observer) {
  return function () {
    return observer.disconnect();
  };
}
