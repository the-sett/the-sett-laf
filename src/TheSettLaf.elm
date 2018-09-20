module TheSettLaf
    exposing
        ( style
        , fonts
        , responsiveMeta
        , devices
        , wrapper
        )

{-| The Sett Look and Feel

@docs style, fonts, responsiveMeta, devices, wrapper

-}

import Css
import Css.Global
import Grid
import Html.Styled.Attributes exposing (href, rel, name, content)
import Html.Styled exposing (Html, node)
import Reset exposing (reset)
import Responsive exposing (BaseStyle, Device(..), DeviceStyles, responsive, majorThird)


mobile : BaseStyle
mobile =
    { device = Sm
    , baseFontSize = 14.0
    , breakWidth = 480
    , baseLineHeight = 21
    , lineHeightRatio = 1.6
    , wrapperWidth = 768
    }


tablet : BaseStyle
tablet =
    { device = Md
    , baseFontSize = 15.0
    , breakWidth = 768
    , baseLineHeight = 22
    , lineHeightRatio = 1.6
    , wrapperWidth = 992
    }


desktop : BaseStyle
desktop =
    { device = Lg
    , baseFontSize = 16.0
    , breakWidth = 992
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 970
    }


desktopWide : BaseStyle
desktopWide =
    { device = Xl
    , baseFontSize = 17.0
    , breakWidth = 1200
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 1170
    }


{-| Device configuration.
-}
devices : DeviceStyles
devices =
    { mobile = mobile
    , tablet = tablet
    , desktop = desktop
    , desktopWide = desktopWide
    }


{-| Links for loading fonts.
-}
fonts : Html msg
fonts =
    node "link"
        [ href "https://fonts.googleapis.com/css?family=Nobile:300,400,500,700"
        , rel "stylesheet"
        ]
        []


{-| Meta tag to include to indiciate that the layout is reponsive.
-}
responsiveMeta : Html msg
responsiveMeta =
    node "meta"
        [ name "viewport"
        , content "width=device-width, initial-scale=1"
        ]
        []


{-| The CSS as an HTML <style> element.
-}
style : DeviceStyles -> Html msg
style devices =
    Css.Global.global <|
        reset
            ++ (responsive majorThird devices)


{-| A responsive wrapper div.
-}
wrapper : DeviceStyles -> Css.Style
wrapper devices =
    [ Css.margin2 (Css.px 0) Css.auto
    , Css.padding2 (Css.px 0) (Css.px 5)
    , Responsive.deviceStyle devices <|
        \deviceProps ->
            Css.maxWidth (Css.px deviceProps.wrapperWidth)
    ]
        |> Css.batch
