import CSI 1.0

Module {
    property bool active: true
    property int deckId: 1

    property string propertiesPath: "mapping.state.tempo_fader"

    AppProperty { id: baseBPM; path: "app.traktor.decks." + deckId + ".tempo.base_bpm" }
    AppProperty { id: tempoRange; path: "app.traktor.decks." + deckId + ".tempo.range_value" }

    MappingPropertyDescriptor { id: active; path: propertiesPath + ".active"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: input; path: propertiesPath + ".input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { id: output; path: propertiesPath + ".output"; type: MappingPropertyDescriptor.Float; value: 0.0 }

    SoftTakeover { name: "softtakeover" }
    SwitchTimer { name: "actiontimer"; resetTimeout: 20 }
    And { name: "indicate"; inputs: [ "actiontimer.output", "softtakeover.active" ] }

    Wire { from: "surface.tempo_fader"; to: "softtakeover.input" }
    Wire { from: "surface.tempo_fader"; to: "actiontimer.input" }
    Wire { from: "softtakeover.active"; to: DirectPropertyAdapter { path: active.path } }
    Wire { from: "softtakeover.input_monitor"; to: DirectPropertyAdapter { path: input.path } }
    Wire { from: "softtakeover.output_monitor"; to: DirectPropertyAdapter { path: output.path } }

    WiresGroup {
        enabled: active
        //Wire { from: "softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust" } }

        //The following surface sockets aren't available yet (and don't exist on the XDJ-700!)
        Wire { from: "surface.display.takeover_enable"; to: DirectPropertyAdapter { path: active.path } }
        Wire { from: "surface.display.sync_slave_bpm"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: baseBPM.value * (input.value * tempoRange.value + 1) } }

        //The following code is for testing purposes only, and needs to comment the wires located in the DeckInfo.qml file to see the results
        Wire { from: "surface.display.bpm"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: baseBPM.value * (input.value * tempoRange.value + 1) } enabled: active.value }
        Wire { from: "surface.display.bpm"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.true_bpm" } enabled: !active.value }
    }
}
