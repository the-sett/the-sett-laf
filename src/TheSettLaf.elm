module TheSettLaf exposing (style, fonts, responsiveMeta, devices, wrapper)

{-| The Sett Look and Feel

@docs style, fonts, responsiveMeta, devices, wrapper

-}

import Buttons
import Css
import Css.Global
import Grid
import Html.Styled exposing (Html, node)
import Html.Styled.Attributes exposing (attribute, href, name, rel)
import Reset exposing (reset)
import Responsive exposing (Device(..), DeviceStyle, ResponsiveStyle, baseSpacing, mapMixins, mediaMixins)
import TypeScale exposing (TypeScale, base, fontMediaStyles, fontSizeMixin, h1, h2, h3, h4, majorThird)



-- Colors


greyDark =
    Css.hex "646464"


printBlack =
    Css.hex "242424"



-- Device Configurations


sm : DeviceStyle
sm =
    { device = Sm
    , baseFontSize = 16.0
    , breakWidth = 480
    , wrapperWidth = 608
    }


md : DeviceStyle
md =
    { device = Md
    , baseFontSize = 17.0
    , breakWidth = 768
    , wrapperWidth = 792
    }


lg : DeviceStyle
lg =
    { device = Lg
    , baseFontSize = 18.0
    , breakWidth = 992
    , wrapperWidth = 920
    }


xl : DeviceStyle
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
    { commonStyle = { lineHeightRatio = 1.4 }
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
        [ href "https://fonts.googleapis.com/css?family=Open+Sans:400,700"

        --, href "https://fonts.googleapis.com/css?family=Nobile:300,400,500,700"
        , rel "stylesheet"
        ]
        []


{-| Responsive typography to fit all devices.
-}
typography : ResponsiveStyle -> TypeScale -> List Css.Global.Snippet
typography respStyle scale =
    [ -- Base font.
      Css.Global.each
        [ Css.Global.html ]
        [ Css.fontFamilies [ "Open Sans", "Helvetica" ]
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
    , Css.Global.html <| fontMediaStyles respStyle scale base
    , Css.Global.h1 <| fontMediaStyles respStyle scale h1
    , Css.Global.h2 <| fontMediaStyles respStyle scale h2
    , Css.Global.h3 <| fontMediaStyles respStyle scale h3
    , Css.Global.h4 <| fontMediaStyles respStyle scale h4
    ]


{-| The global CSS.
-}
responsive : TypeScale -> ResponsiveStyle -> List Css.Global.Snippet
responsive scale respStyle =
    baseSpacing respStyle
        ++ typography respStyle scale


{-| The CSS as an HTML <style> element.
-}
style : ResponsiveStyle -> Html msg
style devs =
    Css.Global.global <|
        reset
            ++ responsive majorThird devs


{-| A responsive wrapper div.
-}
wrapper : ResponsiveStyle -> Css.Style
wrapper devs =
    [ Css.margin2 (Css.px 0) Css.auto
    , Css.padding2 (Css.px 0) (Css.vw 5)
    , Responsive.deviceStyle devs <|
        \deviceProps ->
            Css.maxWidth (Css.px deviceProps.wrapperWidth)
    ]
        |> Css.batch
