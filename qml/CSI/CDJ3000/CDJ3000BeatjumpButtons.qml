import CSI 1.0

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1

    WiresGroup {
        enabled: active

        Wire { from: "surface.display.beat_jump_setting"; to: ValuePropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size" } }

        WiresGroup {
            enabled: !shift

            Wire { from: "surface.beatjump_rev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 0; output: false } }
            Wire { from: "surface.beatjump_fwd"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 0; output: false } }
            Wire { from: "surface.beatjump_rev"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1 } }
            Wire { from: "surface.beatjump_fwd"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1 } }
        }

        WiresGroup {
            enabled: shift

            Wire { from: "surface.beatjump_rev"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; mode: RelativeMode.Decrement } }
            Wire { from: "surface.beatjump_fwd"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; mode: RelativeMode.Increment } }
        }
    }
}
