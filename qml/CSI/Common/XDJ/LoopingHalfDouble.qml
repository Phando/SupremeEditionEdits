import CSI 1.0
import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: quantizedLoopSizes.value

            Wire { from: "surface.beat_loop_half"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.size"; mode: RelativeMode.Decrement } }
            Wire { from: "surface.beat_loop_double"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.size"; mode: RelativeMode.Increment } }
        }

        WiresGroup {
            enabled: !quantizedLoopSizes.value

            Wire { from: "surface.beat_loop_half"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
            Wire { from: "surface.beat_loop_half"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "surface.beat_loop_half"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; output: false } }

            Wire { from: "surface.beat_loop_double"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
            Wire { from: "surface.beat_loop_double"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "surface.beat_loop_double"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; output: false } }
        }
    }

    WiresGroup {
        enabled: active && loopActive.value

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
