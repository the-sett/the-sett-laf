module TheSettLaf exposing (style, fonts, responsiveMeta, devices, wrapper)

{-| The Sett Look and Feel

@docs style, fonts, responsiveMeta, devices, wrapper

-}

import Css
import Css.Global
import Grid
import Html.Styled exposing (Html, node)
import Html.Styled.Attributes exposing (attribute, href, name, rel)
import Reset exposing (reset)
import Responsive exposing (BaseStyle, Device(..), DeviceStyles, baseSpacing, mapMixins, mediaMixins)
import TypeScale exposing (TypeScale, base, fontSizeMixin, h1, h2, h3, h4, majorThird)



-- Colors


greyDark =
    Css.hex "727272"



-- Device Configurations


sm : BaseStyle
sm =
    { device = Sm
    , baseFontSize = 14.0
    , breakWidth = 480
    , baseLineHeight = 21
    , lineHeightRatio = 1.6
    , wrapperWidth = 768
    }


md : BaseStyle
md =
    { device = Md
    , baseFontSize = 15.0
    , breakWidth = 768
    , baseLineHeight = 22
    , lineHeightRatio = 1.6
    , wrapperWidth = 992
    }


lg : BaseStyle
lg =
    { device = Lg
    , baseFontSize = 16.0
    , breakWidth = 992
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 970
    }


xl : BaseStyle
xl =
    { device = Xl
    , baseFontSize = 17.0
    , breakWidth = 1200
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 1170
    }


{-| The responsive device configuration.
-}
devices : DeviceStyles
devices =
    { sm = sm
    , md = md
    , lg = lg
    , xl = xl
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
        [ href "https://fonts.googleapis.com/css?family=Nobile:300,400,500,700"
        , rel "stylesheet"
        ]
        []


{-| Responsive typography to fit all devices.
-}
typography : DeviceStyles -> TypeScale -> List Css.Global.Snippet
typography deviceStyles scale =
    let
        -- Generates font size in Em as relative sizes to the root font-size.
        fontBaseStyle fontSizeLevel =
            mapMixins (mediaMixins deviceStyles (fontSizeMixin scale fontSizeLevel)) []

        -- Generates font size in Em with different relative sizes for different devices.
        fontMediaStyles fontSizeLevel =
            mapMixins (mediaMixins deviceStyles (fontSizeMixin scale fontSizeLevel)) []
    in
    [ -- Base font.
      Css.Global.each
        [ Css.Global.html ]
        [ Css.fontFamilies [ "Nobile", "Helvetica" ]
        , Css.fontWeight <| Css.int 400
        , Css.textRendering Css.optimizeLegibility
        ]

    -- Headings are grey and at least medium.
    , Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        , Css.Global.h5
        ]
        [ Css.color greyDark |> Css.important
        , Css.fontWeight <| Css.int 500
        ]

    -- Biggest headings are bold.
    , Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        ]
        [ Css.fontWeight Css.bold ]

    -- Media queries to set all font sizes accross all devices.
    -- TODO: The font size might be better as a pct?
    , Css.Global.html <| fontMediaStyles base
    , Css.Global.h1 <| fontBaseStyle h1
    , Css.Global.h2 <| fontBaseStyle h2
    , Css.Global.h3 <| fontBaseStyle h3
    , Css.Global.h4 <| fontBaseStyle h4
    ]


{-| The global CSS.
-}
responsive : TypeScale -> DeviceStyles -> List Css.Global.Snippet
responsive scale deviceStyles =
    baseSpacing devices
        ++ typography deviceStyles scale


{-| The CSS as an HTML <style> element.
-}
style : DeviceStyles -> Html msg
style devs =
    Css.Global.global <|
        reset
            ++ responsive majorThird devs


{-| A responsive wrapper div.
-}
wrapper : DeviceStyles -> Css.Style
wrapper devs =
    [ Css.margin2 (Css.px 0) Css.auto
    , Css.padding2 (Css.px 0) (Css.px 5)
    , Responsive.deviceStyle devs <|
        \deviceProps ->
            Css.maxWidth (Css.px deviceProps.wrapperWidth)
    ]
        |> Css.batch
