module TheSettLaf
    exposing
        ( style
        , fonts
        , responsiveMeta
        , devices
        , wrapper
        )

{-| The Sett Look and Feel

@docs snippets, style

-}

import Css
import Css.Foreign
import Html
import Html.Attributes
import Html.Styled exposing (Html)
import Reset exposing (reset)
import Responsive exposing (DeviceProps, Device(..), Devices, responsive, majorThird)


mobile : DeviceProps
mobile =
    { device = Mobile
    , baseFontSize = 14.0
    , breakWidth = 480
    , baseLineHeight = 21
    , lineHeightRatio = 1.6
    , wrapperWidth = 480
    }


tablet : DeviceProps
tablet =
    { device = Tablet
    , baseFontSize = 15.0
    , breakWidth = 768
    , baseLineHeight = 22
    , lineHeightRatio = 1.6
    , wrapperWidth = 768
    }


desktop : DeviceProps
desktop =
    { device = Desktop
    , baseFontSize = 16.0
    , breakWidth = 992
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 1100
    }


desktopWide : DeviceProps
desktopWide =
    { device = DesktopWide
    , baseFontSize = 17.0
    , breakWidth = 1200
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 1400
    }


devices =
    { mobile = mobile
    , tablet = tablet
    , desktop = desktop
    , desktopWide = desktopWide
    }


{-| Links for loading fonts.
-}
fonts : Html.Html msg
fonts =
    Html.node "link"
        [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Nobile:300,400,500,700"
        , Html.Attributes.rel "stylesheet"
        ]
        []


responsiveMeta : Html.Html msg
responsiveMeta =
    Html.node "meta"
        [ Html.Attributes.name "viewport"
        , Html.Attributes.content "width=device-width, initial-scale=1"
        ]
        []


{-| The CSS as an HTML <style> element.
-}
style : Devices -> Html msg
style devices =
    Css.Foreign.global <|
        reset
            ++ (responsive majorThird devices)


wrapper : DeviceProps -> Css.Style
wrapper deviceProps =
    [ Css.maxWidth (Css.px deviceProps.wrapperWidth) ]
        |> Css.batch
