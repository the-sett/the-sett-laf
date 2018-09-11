module TheSettLaf exposing (snippets, style, fonts)

{-| The Sett Look and Feel

@docs snippets, style

-}

import Css
import Css.Foreign
import DebugStyle
import Html
import Html.Attributes
import Html.Styled exposing (Html)
import Utilities


{-| Links for loading fonts.
-}
fonts : Html.Html msg
fonts =
    Html.node "link"
        [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext"
        , Html.Attributes.rel "stylesheet"
        ]
        []


{-| The CSS as an HTML <style> element.
-}
style : Html msg
style =
    Css.Foreign.global snippets


{-| The global CSS.
-}
snippets : List Css.Foreign.Snippet
snippets =
    Utilities.reset
        ++ Utilities.normalize
        ++ Utilities.baseSpacing
        ++ (Utilities.typography Utilities.minorThird)
