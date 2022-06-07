import CSI 1.0

import "../Common/Pioneer"
import "../Common/CDJ"

Module {
  id: deck
  property bool active: true
  property int deckId: 1

  //Helper properties
  readonly property string deckSettingsPath: "mapping.settings.deck." + deckId
  readonly property string deckPropertiesPath: "mapping.state.deck." + deckId
  property bool shift: call.value

//------------------------------------------------------------------------------------------------------------------
// APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //State properties
    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" } //0: Track, 1: Remix, 2: Stem, 3: Live
    AppProperty { path: "app.traktor.decks." + deckId + ".is_loaded_signal";
        onValueChanged: {
            if (value) fullscreenBrowser.value = false
        }
    }
    AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
    AppProperty { id: volume; path: "app.traktor.mixer.channels." + deckId + ".volume" }

    //Transport
    AppProperty { id: isRunning; path: "app.traktor.decks." + deckId + ".running" }
    AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }
    AppProperty { id: isCueing; path: "app.traktor.decks." + deckId + ".cue" }
    AppProperty { id: isCuePlaying; path: "app.traktor.decks." + deckId + ".cup" }
    AppProperty { id: cuePosition; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" }
    AppProperty { id: playheadPosition; path: "app.traktor.decks."  + deckId + ".track.player.playhead_position" }
    AppProperty { id: elapsedTime; path: "app.traktor.decks." + deckId + ".track.player.elapsed_time" }
    readonly property real timeTolerance: 0.001 // seconds
    readonly property bool isAtBeginning: elapsedTime.value < timeTolerance
    property bool activeCueWithPlayhead: Math.abs(cuePosition.value - playheadPosition.value) < timeTolerance

    //Loop
    AppProperty { id: loopActive; path: "app.traktor.decks."+ deckId + ".loop.active" }
    AppProperty { id: isInActiveLoop; path: "app.traktor.decks."+ deckId + ".loop.is_in_active_loop";
        onValueChanged: {
            loopInAdjust.value = false;
            loopOutAdjust.value = false;
            if (reloopMode.value && !isInActiveLoop.value) loopActive.value = false
        }
    }

    //Move
    AppProperty { id: move; path: "app.traktor.decks." + deckId + ".move" }
    AppProperty { id: moveMode; path: "app.traktor.decks." + deckId + ".move.mode" }
    AppProperty { id: moveSize; path: "app.traktor.decks." + deckId + ".move.size" }

    //Flux
    AppProperty { id: fluxEnabled; path: "app.traktor.decks." + deckId + ".flux.enabled" }
    AppProperty { id: fluxState; path: "app.traktor.decks." + deckId + ".flux.state" }

    //Tempo & BPM
    AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }
    AppProperty { id: tempobend; path: "app.traktor.decks." + deckId + ".tempobend.stepless" }

    AppProperty { id: stableTempo; path: "app.traktor.decks." + deckId + ".tempo.true_tempo" }
    AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.tempo_for_display" }
    AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
    AppProperty { id: tempoRange; path: "app.traktor.decks." + deckId + ".tempo.range_value" }
    readonly property double phase: (tempoPhase.value*2).toFixed(4)
    readonly property bool syncInPhase: phase >= -0.0315 && phase <= 0.0315
    readonly property bool syncInRange: Math.abs(stableTempo.value-1).toFixed(4) <= tempoRange.value.toFixed(4)

    //Key
    AppProperty { id: key; path: "app.traktor.decks." + deckId + ".content.musical_key" }
    AppProperty { id: keyText; path: "app.traktor.decks." + deckId + ".content.legacy_key" }
    AppProperty { id: keyIndex; path: "app.traktor.decks." + deckId + ".content.key_index" }
    AppProperty { id: keyLock; path: "app.traktor.decks." + deckId + ".track.key.lock_enabled"; onValueChanged: { if (!keyLock.value) keyAdjust.value = 0 } }
    AppProperty { id: keyAdjust; path: "app.traktor.decks." + deckId + ".track.key.adjust" }
    AppProperty { id: resultingKey; path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
    AppProperty { id: resultingKeyIndex; path: "app.traktor.decks." + deckId + ".track.key.final_id" }
    property int keyTextIndex: useKeyText.value ? Key.getKeyTextId(keyText.value, keyAdjust.value) : resultingKeyIndex.value
    property double keyTextOffset: useKeyText.value ? KeySync.sync(resultingKeyIndex.value, Key.getKeyTextId(keyText.value, keyAdjust.value), false) : 0

    //Freeze Properties
    AppProperty { id: sliceCount; path: "app.traktor.decks." + deckId + ".freeze.slice_count" }
    AppProperty { id: freezeEnabled; path: "app.traktor.decks." + deckId + ".freeze.enabled";
        onValueChanged: {
            if (value) {
                sliceCount.value = 8
            }
        }
    }

    //Track Properties
    AppProperty { id: waveformZoom; path: "app.traktor.decks." + deckId + ".track.waveform_zoom" }
    AppProperty { id: gridLock; path: "app.traktor.decks." + deckId + ".track.grid.lock_bpm" }
    AppProperty { id: gridAdjust; path: "app.traktor.decks." + deckId + ".track.gridmarker.move" }

    //Remix Properties
    AppProperty { id: remixPage; path: "app.traktor.decks." + deckId + ".remix.page" }

    //Traktor Pro Advanced Panel
    AppProperty { id: advancedPanel; path: "app.traktor.decks." + deckId + ".view.select_advanced_panel" } //0: Hotcues, 1: Loop, 2: Grid
    function updateAdvancedPanelView() {
        if (hasDeckProperties){ //add preference to enable this features
            if (!holdGrid.value && !editMode.value){
                if (padsMode.value == PadsMode.loop || padsMode.value == PadsMode.advancedLoop) advancedPanel.value = 0
                else advancedPanel.value = 1
            }
            else {
                advancedPanel.value = 2
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// MAPPING PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //Helper Properties
    property bool hasDeckProperties: (deckType.value == DeckType.Track || deckType.value == DeckType.Stem || deckType.value == DeckType.Remix) && !directThru.value
    property bool hasTrackProperties: (deckType.value == DeckType.Track || deckType.value == DeckType.Stem) && !directThru.value
    property bool hasRemixProperties: deckType.value == DeckType.Remix && !directThru.value
    property bool hasStemProperties: deckType.value == DeckType.Stem && !directThru.value

    //HW State Properties
    MappingPropertyDescriptor { id: loopInAdjust; path: deckPropertiesPath + ".loopInAdjust"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { if (value) loopOutAdjust.value = false } }
    MappingPropertyDescriptor { id: loopOutAdjust; path: deckPropertiesPath + ".loopOutAdjust"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { if (value) loopInAdjust.value = false } }

//------------------------------------------------------------------------------------------------------------------
// MODULES
//------------------------------------------------------------------------------------------------------------------

  CDJCommonDeck { name: "common_deck"; deckId: deck.deckId; active: deck.active }

  BrowserModule { name: "browser"; deckId: deck.deckId; lines: 10; useHeader: true; active: deck.active }

  CDJ3000BeatLoopButtons { name: "beat_loop_buttons"; deckId: deck.deckId; active: deck.active }

  CDJ3000BeatjumpButtons { name: "beatjump_buttons"; deckId: deck.deckId; active: deck.active }

  KeyShift { name: "key_shift"; deckId: deck.deckId; active: deck.active }

  KeySync { name: "key_sync"; deckId: deck.deckId; active: deck.active }

  XDJPhaseMeter { name: "phase_meter"; channel: deckId }
  Wire { from: "surface.deck_phase_info"; to:"phase_meter.deck.value"; enabled: active }
  Wire { from: "surface.master_phase_info"; to:"phase_meter.master.value"; enabled: active }

  MappingPropertyDescriptor { id: call; path: deckPropertiesPath + ".call"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "surface.hotcue_delete"; to: HoldPropertyAdapter { path: call.path } enabled: active }
}
