module Styles exposing
    ( styles, empty
    , sm, md, lg, xl
    )

{-| The Devices module provides device specific styling builders.


# Injecting CSS styles

@docs styles, empty


# By-device style builders.

@docs sm, md, lg, xl

-}

import Css
import Responsive exposing (Device(..))
import ResponsiveDSL exposing (Builder(..), DeviceBuilder, StyleBuilder, applyDevice)


{-| Adds any CSS style you like to a grid element.
-}
styles : List Css.Style -> Device -> ctx -> Builder a ctx
styles styleList device ctx =
    Builder device ctx (always3 styleList)


{-| An empty style, for convenience when sketching out DSLs.
-}
empty : StyleBuilder a ctx
empty =
    \device ctx -> Builder device ctx (always3 [])


always3 =
    always >> always >> always


{-| Small device grid property builder.
-}
sm : DeviceBuilder a ctx
sm builders =
    applyDevice Sm builders


{-| Medium device grid property builder.
-}
md : DeviceBuilder a ctx
md builders =
    applyDevice Md builders


{-| Large device grid property builder.
-}
lg : DeviceBuilder a ctx
lg builders =
    applyDevice Lg builders


{-| Extra large device grid property builder.
-}
xl : DeviceBuilder a ctx
xl builders =
    applyDevice Xl builders
