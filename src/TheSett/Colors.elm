module TheSett.Colors exposing
    ( paperWhite, printBlack
    , softGrey, midGrey, darkGrey
    , highlight, error
    )

{-| Defines some standard colors.

@docs paperWhite, printBlack
@docs softGrey, midGrey, darkGrey
@docs highlight, error

-}

import Css


{-| An off-white for a more readable background.
-}
paperWhite : Css.Color
paperWhite =
    Css.rgb 248 248 248


{-| A print black, that is not 100% black.
-}
printBlack : Css.Color
printBlack =
    Css.hex "242424"


{-| A soft grey.
-}
softGrey : Css.Color
softGrey =
    Css.rgb 225 212 214


{-| A mid grey.
-}
midGrey : Css.Color
midGrey =
    Css.rgb 168 159 160


{-| A dark grey.
-}
darkGrey : Css.Color
darkGrey =
    Css.hex "646464"


{-| The primary highlight color
-}
highlight : Css.Color
highlight =
    Css.rgb 70 230 100


{-| The primary error color
-}
error : Css.Color
error =
    Css.rgb 245 80 70
