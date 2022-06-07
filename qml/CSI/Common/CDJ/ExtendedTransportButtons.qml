import CSI 1.0

Module {
  id: module
  property bool active: true
  property int deckId: 1

  TransportSection { name: "transport"; channel: deckId }

  WiresGroup {
      enabled: active
      Wire { from: "surface.slip"; to: "transport.flux" }
      Wire { from: "surface.slip_reverse"; to: "transport.flux_reverse" }
      Wire { from: "surface.reverse"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".reverse" } }
  }
}
