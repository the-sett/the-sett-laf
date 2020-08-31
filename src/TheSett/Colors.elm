module TheSett.Colors exposing (highlight, midGrey, paperWhite, softGrey)

{-| Defines some standard colors.

@docs highlight, midGrey, paperWhite, softGrey

-}

import Css


{-| An off-white for a more readable background.
-}
paperWhite : Css.Color
paperWhite =
    Css.rgb 248 248 248


{-| A soft grey.
-}
softGrey : Css.Color
softGrey =
    Css.rgb 225 212 214


{-| A mig grey.
-}
midGrey : Css.Color
midGrey =
    Css.rgb 168 159 160


{-| The primary highlight color
-}
highlight : Css.Color
highlight =
    Css.rgb 65 219 119
