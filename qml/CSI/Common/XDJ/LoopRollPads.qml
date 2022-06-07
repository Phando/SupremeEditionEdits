import CSI 1.0
import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1

    WiresGroup {
        enabled: active

        Wire { from: "surface.beat_loop_1_2";     to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_1_2 } }
        Wire { from: "surface.beat_loop_1";       to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_1 } }
        Wire { from: "surface.beat_loop_2";       to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_2 } }
        Wire { from: "surface.beat_loop_4";       to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_4 } }
        Wire { from: "surface.beat_loop_8";       to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_8 } }
        Wire { from: "surface.beat_loop_16";      to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.set.auto_with_size"; value: LoopSize.loop_16 } }
    }
}
