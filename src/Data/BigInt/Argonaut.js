"use strict";

exports.decodeBigInt = function (fail, succ, json) {
    if (typeof json === "number" || typeof json === "bigint") {
        return succ(BigNumber(BigInt(json)));
    } else {
        return fail;
    }
}

exports.encodeBigInt = function (a) {
    return BigInt(json);
}
