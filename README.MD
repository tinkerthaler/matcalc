# Material Calculator

This repository contains a (simple) material cost calculator written in Haskell.

See [Part1](./BLOG_MaterialCalculator_Part1.MD)

See [Part2](./BLOG_MaterialCalculator_Part2.MD)

Sample usage (on [NixOS](http://nixos.org/))

	git clone https://github.com/tinkerthaler/matcalc
	cd matcalc
	git checkout part1
	nix-shell
	ghci

Then in GHCI:

	:l MatCalc.hs
	calc Interior Paint (Surface $ Rectangle 6 7)