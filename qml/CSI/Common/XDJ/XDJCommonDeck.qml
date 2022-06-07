import CSI 1.0

import "../Pioneer"

Module {
    id: module
    property bool active: true
    property int deckId: 1

    onActiveChanged: { if(active) tempo.enforceSupportedRange(); }

    DeckInfo { name: "deck_info"; deckId: module.deckId; active: module.active }

    TransportButtons { name: "transport_buttons"; deckId: module.deckId; active: module.active }

    ExtendedTransportButtons { name: "extended_transport_buttons"; deckId: module.deckId; active: module.active }

    TempoModule { name: "tempo"; id: tempo; deckId: module.deckId; active: module.active }

    JogWheel { name: "jogwheel"; deckId: module.deckId; active: module.active }

    LoopingBasic { name: "looping_basic"; deckId: module.deckId; active: module.active }

    LoopingHalfDouble { name: "looping_half_double"; deckId: module.deckId; active: module.active }

    LoopRollPads { name: "loop_roll_pads"; deckId: module.deckId; active: module.active }
}
