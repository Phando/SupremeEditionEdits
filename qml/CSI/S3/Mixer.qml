import CSI 1.0
import "../../Defines"
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

    //Master Level Meters
    LEDLevelMeter { name: "leftMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
    Wire { from: "%surface%.level_meter.left"; to: "leftMeter" }
    Wire { from: "leftMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.left"; input: false } }
    Wire { from: "leftMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left"; input: false } }

    LEDLevelMeter { name: "rightMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
    Wire { from: "%surface%.level_meter.right"; to: "rightMeter" }
    Wire { from: "rightMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.right"; input: false } }
    Wire { from: "rightMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right"; input: false } }

    //X-Fader
    Wire { from: "%surface%.xfader"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }

    //PreCue Mix Adjust
    Wire { from: "%surface%.cue_mix"; to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.mix" } }

    //EXT
    property int previousDeckType: DeckType.Track
    AppProperty { id: deckDType; path: "app.traktor.decks.4.type" }
    MappingPropertyDescriptor { id: deckDInputMode; path: "mapping.deck_d_input_mode"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { previousDeckType = deckDType.value } }
    Wire { from: "%surface%.input_mode"; to: DirectPropertyAdapter { path: "mapping.deck_d_input_mode" } }

    Wire { from: "%surface%.ext"; to: SetPropertyAdapter { path: deckDType.path; value: DeckType.Live; output: false } enabled: !shift  && deckDType.value != DeckType.Live }
    Wire { from: "%surface%.ext"; to: SetPropertyAdapter { path: deckDType.path; value: previousDeckType; output: false } enabled: !shift && deckDType.value == DeckType.Live }
    Wire { from: "%surface%.ext"; to: TogglePropertyAdapter { path: deckDInputMode.path; output: false } enabled: shift }
    Wire { from: "%surface%.ext.led"; to: ButtonScriptAdapter {
            brightness: shift || deckDType.value == DeckType.Live ? bright : dimmed
        }
    }
}
