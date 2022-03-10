const { isBrowser, isNode, isJsDom } = require("browser-or-node");

exports.detectEnvironment = (browser) => (nodejs) => () => {
  if (isNode || isJsDom) {
    return nodejs;
  } else if (isBrowser) {
    return browser;
  } else {
    throw new Error("Unknown environment");
  }
};
