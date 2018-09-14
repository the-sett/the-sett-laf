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
import Html.Styled.Attributes exposing (href, rel, name, content)
import Html.Styled exposing (Html, node)
import Reset exposing (reset)
import Responsive exposing (DeviceProps, Device(..), Devices, responsive, majorThird)


mobile : DeviceProps
mobile =
    { device = Mobile
    , baseFontSize = 14.0
    , breakWidth = 480
    , baseLineHeight = 21
    , lineHeightRatio = 1.6
    , wrapperWidth = 768
    }


tablet : DeviceProps
tablet =
    { device = Tablet
    , baseFontSize = 15.0
    , breakWidth = 768
    , baseLineHeight = 22
    , lineHeightRatio = 1.6
    , wrapperWidth = 992
    }


desktop : DeviceProps
desktop =
    { device = Desktop
    , baseFontSize = 16.0
    , breakWidth = 992
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 970
    }


desktopWide : DeviceProps
desktopWide =
    { device = DesktopWide
    , baseFontSize = 17.0
    , breakWidth = 1200
    , baseLineHeight = 24
    , lineHeightRatio = 1.6
    , wrapperWidth = 1170
    }


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


responsiveMeta : Html msg
responsiveMeta =
    node "meta"
        [ name "viewport"
        , content "width=device-width, initial-scale=1"
        ]
        []


{-| The CSS as an HTML <style> element.
-}
style : Devices -> Html msg
style devices =
    Css.Foreign.global <|
        reset
            ++ (responsive majorThird devices)


wrapper : Devices -> Css.Style
wrapper devices =
    [ Css.margin2 (Css.px 0) Css.auto
    , Responsive.deviceStyle devices <|
        \deviceProps ->
            Css.maxWidth (Css.px deviceProps.wrapperWidth)
    ]
        |> Css.batch
