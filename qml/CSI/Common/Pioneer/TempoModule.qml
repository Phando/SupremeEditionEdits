import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    function enforceSupportedRange() {
        tempoRangeSwitch.enforceSupportedRange();
    }

    TempoRangeSwitch { id: tempoRangeSwitch; name: "tempo_range"; deckId: module.deckId; active: module.active }

    MappingPropertyDescriptor {
        id: faderMode
        path: deckPropertiesPath + "tempo_fader_relative";
        type: MappingPropertyDescriptor.Boolean;
        value: false;
    }

    DirectPropertyAdapter { name: "tempo_fader_relative"; path: faderMode.path; input: false }
    Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode"; enabled: active }

    TempoControl { name: "tempo_control"; channel: deckId }
    WiresGroup {
        enabled: active
        Wire { from: "surface.master_tempo";  to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" } }
        Wire { from: "surface.tempo_fader";   to: "tempo_control.adjust" }
    }

    /*
    SoftTakeoverTempoFader {
        name: "softtakeover_tempo_fader"
        deck: module.deck
        propertiesPath: deckPropertiesPath + ".softtakeover.tempo_fader"
        enabled: active
    }
    Wire { from: "softtakeover_tempo_fader.softtakeover.output"; to: "tempo_control.adjust"; enabled: active }
    */
}
