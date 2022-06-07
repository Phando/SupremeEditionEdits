import CSI 1.0

import "../Pioneer"

Module {
  id: module
  property bool active: true
  property int deckId: 1

  onActiveChanged: { if(active) tempo.enforceSupportedRange(); }

  DeckInfo { name: "deck_info"; deckId: deck.deckId; active: module.active }

  ExtendedDeckInfo { name: "extended_deck_info"; deckId: deck.deckId; jogTouch: jogwheel.jogTouch; active: module.active }

  BrowseEncoderLED { name: "browse_led"; deckId: deck.deckId; active: module.active }

  TransportButtons { name: "transport_buttons"; deckId: deck.deckId; active: module.active }

  ExtendedTransportButtons { name: "extended_transport_buttons"; deckId: deck.deckId; active: module.active }

  TempoModule { name: "tempo"; id: tempo; deckId: deck.deckId; active: module.active }
  WiresGroup {
      enabled: active
      Wire { from: "surface.tempo_reset"; to: "tempo.tempo_control.lock"; enabled: !shift }
      Wire { from: "surface.tempo_reset"; to: "tempo.tempo_control.reset"; enabled: shift && !isSyncEnabled.value }
      Wire { from: "surface.tempo_reset.led"; to: "tempo.tempo_control.indicator" }
  }

  Waveform { name: "waveform"; deckId: deck.deckId; active: module.active }

  Stripe { name: "stripe"; deckId: deck.deckId; active: module.active  }

  JogWheel { name: "jogwheel"; id: jogwheel; deckId: deck.deckId; active: module.active }
  Wire { from: "surface.jogwheel.LED"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".is_loaded"; input: false; color: Color.White } }

  LoopingBasic { name: "looping_basic"; deckId: deck.deckId; active: module.active }

  CueLoopCall { name: "cue_loop_call"; deckId: deck.deckId; loopControls: true; active: module.active }

  HotCuePads { name: "hotcues"; deckId: deck.deckId; active: module.active }

  LoopRollPads { name: "loop_roll_pads"; deckId: deck.deckId; active: module.active }

  BeatjumpPads { name: "beatjump_pads"; deckId: deck.deckId; active: module.active }
}
