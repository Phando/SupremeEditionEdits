import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    WiresGroup {
        enabled: active && keyLock.value

        Wire { from: "surface.key_shift_up"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; step: 1/12; mode: RelativeMode.Increment } }
        Wire { from: "surface.key_shift_down"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; step: 1/12; mode: RelativeMode.Decrement } }
        Wire { from: "surface.key_reset"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0 } }
    }
}
