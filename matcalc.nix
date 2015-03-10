# Template file!
{ cabal }:

cabal.mkDerivation (self: {
  pname = "matcalc";
  version = "0.1.0.0";
  src = ./.;
  buildDepends = [];
  meta = {
    license = self.stdenv.lib.licences.unfree;
    platforms = self.ghc.meta.platforms;
  };
})
