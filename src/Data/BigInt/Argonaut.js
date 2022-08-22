import bigInt from "big-integer";
import JSONbig from "json-bigint";

export function patchJson() {
  var stringify = JSON.stringify;
  var parse = JSON.parse;
  JSON.stringify = JSONbig.stringify;
  JSON.parse = JSONbig.parse;
  return { stringify: stringify, parse: parse };
}

export function restoreJson(original) {
  JSON.stringify = original.stringify;
  JSON.parse = original.parse;
}

export function decodeBigInt(fail, succ, json) {
  if (Number.isInteger(json) || typeof json === "bigint") {
    return succ(bigInt(json));
  } else {
    return fail;
  }
}

export function encodeBigInt(a) {
  if (JSON.stringify !== JSONbig.stringify) {
    console.warn(
      "Tried to encode BitInt without patching JSON.stringify. Wrap your app in Data.BigInt.Argonaut.withJsonPatch."
    );
    return a.toJSNumber();
  } else {
    return a.value;
  }
}
