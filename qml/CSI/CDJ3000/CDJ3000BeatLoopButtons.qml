import CSI 1.0

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: !isInActiveLoop.value

            Wire { from: "surface.4_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_4 } }
            Wire { from: "surface.8_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_8 } }
        }

        WiresGroup {
            enabled: isInActiveLoop.value

            WiresGroup {
                enabled: quantizedLoopSizes.value

                Wire { from: "surface.4_beat_loop"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.size"; mode: RelativeMode.Decrement } }
                Wire { from: "surface.8_beat_loop"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.size"; mode: RelativeMode.Increment } }
            }

            WiresGroup {
                enabled: !quantizedLoopSizes.value

                Wire { from: "surface.4_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
                Wire { from: "surface.4_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
                Wire { from: "surface.4_beat_loop"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; output: false } }

                Wire { from: "surface.8_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
                Wire { from: "surface.8_beat_loop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
                Wire { from: "surface.8_beat_loop"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; output: false } }
            }
        }
    }
}
