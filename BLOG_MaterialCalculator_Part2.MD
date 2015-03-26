# Material Calculator - Part 2

In this part we are going to add a rest layer around around calc function.

We will use the silk rest framework (see [this tutorial]([1])) on top of happstack.

Looking at the API documentation

data Resource m s sid mid aid
m & s represent the context for the handlers
sid: single identifier
mid: many resources
aid: static action

more on it later

First lets inspect the mk constructors

    mkResourceId :: Resource m m sid Void Void
    Make a resource that doesn't add any information for subresources (i.e. enter is set to id).

    mkResourceReader :: Resource m (ReaderT sid m) sid Void Void
    Make a resource that provides the single resource identifier to its subresources.

Let's start to play a bit in ghci

    :l MatCalc
    import Rest
    import qualified Rest.Resource as R

    let resource = mkResourceId { R.name = "calc" , R.schema = noListing $ unnamedSingle  id, R.get = undefined     } :: Resource IO IO String Void Void

So basically what we've done is created a resource with name *calc*. We provided it with a schema that has _noListing_ because it doesn't make sense to list calculations (contrary to other resources such as posts)

Our type parameters are:
m and s are IO
sid : String (or Float?)
mid : Void
aid : Void


[1] http://silkapp.github.io/rest/tutorial.html
