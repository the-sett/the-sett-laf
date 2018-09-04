module Quarks exposing (..)

import Css
import Css.Foreign
import Mixins
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
        [ Mixins.adjustFontSizeTo mobileH1Size 3
        , Mixins.mediaTablet
            [ Mixins.adjustFontSizeTo tabletH1Size 3
            ]
        ]
    , Css.Foreign.h2
        [ Mixins.adjustFontSizeTo mobileH2Size 2
        , Mixins.mediaTablet
            [ Mixins.adjustFontSizeTo tabletH2Size 2
            ]
        ]
    , Css.Foreign.h3
        [ Mixins.adjustFontSizeTo mobileH3Size 2
        , Mixins.mediaTablet
            [ Mixins.adjustFontSizeTo tabletH3Size 2
            ]
        ]
    , Css.Foreign.h4
        [ Mixins.adjustFontSizeTo mobileH4Size 2
        , Mixins.mediaTablet
            [ Mixins.adjustFontSizeTo tabletH4Size 2
            ]
        ]
    ]
