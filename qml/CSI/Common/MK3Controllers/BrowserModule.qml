import CSI 1.0

Module {
    id: module
    property bool active: true
    property string surface: "path"
    property int deckId: 1
    property bool navigateFavoritesOnShift: true

    Browser { name: "browser" }

    WiresGroup {
        enabled: active

        Wire { from: "%surface%.browse.mode"; to: "browser.full_screen" }

        WiresGroup {
            enabled: !shift

            Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.selected" } }
            Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation" }
            Wire { from: "%surface%.browse.back"; to: "browser.add_remove_from_prep_list" }
        }

        WiresGroup {
            enabled: shift
            Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.selected" } }

            Wire { from: "%surface%.browse.encoder"; to: "browser.tree_navigation"; enabled: !navigateFavoritesOnShift }
            Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled: navigateFavoritesOnShift }
            Wire { from: "%surface%.browse.back"; to: "browser.jump_to_prep_list" }
        }
    }
}
