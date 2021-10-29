let upstream =
    https://github.com/purescript/package-sets/releases/download/psc-0.14.4-20211005/packages.dhall sha256:2ec351f17be14b3f6421fbba36f4f01d1681e5c7f46e0c981465c4cf222de5be

let overrides = {=}

let additions =
    { markdown =
        { dependencies =
            [ "arrays"
            , "assert"
            , "bifunctors"
            , "console"
            , "const"
            , "control"
            , "datetime"
            , "effect"
            , "either"
            , "enums"
            , "foldable-traversable"
            , "functors"
            , "identity"
            , "integers"
            , "lists"
            , "maybe"
            , "newtype"
            , "parsing"
            , "partial"
            , "precise"
            , "prelude"
            , "psci-support"
            , "strings"
            , "tuples"
            , "unfoldable"
            , "unicode"
            , "validation"
            ]
        , repo = "https://github.com/input-output-hk/purescript-markdown"
        , version = "022d8afd0d9e0ef8114da9e9ef5a67d9ffc86a29"
        }
    , servant-support =
        { dependencies =
            [ "affjax"
            , "argonaut-codecs"
            , "argonaut-core"
            , "prelude"
            , "psci-support"
            ]
        , repo = "https://github.com/input-output-hk/purescript-servant-support"
        , version = "93ea0fa97d0ba04e8d408bbba51749a92d6477f5"
        }
    , json-helpers =
        { dependencies = [] : List Text
        , repo = "https://github.com/input-output-hk/purescript-bridge-json-helpers.git"
        , version = "16de087fde6e2d07e6bdae51383131ab81efa82d"
        }
    }

in  upstream // overrides // additions
