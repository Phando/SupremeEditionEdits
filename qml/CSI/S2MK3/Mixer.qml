import CSI 1.0
import S2MK3 1.0

import "../../Defines"

Module {
    id: module
    property string surface: "hw.mixer"
    property bool shift: false

    property bool leftShift: false //Necessary for controling FXs on the S2
    property bool rightShift: false //Necessary for controling FXs on the S2

    //Channels
    Channel {
        name: "channel1"
        surface: module.surface + ".channels." + (deckId-1)
        deckId: 1
    }

    Channel {
        name: "channel2"
        surface: module.surface + ".channels." + (deckId-1)
        deckId: 2
    }

    S2MK3ChannelFxSelection {
        name: "channelFxSelect"
        leftShift: module.leftShift
        rightShift: module.rightShift

    }

    //Snap & Quantize
    Wire { from: "s2mk3.global.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant" } enabled: !shift }
    Wire { from: "s2mk3.global.quant"; to: TogglePropertyAdapter { path: "app.traktor.snap" } enabled: shift }

    //X-Fader
    Wire { from: "%surface%.xfader"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }
    Wire { from: "%surface%.cue_mix"; to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.mix" } }

    //Microphone Input
    Wire { from: "%surface%.mic"; to: TogglePropertyAdapter { path: "app.traktor.mixer.mic_volume"; value: VolumeLevels.volumeZeroDb; defaultValue: VolumeLevels.minusInfDb } }

    //Samples knob controls volume of deck C/D
    Wire { from: "%surface%.samples"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.3.volume" } }
    Wire { from: "%surface%.samples"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.4.volume" } }
    SamplesLevel { name: "SamplesLevel" }
    Wire { from: "%surface%.samples_led"; to: "SamplesLevel" }
}
