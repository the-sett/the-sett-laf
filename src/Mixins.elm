module Mixins exposing (..)

import Css
import Css.Media
import Utilities


-- Sass


adjustFontSizeTo pxval lines =
    -- Just a dummy value to get the type right for now.
    Css.fontWeight Css.bold



-- Private


pem pxval base =
    pxval / base |> Css.em


mediaMinWidth : Css.Px -> List Css.Style -> Css.Style
mediaMinWidth width styles =
    Css.Media.withMedia
        [ Css.Media.all [ Css.Media.minWidth width ] ]
        styles


mediaPhone : List Css.Style -> Css.Style
mediaPhone =
    mediaMinWidth Utilities.screenXs


mediaTablet : List Css.Style -> Css.Style
mediaTablet =
    mediaMinWidth Utilities.screenSm


mediaDesktop : List Css.Style -> Css.Style
mediaDesktop =
    mediaMinWidth Utilities.screenMd


mediaHd : List Css.Style -> Css.Style
mediaHd =
    mediaMinWidth Utilities.screenLg


media2x : List Css.Style -> Css.Style
media2x styles =
    Css.Media.withMediaQuery
        [ "(-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dppx)" ]
        styles
