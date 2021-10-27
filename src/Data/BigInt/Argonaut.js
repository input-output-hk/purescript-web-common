"use strict";

var bigInt = require("big-integer");
var JSONbig = require("json-bigint");

exports.patchJson = function () {
    var stringify = JSON.stringify;
    var parse = JSON.parse;
    JSON.stringify = JSONbig.stringify;
    JSON.parse = JSONbig.parse;
    return { stringify: stringify, parse: parse };
}

exports.restoreJson = function (original) {
    JSON.stringify = original.stringify;
    JSON.parse = original.parse;
}

exports.decodeBigInt = function (fail, succ, json) {
    if (typeof json === "number" || typeof json === "bigint") {
        return succ(bigInt(json));
    } else {
        return fail;
    }
}

exports.encodeBigInt = function (a) {
    return bigInt(a);
}
