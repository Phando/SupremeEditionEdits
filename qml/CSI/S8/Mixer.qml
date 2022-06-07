import CSI 1.0

Module {
    id: module
    property string surface: "hw.mixer"
    property bool shift: false

    //Channels
    Channel {
        name: "channelA"
        surface: module.surface + ".channels." + deckId
        deckId: 1
    }

    Channel {
        name: "channelB"
        surface: module.surface + ".channels." + deckId
        deckId: 2
    }

    Channel {
        name: "channelC"
        surface: module.surface + ".channels." + deckId
        deckId: 3
    }

    Channel {
        name: "channelD"
        surface: module.surface + ".channels." + deckId
        deckId: 4
    }

    //FXs Overlays
    MappingPropertyDescriptor { id: showFX1; path: "mapping.state.showFX1"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX2; path: "mapping.state.showFX2"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX3; path: "mapping.state.showFX3"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX4; path: "mapping.state.showFX4"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Master Clock
    AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
    AppProperty { id: clockBPM; path: "app.traktor.masterclock.tempo" }
    AppProperty { id: masterDeckBPM; path: "app.traktor.decks." + (masterId.value+1) + ".tempo.adjust_bpm" }
    Wire { from: "%surface%.tempo.turn"; to: EncoderScriptAdapter { onIncrement: clockBPM.value = clockBPM.value + stepBpm.value; onDecrement: clockBPM.value = clockBPM.value - stepBpm.value } enabled: !shift && masterId.value < 0 }
    Wire { from: "%surface%.tempo.turn"; to: EncoderScriptAdapter { onIncrement: clockBPM.value = clockBPM.value + stepShiftBpm.value; onDecrement: clockBPM.value = clockBPM.value - stepShiftBpm.value } enabled: shift && masterId.value < 0 }
    Wire { from: "%surface%.tempo.turn"; to: EncoderScriptAdapter { onIncrement: masterDeckBPM.value = masterDeckBPM.value + stepBpm.value; onDecrement: masterDeckBPM.value = masterDeckBPM.value - stepBpm.value } enabled: !shift && masterId.value >= 0 }
    Wire { from: "%surface%.tempo.turn"; to: EncoderScriptAdapter { onIncrement: masterDeckBPM.value = masterDeckBPM.value + stepShiftBpm.value; onDecrement: masterDeckBPM.value = masterDeckBPM.value - stepShiftBpm.value } enabled: shift && masterId.value >= 0 }
    Wire { from: "%surface%.tempo.push"; to: TogglePropertyAdapter { path: "app.traktor.masterclock.mode" } enabled: !shift }
    Wire { from: "%surface%.tempo.push"; to: SetPropertyAdapter { path: "app.traktor.masterclock.source_id"; value: -1 } enabled: shift }

    //Snap & Quantize
    Wire { from: "%surface%.snap"; to: TogglePropertyAdapter { path: "app.traktor.snap" } enabled: !shift }
    Wire { from: "%surface%.snap"; to: TogglePropertyAdapter { path: scratchWithTouchstrip.path } enabled: shift }
    Wire { from: "%surface%.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant" } enabled: !shift}

    //X-Fader
    Wire { from: "%surface%.xfader.adjust"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }
    Wire { from: "%surface%.xfader.curve"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.curve" } }
}
