let 
  pkgs = import <nixpkgs> {};
  haskellPackages = pkgs.haskellPackages.override {
    extension = self: super: {
      matcalc = self.callPackage ./matcalc.nix {};
    };
  };
  name = "matcalc";
  stdenv = pkgs.stdenv;
in stdenv.mkDerivation {
  buildInputs = [
    (haskellPackages.ghcWithPackagesOld (hs: ([
      hs.cabalInstall
      hs.hscolour
      hs.hoogle
      hs.haddock
      hs.configurator
    ]
    ++ hs.matcalc.propagatedNativeBuildInputs
    )))
    pkgs.python
    pkgs.libxml2
    pkgs.postgresql
  ];  
  inherit name;
  ME_ENV = "Hello";
}
