import CSI 1.0
import QtQuick 2.12

Module {
  id: module
  property bool active: true
  property int deckId: 1

  readonly property int trackSearchRepeatMs: 300

  TransportSection { name: "transport"; channel: deckId }
  TrackSeek { name: "track_seek"; channel: deckId }

  AppProperty { id: duplicateMaster; path: "app.traktor.decks." + deckId + ".track.duplicate_deck." + (masterId.value+1) }

  Blinker { name: "PlayBlinker"; cycle: 1000; defaultBrightness: bright; blinkBrightness: dimmed }
  Wire { from: "PlayBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: !isPlaying.value || !isLoaded.value } }

  Blinker { name: "CueBlinker"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
  Wire { from: "CueBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (!isRunning.value && !activeCueWithPlayhead) || !isLoaded.value } }

  Blinker { name: "SyncBlinker"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
  Wire { from: "SyncBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: !syncInPhase } }

  ButtonScriptAdapter {
      name: "SyncButton"
      onPress: {
          holdSync_countdown.restart()
      }
      onRelease: {
          if (holdSync_countdown.running) {
              isSyncEnabled.value = !isSyncEnabled.value
          }
          holdSync_countdown.stop()
      }
  }
  Timer { id: holdSync_countdown; interval: 500
      onTriggered: {
          if (masterDeckType.value == DeckType.Track && masterId.value != -1) duplicateMaster.value = true
      }
  }

  WiresGroup {
      enabled: active

      //Play button
      WiresGroup {
          enabled: !shift
          Wire { from: "surface.play_pause"; to: TogglePropertyAdapter { path: isPlaying.path; output: !playBlinker.value } enabled: playButton.value == 0 && isLoaded.value }
          Wire { from: "surface.play_pause.value"; to: "VinylBreak"; enabled: playButton.value == 1 && isLoaded.value }
          Wire { from: "surface.play_pause"; to: SetPropertyAdapter { path: isPlaying.path; value: false; output: false } enabled: !isLoaded.value }
          //LED Blinker
          WiresGroup {
              //enabled: isLoaded.value
              Wire { from: "surface.play_pause.led"; to: "PlayBlinkerStopped"; enabled: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) }
              Wire { from: "surface.play_pause.led"; to: "PlayBlinkerCueing"; enabled: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value }
              Wire { from: "surface.play_pause"; to: ButtonScriptAdapter { color: Color.Green; brightness: isPlaying.value ? bright : dimmed } enabled: (playBlinker.value && isPlaying.value) || (!playBlinker.value && playButton.value == 1) }
          }
      }
      WiresGroup {
          enabled: shift
          Wire { from: "surface.play_pause"; to: "transport.timecode"; enabled: shiftPlayButton.value == 0 }
          WiresGroup {
              enabled: shiftPlayButton.value == 1
              Wire { from: "surface.play_pause.value"; to: "VinylBreak"; enabled: isLoaded.value }
              Wire { from: "surface.play_pause"; to: SetPropertyAdapter { path: isPlaying.path; value: false; output: false } enabled: !isLoaded.value }
              //LED Blinker
              WiresGroup {
                  //enabled: isLoaded.value
                  Wire { from: "surface.play_pause.led"; to: "PlayBlinkerStopped"; enabled: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) }
                  Wire { from: "surface.play_pause.led"; to: "PlayBlinkerCueing"; enabled: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value }
                  Wire { from: "surface.play_pause"; to: ButtonScriptAdapter { color: Color.Green; brightness: isPlaying.value ? bright : dimmed } enabled: (playBlinker.value && isPlaying.value) || !playBlinker.value }
              }
          }
          Wire { from: "surface.play_pause"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled_preserve_pitch" } enabled: shiftPlayButton.value == 2 && hasTrackProperties } //to preserve the key adjust when enabling keyLock
          Wire { from: "surface.play_pause"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" } enabled: shiftPlayButton.value == 3 && hasTrackProperties } //to reset to 0 when enabling keyLock
      }

      //Cue button
      WiresGroup {
          //enabled: isLoaded.value
          Wire { from: "surface.cue"; to: DirectPropertyAdapter { path: isCueing.path; output: !cueBlinker.value } enabled: (!shift && cueButton.value == 0) || (shift && shiftCueButton.value == 0) }
          Wire { from: "surface.cue"; to: DirectPropertyAdapter { path: isCuePlaying.path; output: !cueBlinker.value } enabled: (!shift && cueButton.value == 1) || (shift && shiftCueButton.value == 1) }
          Wire { from: "surface.cue"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".seek"; value: 0 } enabled: (!shift && cueButton.value == 2) || (shift && shiftCueButton.value == 2) }
          Wire { from: "surface.cue.led"; to: "CueBlinker"; enabled: cueBlinker.value && !((!shift && cueButton.value == 2) || (shift && shiftCueButton.value == 2)) }
      }

      Wire { from: "surface.master"; to: "transport.master" }
      Wire { from: "surface.sync"; to: "SyncButton" }
      Wire { from: "surface.sync.led"; to: "SyncBlinker"; enabled: isSyncEnabled.value }

      Wire { from: "surface.quantize"; to: TogglePropertyAdapter { path: "app.traktor.snap" } }

      Wire { from: "surface.jogwheel"; to: "track_seek.fast_seek" }
      Wire { from: "surface.search_fwd"; to: "track_seek.seek_forward" }
      Wire { from: "surface.search_rev"; to: "track_seek.seek_reverse" }
      Wire { from: "surface.needle_search"; to: "track_seek.needle_search"; enabled: !needleLock.value || (needleLock.value && !isRunning.value) }

      Wire { from: "surface.track_next"; to: TriggerPeriodicPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.next"; intervalMs: trackSearchRepeatMs } }
      Wire { enabled:  isAtBeginning; from: "surface.track_prev"; to: TriggerPeriodicPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.previous"; intervalMs: trackSearchRepeatMs } }
      Wire { enabled: !isAtBeginning; from: "surface.track_prev"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".seek"; value: 0 } }
  }
}
