let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.2-20220706/packages.dhall sha256:7a24ebdbacb2bfa27b2fc6ce3da96f048093d64e54369965a2a7b5d9892b6031

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
        , version = "3c5536d5cad663c0912bae89205dd1c8934d525b"
        }
      , undefined-or =
        { dependencies =
            [ "prelude"
            , "control"
            , "maybe"
            ]
        , repo =
            "https://github.com/CarstenKoenig/purescript-undefined-or.git"
        , version =
            "5822ab71acc9ed276afd6fa96f1cb3135e376719"
        }
      , uuid =
        { dependencies =
          [ "prelude"
          , "aff"
          , "effect"
          , "maybe"
          , "partial"
          , "spec"
          , "strings"
          ]
        , repo = "https://github.com/megamaddu/purescript-uuid.git"
        , version = "v9.0.0"
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
