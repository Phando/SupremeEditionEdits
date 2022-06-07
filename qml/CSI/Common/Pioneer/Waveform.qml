import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    // Waveform Data
    WaveformProvider { name: "waveform_provider"; channel: deckId }
    WiresGroup {
        enabled: active
        Wire { from: "surface.grid_info"; to: "waveform_provider.grid" }
        Wire { from: "surface.waveform_info"; to: "waveform_provider.waveform" }
        Wire { from: "waveform_provider.color"; to: ValuePropertyAdapter { path: "app.traktor.settings.waveform.color"; input: false } }
    }

    // Loop Information
    AppProperty { id: activeCueType; path: "app.traktor.decks." + deckId + ".track.cue.active.type" }
    AppProperty { id: activeCueStart; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" }
    AppProperty { id: activeCueLength; path: "app.traktor.decks." + deckId + ".track.cue.active.length" }

    readonly property bool loopInfoAvailable: activeCueType.value === CueType.Loop
    readonly property real activeCueEnd: activeCueStart.value + activeCueLength.value

    WiresGroup {
        enabled: active
        Wire { from: "surface.display.waveform_draw_loop"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: loopInfoAvailable } }

        WiresGroup {
            enabled: loopInfoAvailable
            Wire { from: "surface.display.waveform_loop_start";  to: ValuePropertyAdapter { path: activeCueStart.path } }
            Wire { from: "surface.display.waveform_loop_end"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: activeCueEnd } }
            Wire { from: "surface.display.waveform_loop_active"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: !loopActive.value } }
        }
    }

}
