import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    Hotcues { name: "hotcues"; channel: deckId }

    CuePointsProvider { name: "cuepoints_provider"; channel: deckId }
    Wire { from: "surface.cue_points"; to: "cuepoints_provider.output"; enabled: active }

    MappingPropertyDescriptor {
      id: cuePointDelete
      path: deckPropertiesPath + ".cue_delete"
      type: MappingPropertyDescriptor.Boolean;
    }

    Wire {
        from: "surface.delete"
        to: TogglePropertyAdapter { path: deckPropertiesPath + ".cue_delete" }
        enabled: active
    }

    WiresGroup {
      enabled: !cuePointDelete.value && active
      Wire { from: "surface.hotcue_a"; to: "hotcues.1.trigger" }
      Wire { from: "surface.hotcue_b"; to: "hotcues.2.trigger" }
      Wire { from: "surface.hotcue_c"; to: "hotcues.3.trigger" }
    }

    AppProperty { path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.exists"; id: hotcue1exists }
    AppProperty { path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.exists"; id: hotcue2exists }
    AppProperty { path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.exists"; id: hotcue3exists }

    WiresGroup {
      enabled: cuePointDelete.value && active
      Wire { from: "surface.hotcue_a"; to: TriggerPropertyAdapter{ path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.delete"; color: Color.Red } enabled: hotcue1exists.value }
      Wire { from: "surface.hotcue_b"; to: TriggerPropertyAdapter{ path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.delete"; color: Color.Red } enabled: hotcue2exists.value }
      Wire { from: "surface.hotcue_c"; to: TriggerPropertyAdapter{ path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.delete"; color: Color.Red } enabled: hotcue3exists.value }
    }
}
