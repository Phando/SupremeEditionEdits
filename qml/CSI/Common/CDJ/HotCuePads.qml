import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    Hotcues { name: "hotcues"; channel: deckId }
    CuePointsProvider { name: "cuepoints_provider"; channel: deckId }

    AppProperty { id: hotcue1Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.exists" }
    AppProperty { id: hotcue2Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.exists" }
    AppProperty { id: hotcue3Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.exists" }
    AppProperty { id: hotcue4Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.4.exists" }
    AppProperty { id: hotcue5Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.5.exists" }
    AppProperty { id: hotcue6Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.6.exists" }
    AppProperty { id: hotcue7Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.7.exists" }
    AppProperty { id: hotcue8Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.8.exists" }

    WiresGroup {
        enabled: active

        Wire { from: "surface.cue_points"; to: "cuepoints_provider.output" }

        WiresGroup {
            enabled: !shift
            Wire { from: "surface.hotcue_a"; to: "hotcues.1.trigger" }
            Wire { from: "surface.hotcue_b"; to: "hotcues.2.trigger" }
            Wire { from: "surface.hotcue_c"; to: "hotcues.3.trigger" }
            Wire { from: "surface.hotcue_d"; to: "hotcues.4.trigger" }
            Wire { from: "surface.hotcue_e"; to: "hotcues.5.trigger" }
            Wire { from: "surface.hotcue_f"; to: "hotcues.6.trigger" }
            Wire { from: "surface.hotcue_g"; to: "hotcues.7.trigger" }
            Wire { from: "surface.hotcue_h"; to: "hotcues.8.trigger" }
        }

        WiresGroup {
            enabled: shift
            Wire { from: "surface.hotcue_a"; to: "hotcues.1.delete" }
            Wire { from: "surface.hotcue_b"; to: "hotcues.2.delete" }
            Wire { from: "surface.hotcue_c"; to: "hotcues.3.delete" }
            Wire { from: "surface.hotcue_d"; to: "hotcues.4.delete" }
            Wire { from: "surface.hotcue_e"; to: "hotcues.5.delete" }
            Wire { from: "surface.hotcue_f"; to: "hotcues.6.delete" }
            Wire { from: "surface.hotcue_g"; to: "hotcues.7.delete" }
            Wire { from: "surface.hotcue_h"; to: "hotcues.8.delete" }
        }

        WiresGroup {
            enabled: hotcuesPlayMode.value
            Wire { enabled: hotcue1Exists.value; from: "surface.hotcue_a"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue2Exists.value; from: "surface.hotcue_b"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue3Exists.value; from: "surface.hotcue_c"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue4Exists.value; from: "surface.hotcue_d"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue5Exists.value; from: "surface.hotcue_e"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue6Exists.value; from: "surface.hotcue_f"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue7Exists.value; from: "surface.hotcue_g"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            Wire { enabled: hotcue8Exists.value; from: "surface.hotcue_h"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
        }
    }
}
