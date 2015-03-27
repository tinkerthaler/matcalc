# Material Calculator - Part 2

In this part we are going to add a rest layer around around calc function.

We will use the silk rest framework (see [this tutorial]([1])) on top of happstack. I'm rather new to this library myself so bare with me.

The code can be found on [github]([2] in the _part2_ branch)

So first let's look at the REST API documentation for a Resource:

    data Resource m s sid mid aid
    m & s represent the context for the handlers
    sid: single identifier
    mid: many resources
    aid: static action

So in the next section we'll try to figure out what we need to provide here.

First lets inspect the mk constructors

    mkResourceId :: Resource m m sid Void Void
    Make a resource that doesn't add any information for subresources (i.e. enter is set to id).

    mkResourceReader :: Resource m (ReaderT sid m) sid Void Void
    Make a resource that provides the single resource identifier to its subresources.

In our case we don't have subresources so I guess we should go for mkResourceId.

Now let's start to play a bit in ghci

    :l MatCalc
    import Rest
    import qualified Rest.Resource as R

    let resource = mkResourceId { R.name = "matcalc" , R.schema = noListing $ unnamedSingle  id     } :: Resource IO IO String Void Void

So basically what we've done is created a resource with name *matcalc*. We provided it with a schema that has _noListing_ because it doesn't make sense to list calculations (contrary to other resources such as blog posts).

We used String here for the sid but in our example we don't really need the single identifier so our final type parameters are:
m and s are IO
sid : ()
mid : Void
aid : Void

Before continuing, here is the structure

    src
    Api.hs: routing, versioning, etc.
    MatCalc.hs: Module containing our core functionlity
    |- Api: Contains REST API layer which defines the verbs for the resource
    |- Type: Contains wrappers to the existing types (e.g. add ToJSON, FromJSON instances)

We start with our Api/MatCalcApi.hs

The resource type is: 

    resource :: Resource IO IO () Void Void

We are using a POST here (create in the Schema) with a JSON payload. Note how the JSON payload is converted into a Rectangle Shape and then passed on to the calc function!

    post :: Handler IO
    post = mkInputHandler xmlJson $ \s ->
                            liftIO $ runCalc s

    runCalc :: T.Shape -> IO T.Calc
    runCalc s = S.calc S.Interior S.Paint $ S.Surface $ s

The ```runCalc``` function should be obvious. We just call the actual calc from our internal ```MatCalc``` library.

The ```post``` function uses one of the mk*Handlers. Here is the list from the API docs:

    mkHandler
    Create a handler for a single resource. Takes the entire environmend as input.

    mkInputHandler
    Create a handler for a single resource. Takes only the body information as input.

    mkConstHandler
    Create a handler for a single resource. Doesn't take any input.

    mkIdHandler
    Create a handler for a single resource. Take body information and the resource identifier as input. The monad m should be a Reader-like type containing the idenfier. 

In our case we are taking the (JSON) body as input.

The next one is easy: depending on whether you have input, output or input/output you choose one of ```xmlJsonI```, ```xmlJsonO``` or ```xmlJson```.

Let's quickly look at the type for xmlJson

    xmlJson :: (Typeable i, FromJSON i, JSONSchema i, XmlPickler i, Typeable o, ToJSON o, JSONSchema o, XmlPickler o, FromMaybe i i' ~ i, FromMaybe o o' ~ o) => Dict h p i' o' e -> Dict h p (Just i) (Just o) e 

It's quite something! The best way to approach it is to start by understanding the h, p, i', o' and e which are explained in the API of Dict:

    data Dict h p i o e Source
    
    The Dict datatype containing sub-dictionaries for translation of identifiers (i), headers (h), parameters (p), inputs (i), outputs (o), and errors (e). Inputs, outputs and errors can have multiple associated dictionaries.

Our main MatCalc module is not aware of the REST layer so the data types are no instances of ToJSON and FromJSON.

Instead this is covered by the modules in the Api.Type package. For example:

    module Api.Type.Shape (Shape (..)) where
    ...
    import MatCalc (Shape(..))
    ...
    instance ToJSON     Shape
    instance FromJSON   Shape

Here we import the Shape data type and re-export it. Our REST Api needs to import it from here.

On a final note: I ran into many issues while developing this. The runtime error information is very limited but once you find the solution you'll notice that the error was mostly actually pretty accurate... I guess this a matter of training but hopefully these pointers can be of any help to others:

Issue

    src/Type/Shape.hs:25:42:
        No instance for (generic-deriving-1.7.0:Generics.Deriving.ConNames.ConNames
                           (GHC.Generics.Rep Shape))
          arising from a use of ‘gSchema’
        In the expression: gSchema
        In an equation for ‘schema’: schema = gSchema
        In the instance declaration for ‘JSONSchema Shape’

Solution

    Add  deriving (Eq, Generic, Ord, Show, Typeable) to Shape

Issue

    {
        "inputError": {
            "parseError": "key \"tag\" not present"
        }
    }

Solution

As the error says... a missing key in my JSON. Apparently the automatic Object to JSON conversion maps a constructor (Rectangle is a constructor of the Shape data type) to a tag in JSON.

    curl -s -X PUT 'http://localhost:3000/v1.0/matcalc' -H "Content-Type:application/json" -d '{"Rectangle": { "tag": "Rectangle", "s1":3,"s2":6}}' | python -mjson.tool


[1] http://silkapp.github.io/rest/tutorial.html
[2] https://github.com/tinkerthaler/matcalc/tree/part2