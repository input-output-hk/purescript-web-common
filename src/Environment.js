const { isBrowser, isNode } = require("browser-or-node");

exports.detectEnvironment = (browser) => (nodejs) => () => {
  if (isBrowser) {
    return browser;
  } else if (isNodeJs) {
    return nodejs;
  } else {
    throw new Error("Unknown environment");
  }
};
