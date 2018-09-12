module TheSettLaf exposing (style, fonts, devices)

{-| The Sett Look and Feel

@docs snippets, style

-}

import Css
import Css.Foreign
import DebugStyle
import Html
import Html.Attributes
import Html.Styled exposing (Html)
import Utilities exposing (DeviceProps, Device(..), Devices)


mobile : DeviceProps
mobile =
    { device = Mobile
    , baseFontSize = 14.0
    , breakWidth = 480
    , baseLineHeight = 24
    , lineHeightRatio = 1.5
    }


tablet : DeviceProps
tablet =
    { device = Tablet
    , baseFontSize = 15.0
    , breakWidth = 768
    , baseLineHeight = 24
    , lineHeightRatio = 1.5
    }


desktop : DeviceProps
desktop =
    { device = Desktop
    , baseFontSize = 16.0
    , breakWidth = 992
    , baseLineHeight = 24
    , lineHeightRatio = 1.5
    }


desktopWide : DeviceProps
desktopWide =
    { device = DesktopWide
    , baseFontSize = 17.0
    , breakWidth = 1200
    , baseLineHeight = 24
    , lineHeightRatio = 1.5
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
        [ Html.Attributes.href "https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext"
        , Html.Attributes.rel "stylesheet"
        ]
        []


{-| The CSS as an HTML <style> element.
-}
style : Devices -> Html msg
style devices =
    Css.Foreign.global <| Utilities.styleSheet devices
