"use strict";

const bigInt = require("big-integer");

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
