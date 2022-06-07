import CSI 1.0

Module {
  id: module
  property bool active: true
  property int deckId: 1

  MappingPropertyDescriptor {
    id: remain
    path: deckPropertiesPath + ".time_remain"
    type: MappingPropertyDescriptor.Boolean;
    value: true;
  }

  WiresGroup {
      enabled: active

      Wire { from: "surface.display.time_enable"; to: ValuePropertyAdapter { path: "app.traktor.decks." + deckId + ".is_loaded" } }
      //Wire { from: "surface.display.current_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.player.elapsed_time" } } //moved to JogWheel.qml ?
      Wire { from: "surface.display.total_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.content.track_length" } }
      Wire { from: "surface.display.bpm"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.true_bpm" } }
      Wire { from: "surface.display.tempo"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.true_tempo" } }
      Wire { from: "surface.display.tempo_range"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.range_select" } }

      Wire { from: "surface.track_info.title";  to: ValuePropertyAdapter { path: "app.traktor.decks." + deckId + ".content.title"  } }
      Wire { from: "surface.track_info.album";  to: ValuePropertyAdapter { path: "app.traktor.decks." + deckId + ".content.album"  } }
      Wire { from: "surface.track_info.artist"; to: ValuePropertyAdapter { path: "app.traktor.decks." + deckId + ".content.artist" } }
      Wire { from: "surface.track_info.bpm"; to: ValuePropertyAdapter { path: "app.traktor.decks." + deckId + ".content.display_bpm" } }

      Wire { from: "surface.time_acue"; to: TogglePropertyAdapter { path: remain.path; defaultValue: false } }
  }

}
