import CSI 1.0

import "../Common/MK3Controllers/ChannelFX"

Module {
    id: module
    property string surface: "hw.mixer"
    property bool shift: false

    //Channels
    Channel {
        name: "channel1"
        surface: module.surface + ".channels." + deckId
        deckId: 1
    }

    Channel {
        name: "channel2"
        surface: module.surface + ".channels." + deckId
        deckId: 2
    }

    Channel {
        name: "channel3"
        surface: module.surface + ".channels." + deckId
        deckId: 3
    }

    Channel {
        name: "channel4"
        surface: module.surface + ".channels." + deckId
        deckId: 4
    }

    //Channels Filter + Mixer FX Buttons
    FourChannelFXSelector {
        name: "channelFxSelector"
        surface: module.surface
    }

    //FXs Overlays
    MappingPropertyDescriptor { id: showFX1; path: "mapping.state.showFX1"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX2; path: "mapping.state.showFX2"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX3; path: "mapping.state.showFX3"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX4; path: "mapping.state.showFX4"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Master Level Meters
    LEDLevelMeter { name: "leftMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
    Wire { from: "%surface%.level_meter.left"; to: "leftMeter" }
    Wire { from: "leftMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.left"; input: false } }
    Wire { from: "leftMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left"; input: false } }

    LEDLevelMeter { name: "rightMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
    Wire { from: "%surface%.level_meter.right"; to: "rightMeter" }
    Wire { from: "rightMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.right"; input: false } }
    Wire { from: "rightMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right"; input: false } }

    //Snap & Quantize
    Wire { from: "%surface%.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant" } enabled: !shift}
    Wire { from: "%surface%.quant"; to: TogglePropertyAdapter { path: "app.traktor.snap" } enabled: shift }

/*
    //Master Clock
    MasterClock { name: "MasterTempo" }
    Wire { from: "%surface%.tempo"; to: "MasterTempo.coarse"; enabled: !shift }
    Wire { from: "%surface%.tempo"; to: "MasterTempo.fine"; enabled: shift }
*/

    //X-Fader
    Wire { from: "%surface%.xfader.position"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }
    Wire { from: "%surface%.xfader.curve.blend"; to: SetPropertyAdapter { path: "app.traktor.mixer.xfader.curve"; value: 0.0  } }
    Wire { from: "%surface%.xfader.curve.steep"; to: SetPropertyAdapter { path: "app.traktor.mixer.xfader.curve"; value: 0.5  } }
    Wire { from: "%surface%.xfader.curve.scratch"; to: SetPropertyAdapter { path: "app.traktor.mixer.xfader.curve"; value: 1.0  } }
}
