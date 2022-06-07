import CSI 1.0
import QtQuick 2.12

Module {
    id: module
    property bool active: true
    property int deckId: 1

    Blinker { name: "BrowseBlinker"; cycle: 250; repetitions: 4; defaultBrightness: bright; blinkBrightness: dimmed }
    Wire { from: "surface.browse.LED"; to: "BrowseBlinker" }

    Timer { id: deckLoaded_countdown; interval: 1000 }
    AppProperty { path: "app.traktor.decks." + deckId + ".is_loaded_signal"; onValueChanged: { deckLoaded_countdown.restart() } }
    Wire { from: "BrowseBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: deckLoaded_countdown.running } }
}
