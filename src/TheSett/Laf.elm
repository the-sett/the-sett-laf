module TheSett.Laf exposing (style, fonts, responsiveMeta, devices, wrapper)

{-| The Sett Look and Feel

@docs style, fonts, responsiveMeta, devices, wrapper

-}

--exposing (Device(..), DeviceProps, ResponsiveStyle, fontMediaStyles, fontSizeMixin, mapMixins, mediaMixins)

import Css
import Css.Global
import Grid
import Html.Styled exposing (Html, node)
import Html.Styled.Attributes exposing (attribute, href, name, rel)
import Responsive exposing (Device(..), DeviceProps, ResponsiveStyle, fontMediaStyles)
import TheSett.Buttons as Buttons
import TheSett.Reset as Reset
import TheSett.TextField
import TypeScale exposing (TypeScale, base, h1, h2, h3, h4, majorThird)



-- Colors


greyDark =
    Css.hex "646464"


printBlack =
    Css.hex "242424"



-- Device Configurations


sm : DeviceProps
sm =
    { device = Sm
    , baseFontSize = 16.0
    , breakWidth = 480
    , wrapperWidth = 608
    }


md : DeviceProps
md =
    { device = Md
    , baseFontSize = 17.0
    , breakWidth = 768
    , wrapperWidth = 792
    }


lg : DeviceProps
lg =
    { device = Lg
    , baseFontSize = 18.0
    , breakWidth = 992
    , wrapperWidth = 920
    }


xl : DeviceProps
xl =
    { device = Xl
    , baseFontSize = 19.0
    , breakWidth = 1200
    , wrapperWidth = 1040
    }


{-| The responsive device configuration.
-}
devices : ResponsiveStyle
devices =
    { commonStyle =
        { lineHeightRatio = 1.4
        , typeScale = majorThird
        }
    , deviceStyles =
        { sm = sm
        , md = md
        , lg = lg
        , xl = xl
        }
    }


{-| Meta tag to include to indiciate that the layout is reponsive.
-}
responsiveMeta : Html msg
responsiveMeta =
    node "meta"
        [ name "viewport"
        , attribute "content" "width=device-width, initial-scale=1"
        ]
        []


{-| Links for loading fonts.
-}
fonts : Html msg
fonts =
    node "link"
        [ href "https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700"

        --href "https://fonts.googleapis.com/css?family=Open+Sans:400,600,700"
        --, href "https://fonts.googleapis.com/css?family=Nobile:300,400,500,700"
        , rel "stylesheet"
        ]
        []


{-| Responsive typography to fit all devices.
-}
typography : ResponsiveStyle -> List Css.Global.Snippet
typography respStyle =
    [ -- Base font.
      Css.Global.each
        [ Css.Global.html ]
        [ Css.fontFamilies [ "Source Sans Pro", "Helvetica" ]
        , Css.fontWeight <| Css.int 400
        , Css.textRendering Css.optimizeLegibility
        , Css.color printBlack |> Css.important
        ]

    -- Headings are grey and bold.
    , Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        ]
        [ Css.color greyDark |> Css.important
        , Css.fontWeight Css.bold
        ]

    -- Media queries to set all font sizes accross all devices.
    , Css.Global.html <| fontMediaStyles base respStyle
    , Css.Global.h1 <| fontMediaStyles h1 respStyle
    , Css.Global.h2 <| fontMediaStyles h2 respStyle
    , Css.Global.h3 <| fontMediaStyles h3 respStyle
    , Css.Global.h4 <| fontMediaStyles h4 respStyle
    ]


{-| The global CSS.
-}
global : TypeScale -> ResponsiveStyle -> List Css.Global.Snippet
global scale respStyle =
    Reset.global
        ++ Responsive.global respStyle
        ++ typography respStyle


{-| The CSS as an HTML <style> element.
-}
style : ResponsiveStyle -> Html msg
style devs =
    Css.Global.global <|
        Reset.global
            ++ global majorThird devs


{-| A responsive wrapper div.
-}
wrapper : ResponsiveStyle -> Css.Style
wrapper responsive =
    [ Css.margin2 (Css.px 0) Css.auto
    , Css.padding2 (Css.px 0) (Css.vw 5)
    , Responsive.deviceStyle responsive <|
        \device ->
            Css.maxWidth (Css.px device.deviceProps.wrapperWidth)
    ]
        |> Css.batch
