"use strict";

var bigInt = require("big-integer");
var JSONbig = require("json-bigint");

exports.patchJson = function () {
  var stringify = JSON.stringify;
  var parse = JSON.parse;
  JSON.stringify = JSONbig.stringify;
  JSON.parse = JSONbig.parse;
  return { stringify: stringify, parse: parse };
};

exports.restoreJson = function (original) {
  JSON.stringify = original.stringify;
  JSON.parse = original.parse;
};

exports.decodeBigInt = function (fail, succ, json) {
  if (Number.isInteger(json) || typeof json === "bigint") {
    return succ(bigInt(json));
  } else {
    return fail;
  }
};

exports.encodeBigInt = function (a) {
  if (JSON.stringify !== JSONbig.stringify) {
    console.warn(
      "Tried to encode BitInt without patching JSON.stringify. Wrap your app in Data.BigInt.Argonaut.withJsonPatch."
    );
    return a.toJSNumber();
  } else {
    return a.value;
  }
};
