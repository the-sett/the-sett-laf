module TheSett.Laf exposing
    ( style, fonts, monoFonts, responsiveMeta, devices, wrapper
    , Model, Msg, init, update
    )

{-| The Sett Look and Feel

@docs style, fonts, monoFonts, responsiveMeta, devices, wrapper


# TEA pattern for managing UI elements with internal state.

@docs Model, Msg, init, update

-}

--exposing (Device(..), DeviceProps, ResponsiveStyle, fontMediaStyles, fontSizeMixin, mapMixins, mediaMixins)

import Css
import Css.Global
import Dict exposing (Dict)
import Grid
import Html.Styled exposing (Html, node)
import Html.Styled.Attributes exposing (attribute, href, name, rel)
import Responsive exposing (Device(..), DeviceProps, ResponsiveStyle, fontMediaStyles)
import TheSett.Buttons as Buttons
import TheSett.Colors as Colors
import TheSett.Component as Component
import TheSett.Reset as Reset
import TheSett.Textfield as Textfield
import TypeScale exposing (TypeScale, base, h1, h2, h3, h4, majorThird)



-- Device Configurations


sm : DeviceProps
sm =
    { device = Sm
    , baseFontSize = 16.0
    , breakWidth = 480
    , wrapperWidth = 480
    }


md : DeviceProps
md =
    { device = Md
    , baseFontSize = 17.0
    , breakWidth = 768
    , wrapperWidth = 760
    }


lg : DeviceProps
lg =
    { device = Lg
    , baseFontSize = 18.0
    , breakWidth = 992
    , wrapperWidth = 820
    }


xl : DeviceProps
xl =
    { device = Xl
    , baseFontSize = 19.0
    , breakWidth = 1200
    , wrapperWidth = 880
    }


{-| The responsive device configuration.
-}
devices : ResponsiveStyle
devices =
    { commonStyle =
        { lineHeightRatio = 1.5
        , typeScale = TypeScale.minorThird
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
        , rel "stylesheet"
        ]
        []


{-| Links for loading mono fonts.
-}
monoFonts : Html msg
monoFonts =
    node "link"
        [ href "https://fonts.googleapis.com/css2?family=Source+Code+Pro&display=swap"
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
        , Css.color Colors.printBlack |> Css.important
        ]

    -- Headings are grey and bold.
    , Css.Global.each
        [ Css.Global.h1
        , Css.Global.h2
        , Css.Global.h3
        , Css.Global.h4
        ]
        [ Css.color Colors.darkGrey |> Css.important
        , Css.fontWeight Css.bold
        ]

    -- Mono fonts.
    , Css.Global.each
        [ Css.Global.pre ]
        [ Css.fontFamilies [ "Source Code Pro", "monospace" ]
        , Css.fontWeight <| Css.int 400
        , Css.textRendering Css.optimizeLegibility
        , Css.color Colors.printBlack |> Css.important
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
global scale responsive =
    Reset.global
        ++ Responsive.global responsive
        ++ typography responsive
        ++ Textfield.global responsive


{-| The CSS as an HTML <style> element.
-}
style : ResponsiveStyle -> Html msg
style devs =
    Css.Global.global <|
        global majorThird devs


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



-- Stateful components


{-| A model that holds the states for all stateful components by their indexes.
-}
type alias Model =
    Textfield.Model {}


{-| Initial empty state for all stateful components.
-}
init : Model
init =
    { textfield = Dict.empty
    }


{-| Brings together all of the internal messages that stateful components can use.
-}
type alias Msg =
    Component.Msg Textfield.Msg


{-| Processes internal messages for all stateful component types.
-}
update : (Msg -> m) -> Msg -> Model -> ( Model, Cmd m )
update lift msg model =
    update_ lift msg model
        |> Tuple.mapFirst (Maybe.withDefault model)


update_ : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update_ lift msg store =
    case msg of
        Component.TextfieldMsg idx innerMsg ->
            Textfield.update lift innerMsg idx store
