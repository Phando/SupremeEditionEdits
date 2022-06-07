import CSI 1.0

import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property bool loopControls: false

    WiresGroup {
        enabled: active

        // Cue controls
        Wire { from: "surface.cue_memory"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.store" } }
        Wire { from: "surface.cue_delete"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete" } }

        WiresGroup {
            enabled: !loopControls || !isInActiveLoop.value || !isPlaying.value

            Wire { from: "surface.call_prev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: false } }
            Wire { from: "surface.call_next"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: false } }
            Wire { from: "surface.call_prev"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.jump_to_next_prev"; value: -1 } }
            Wire { from: "surface.call_next"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.jump_to_next_prev"; value: 1 } }
        }

        // Loop controls
        WiresGroup {
            enabled: loopControls && isInActiveLoop.value && isPlaying.value

            WiresGroup {
                enabled: quantizedLoopSizes.value

                Wire { from: "surface.call_prev"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.size"; mode: RelativeMode.Decrement } }
                Wire { from: "surface.call_next"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.size"; mode: RelativeMode.Increment } }
            }

            WiresGroup {
                enabled: !quantizedLoopSizes.value

                Wire { from: "surface.call_prev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
                Wire { from: "surface.call_prev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
                Wire { from: "surface.call_prev"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; output: false } }

                Wire { from: "surface.call_next"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
                Wire { from: "surface.call_next"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
                Wire { from: "surface.call_next"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; output: false } }
            }
        }
    }
}
