module TheSett.Buttons exposing
    ( button
    , raised
    )

{-| Defines some button styles.


# Button constructors.

@docs button


# Button stylings

@docs raised

-}

import Css
import Html.Styled as Html exposing (Attribute, Html, a, div, h1, h4, i, img, p, styled, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (class, id, name, title)
import Responsive
    exposing
        ( Device(..)
        , DeviceSpec
        , DeviceProps
        , ResponsiveFn
        , ResponsiveStyle
        , deviceStyle
        , deviceStyles
        , rhythmSplit
        )
import ResponsiveDSL
    exposing
        ( Builder(..)
        , Compatible(..)
        , ConstDeviceBuilder
        , SimpleElementBuilder
        , StyleBuilder
        , applyDevicesToBuilders
        )
import Styles
import TypeScale


{-| The button styling context.
-}
type Button
    = Button


{-| Creates a button.
-}
button : SimpleElementBuilder { a | button : Compatible } Button msg
button builders attributes innerHtml responsive =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\ctxFn -> ctxFn Button)
    in
    styled Html.button
        [ Css.borderStyle Css.none
        , Css.borderRadius <| Css.px 2
        , Css.color <| Css.rgb 0 0 0
        , Css.padding2 (Css.px 0) (Css.em 0.8)
        , Css.textTransform Css.uppercase
        , Css.overflow Css.hidden
        , Css.outline Css.none
        , Css.textAlign Css.center
        , Css.verticalAlign Css.middle
        , Css.batch <| Responsive.fontMediaStyles TypeScale.milli responsive
        , Css.cursor Css.pointer

        -- Getting vertical rhythm right.
        , Responsive.deviceStyles responsive (rhythmSplit 0.3 2)

        -- , Css.property "will-change" "box-shadow"
        -- , Css.property "transition" "box-shadow .2s cubic-bezier(.4,0,1,1),background-color .2s cubic-bezier(.4,0,.2,1),color .2s cubic-bezier(.4,0,.2,1)"
        , Css.fontWeight <| Css.int 600
        , applyDevicesToBuilders flatBuilders responsive
        ]
        attributes
        innerHtml


{-| Makes a button look raised, with a shadow.
-}
raised : StyleBuilder { a | button : Compatible } Button
raised =
    Styles.styles
        [ Css.backgroundColor <| Css.rgba 158 158 158 0.2
        , Css.property "box-shadow" "0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12)"
        ]
