module Quarks exposing (..)

import Css
import Css.Foreign
import Utilities exposing (..)


headings =
    [ Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        , Css.Foreign.h4
        , Css.Foreign.h5
        ]
        [ Css.fontSize (Css.px mobileBaseSize)
        , Css.color greyDark |> Css.important
        ]
    , Css.Foreign.each
        [ Css.Foreign.h1
        , Css.Foreign.h2
        , Css.Foreign.h3
        ]
        [ Css.fontWeight Css.bold
        , Css.textRendering Css.optimizeLegibility
        ]
    , Css.Foreign.h1
        [ Utilities.adjustFontSizeTo mobileH1Size 3
        , Utilities.mediaTablet
            [ Utilities.adjustFontSizeTo tabletH1Size 3
            ]
        ]
    , Css.Foreign.h2
        [ Utilities.adjustFontSizeTo mobileH2Size 2
        , Utilities.mediaTablet
            [ Utilities.adjustFontSizeTo tabletH2Size 2
            ]
        ]
    , Css.Foreign.h3
        [ Utilities.adjustFontSizeTo mobileH3Size 2
        , Utilities.mediaTablet
            [ Utilities.adjustFontSizeTo tabletH3Size 2
            ]
        ]
    , Css.Foreign.h4
        [ Utilities.adjustFontSizeTo mobileH4Size 2
        , Utilities.mediaTablet
            [ Utilities.adjustFontSizeTo tabletH4Size 2
            ]
        ]
    ]
