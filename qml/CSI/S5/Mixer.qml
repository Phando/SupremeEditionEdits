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

    //Master Level Meters
    Wire { from: "%surface%.clip.left"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left" } }
    Wire { from: "%surface%.clip.right"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right" } }

    //Snap & Quantize
    Wire { from: "%surface%.snap"; to: TogglePropertyAdapter { path: "app.traktor.snap" } enabled: !shift }
    Wire { from: "%surface%.snap"; to: TogglePropertyAdapter { path: "mapping.settings.scratch_with_touchstrip" } enabled: shift }
    Wire { from: "%surface%.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant" } enabled: !shift}
    Wire { from: "%surface%.quant"; to: TogglePropertyAdapter { path: "app.traktor.measurement.enable" } enabled: shift}

    //Master Clock
    AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
    AppProperty { id: clockBpm; path: "app.traktor.masterclock.tempo" }
    AppProperty { id: deckBpm; path: "app.traktor.decks." + (masterId.value+1) + ".tempo.adjust_bpm" }
    Wire { from: "%surface%.tempo"; to: EncoderScriptAdapter { onIncrement: clockBpm.value = clockBpm.value + stepBpm.value; onDecrement: clockBpm.value = clockBpm.value - stepBpm.value } enabled: !shift && masterId.value < 0 }
    Wire { from: "%surface%.tempo"; to: EncoderScriptAdapter { onIncrement: clockBpm.value = clockBpm.value + stepShiftBpm.value; onDecrement: clockBpm.value = clockBpm.value - stepShiftBpm.value } enabled: shift && masterId.value < 0 }
    Wire { from: "%surface%.tempo"; to: EncoderScriptAdapter { onIncrement: deckBpm.value = deckBpm.value + stepBpm.value; onDecrement: deckBpm.value = deckBpm.value - stepBpm.value } enabled: !shift && masterId.value >= 0 }
    Wire { from: "%surface%.tempo"; to: EncoderScriptAdapter { onIncrement: deckBpm.value = deckBpm.value + stepShiftBpm.value; onDecrement: deckBpm.value = deckBpm.value - stepShiftBpm.value } enabled: shift && masterId.value >= 0 }
    Wire { from: "%surface%.tempo.push"; to: TogglePropertyAdapter { path: "app.traktor.masterclock.mode" } enabled: !shift }
    Wire { from: "%surface%.tempo.push"; to: SetPropertyAdapter { path: "app.traktor.masterclock.source_id"; value: -1 } enabled: shift }

    //X-Fader
    Wire { from: "%surface%.xfader.adjust"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }
}
