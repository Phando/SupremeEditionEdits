import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    AppProperty { id: isGridLocked; path: "app.traktor.decks." + deckId + ".track.grid.lock_bpm" }
    AppProperty { id: precueTiming; path: "app.traktor.decks." + deckId + ".track.grid.enable_tick" }
    AppProperty { id: sequencerOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.on" }
    AppProperty { id: sequencerRecOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on";
        onValueChanged: {
            if (sequencerRecOn.value) {
                sequencerOn.value = true
                precueTiming.value = true
            }
        }
    }

    WiresGroup {
        enabled: screenView.value == ScreenView.deck

        //Set & Delete Grid
        WiresGroup {
            enabled: active && hasEditMode && !isGridLocked.value && activePadsMode.value != PadsMode.remix //this will allow to enable/disable the recording feature when the unfocused deck is a remix deck and is in the new remix mode

            Wire { from: "%surface%.capture"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.gridmarker.set"; output: false } enabled: !shift }
            Wire { from: "%surface%.capture"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.gridmarker.delete"; output: false } enabled: shift }
            Wire { from: "%surface%.capture"; to: ButtonScriptAdapter { brightness: dimmed; onPress: { brightness = bright } onRelease: { brightness = dimmed } } }
        }

        //Pattern Recorder
        Wire { from: "%surface%.capture"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on" } enabled: deck.remixControlled && activePadsMode.value == PadsMode.remix }
    }
}
