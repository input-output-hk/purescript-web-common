let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.4-20211028/packages.dhall sha256:df6486e7fad6dbe724c4e2ee5eac65454843dce1f6e10dc35e0b1a8aa9720b26

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
      , json-helpers =
        { dependencies =
          [ "aff"
          , "argonaut-codecs"
          , "argonaut-core"
          , "arrays"
          , "bifunctors"
          , "contravariant"
          , "control"
          , "effect"
          , "either"
          , "enums"
          , "foldable-traversable"
          , "foreign-object"
          , "maybe"
          , "newtype"
          , "ordered-collections"
          , "prelude"
          , "profunctor"
          , "psci-support"
          , "quickcheck"
          , "record"
          , "spec"
          , "spec-quickcheck"
          , "transformers"
          , "tuples"
          , "typelevel-prelude"
          ]
        , repo = "https://github.com/input-output-hk/purescript-bridge-json-helpers.git"
        , version = "60615c36abaee16d8dbe09cdd0e772e6d523d024"
        }
      }

in  upstream // overrides // additions
