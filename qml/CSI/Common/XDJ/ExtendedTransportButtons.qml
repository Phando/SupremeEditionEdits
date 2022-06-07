import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    WiresGroup {
        enabled: active
        Wire { from: "surface.slip"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".flux.enabled" } }
        Wire { from: "surface.reverse"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".reverse" } }
    }
}
