let upstream =
    https://github.com/purescript/package-sets/releases/download/psc-0.14.4-20211005/packages.dhall sha256:2ec351f17be14b3f6421fbba36f4f01d1681e5c7f46e0c981465c4cf222de5be

let overrides = {=}

let additions =
    { matryoshka =
        { dependencies = [] : List Text
        , repo = "https://github.com/slamdata/purescript-matryoshka.git"
        , version = "v0.4.0"
        }
    , numerics =
        { dependencies = [] : List Text
        , repo = "https://github.com/Proclivis/purescript-numerics"
        , version = "v0.1.2"
        }
    , markdown =
        { dependencies =
            [ "const", "datetime", "functors", "lists", "ordered-collections", "parsing", "partial", "precise", "prelude", "strings", "unicode", "validation" ]
        , repo = "https://github.com/jhbertra/purescript-markdown"
        , version = "a9fbc4c42acf7b4be908832698b69ed558912496"
        }
    , servant-support =
        { dependencies = [] : List Text
        , repo = "https://github.com/input-output-hk/purescript-servant-support"
        , version = "93ea0fa97d0ba04e8d408bbba51749a92d6477f5"
        }
    , json-helpers =
        { dependencies = [] : List Text
        , repo = "https://github.com/input-output-hk/purescript-bridge-json-helpers.git"
        , version = "5f95ac160d58473a77e9c42d612db4f3d7c176ea"
        }
    }

in  upstream // overrides // additions
