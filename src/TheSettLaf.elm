module TheSettLaf exposing (snippets, style)

{-| The Sett Look and Feel

@docs snippets, style

-}

import Css
import Css.Foreign
import Html.Styled exposing (Html)
import Utilities
import Quarks


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
        ++ Quarks.headings
