module Structure exposing (Layout, Template(..))

{-| Defines the structure of a reactive application as layouts applied to templates.

The device specification is always given as a parameter, from which device dependant
styling can be applied.

-}

import Html.Styled exposing (Html)
import Responsive exposing (DeviceStyles)


{-| Defines the type of a template. A template takes a link builder, an editor and
some content and produces Html.
-}
type Template msg model
    = Dynamic (DeviceStyles -> model -> Html msg)
    | Static (DeviceStyles -> Html msg)


{-| Defines the type of a layout. A layout is a higher level template; it takes a
template as input and produces a template as output.
-}
type alias Layout msg model =
    Template msg model -> Template msg model
