let
  url = "https://github.com/input-output-hk/flake-compat/archive/20f79e3976b76a37090fbeec7b49dc08dac96b8e.tar.gz";
  sha256 = "1lq1a2hrzcmybzxkl0qpzaylgzn4qpw6nngs5qggddgnawp1klkn";
  src = ./.;
  flake = import (fetchTarball { inherit url sha256; }) { inherit src; };
in
flake.shellNix.default
