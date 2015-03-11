# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, configurator, filepath, genericAeson
, happstackServer, hxt, jsonSchema, mtl, regular, regularXmlpickler
, restCore, restHappstack, safe, stm, text, time, transformers
, transformersBase, transformersCompat, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "material-calc";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson configurator filepath genericAeson happstackServer hxt
    jsonSchema mtl regular regularXmlpickler restCore restHappstack
    safe stm text time transformers transformersBase transformersCompat
    unorderedContainers
  ];
  meta = {
    description = "Material calculator";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
