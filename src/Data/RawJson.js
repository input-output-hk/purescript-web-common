/*eslint-env node*/
/*global exports gtag*/
'use strict';

exports._pretty = function (str) {
    return JSON.stringify(
        JSON.parse(str),
        null,
        2
    );
};

exports.unsafeStringify = function (a) {
    return JSON.stringify(a);
};
