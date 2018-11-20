module Devices exposing (sm, md, lg, xl)

{-| The Devices module provides device specific styling builders.


# By-device style builders.

@docs sm, md, lg, xl

-}

import Responsive exposing (Device(..))
import ResponsiveDSL exposing (DeviceBuilder, applyDevice)


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
