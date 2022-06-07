import CSI 1.0

Module {
  id: module
  property bool active: true
  property int deckId: 1
  property bool jogTouch: false

  DeckAlbumArtProvider { name: "deck_album_art"; channel: deckId }

  WiresGroup {
      enabled: active

      Wire { from: "surface.display.pause_state_active"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (!isRunning.value && !activeCueWithPlayhead) || jogTouch } }

      Wire { from: "surface.display.current_cue_enable"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".is_loaded" } }
      Wire { from: "surface.display.current_cue_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" } }
      Wire { from: "surface.display.jog_cue_point_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" } }

      //Wire { from: "surface.display.slip_state_active"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".flux.enabled" } }
      Wire { from: "surface.display.slip_current_time"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.player.flux_position" } }

      Wire { from: "surface.track_info.album_art"; to: "deck_album_art.output" }

      Wire { from: "surface.display.original_key_index"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".content.key_index" } }
      Wire { from: "surface.display.current_key_index"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.final_id" } }
      Wire { from: "surface.display.key_shift_value"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust" } enabled: keyLock.value }
  }

}
