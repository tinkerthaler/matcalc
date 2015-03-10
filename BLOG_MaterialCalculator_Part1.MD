# Material Calculator - Part 1

In this series I will create a small (but hopefully end-to-end) haskell application to calculate the materials (e.g. paint, tape, ...) required in a certain setting (e.g. an interior wall).

I started off by defining some algebraic (sum) data types such as ```Shape```, ```Surface```, ... to allow pattern matching in the functions.

Next I started defining some base functions such as ```area``` and ```perimeter``` which leverage the ADTs:

	area :: Shape -> Float
	area (Square s) = s * s
	area (Rectangle s1 s2) = s1 * s2
	area (Circle r) = pi * r * r

Square is actually a special case of Rectangle but for now I'll just keep it like that.

```perimter``` is similar.

Next up is the calculation function. First of all let's consider the actual calculation we are going to use (I'm sure there are plenty but feel free to plug in your own):

For calculating the amount of paint required: 

	Paint:
	Total surface area (square metres)
	divided by spreading rate of paint
	multiplied by number of coats
	= total litres required

As you notice there are two things called spreading rate and coats which - not having painted much in my life - I didn't know what exactly I had to put there. After some googling I figured these are typical predefined values (probably depending on the surface and whether its indoor or outdoor). 

Initially I just hard coded them (a global constant) to have them out of my way and to get the calculation function up-and-running as soon as possible.

That's what I'd advice novice Haskell developers (which include myself!): don't make it too complicated from the beginning!

One mistake I made was to try to put in place a Reader Monad at start and spent an hour or so reading documentation, complicating my code and basically messing up without actually seeing anything on my ghci prompt...

Eventually after some more googling I came across the 24days of haskell post about configurator and given I trust both the post writer, Ollie, as well as the configurator library writer, Bryan 'O Sullivan I decided to go for it.

It turned out to be amazingly simple

	# MatCalc.conf
	interior {
		paint {
			spreadingRate = 11
			coats         = 2
		}
	}

... except for one caveat (admittedly I hadn't really read the documentation well) the configuration file is typed! Initially I had my values wrapped in quotes but the lookup failed because I needed a Float and my configuration had a String. Amazing!

Here is the full code (needs some cleanup)

	{-# LANGUAGE OverloadedStrings #-}
	module MatCalc where

	import qualified Data.Configurator as C
	import qualified Data.Maybe as M
	import Control.Monad.Trans.Class (lift)
	--import Control.Monad

	{-
	Input: 5 by 5
	List of materials

	Output:

	Area is 25 m^2

	-}

	-- TODO: GADT

	--defaultSpreadingRate = 11 :: Float -- m^2 / L
	--defaultCoats Interior= 2  :: Float
	--defaultCoats Exterior= 2  :: Float

	data Shape = 
		  Square Float
		| Circle Float
		| Rectangle Float Float
		| Raw Float

	data Surface = Surface { unSurface :: Shape }

	data SurfaceLoc = Interior | Exterior

	data SurfaceType = Ceiling | Wall | Door | Window

	data Material = Paint | Tape

	data Unit = Meter

	area :: Shape -> Float
	area (Square s) = s * s
	area (Rectangle s1 s2) = s1 * s2
	area (Circle r) = pi * r * r
	--area (Raw r) = r

	perimeter :: Shape -> Float
	perimeter (Square s) = 4 * s
	perimeter (Rectangle s1 s2) = 2 * s1 * s2
	perimeter (Circle r) = 2 * pi * r

	{--
	   Paint:
	   Total surface area (square metres)
	   divided by spreading rate of paint
	   multiplied by number of coats
	   = total litres required
	 --}
	--calc :: SurfaceLoc -> Material -> Surface -> Float
	calc Interior Paint s = do
		cfg           <- C.load [ C.Required "MatCalc.cfg" ]
		desc          <- C.lookupDefault "" cfg "interior.paint.desc"
		putStrLn desc
		spreadingRate <- C.lookup cfg "interior.paint.spreadingRate"
		coats         <- C.lookup cfg "interior.paint.coats"
		return $ area (unSurface s) / (M.fromJust spreadingRate) * (M.fromJust coats)
	--calc Interior Tape  s = 
	--	perimeter (unSurface s)
	--calc _ _ _ = undefined

	-- HELPER
	toFloat :: Integral a => a -> Float
	toFloat = fromInteger . toInteger