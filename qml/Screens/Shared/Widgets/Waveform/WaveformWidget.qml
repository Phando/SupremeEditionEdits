import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor

import '../../../../Defines'
import '..' as Widgets

Item {
  id: view
  property int deckId: 1
  property string deckPropertiesPath: propertiesPath + "." + deckId
  property int sampleWidth: 1

  property int waveformX: wfPosition.waveformPos //WIP in TrackDeck.qml

  MappingProperty { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size" }

  AppProperty { id: primaryKey; path: "app.traktor.decks." + deckId + ".track.content.entry_key" } //this refers to the "number of the track in the collection"
  AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
  AppProperty { id: sampleRate; path: "app.traktor.decks."  + deckId + ".track.content.sample_rate"; onValueChanged: { updateLooping() } }

  AppProperty { id: freezeEnabled; path: "app.traktor.decks." + deckId + ".freeze.enabled" }
  AppProperty { id: freezeCount; path: "app.traktor.decks." + deckId + ".freeze.slice_count" }
  AppProperty { id: freezeStart; path: "app.traktor.decks." + deckId + ".freeze.slice_start_in_sec" }
  AppProperty { id: freezeWidth; path: "app.traktor.decks." + deckId + ".freeze.slice_width_in_sec" }

  AppProperty { id: fluxState; path: "app.traktor.decks."  + deckId + ".flux.state" }
  AppProperty { id: fluxPosition; path: "app.traktor.decks."  + deckId + ".track.player.flux_position" }

  // If the playhead is in a loop, propIsLooping is TRUE and the loop becomes the active cue.
  AppProperty { id: propIsLooping; path: "app.traktor.decks." + deckId + ".loop.is_in_active_loop"; onValueChanged: { updateLooping() } }
  AppProperty { id: propLoopStart; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos"; onValueChanged: { updateLooping() } }
  AppProperty { id: propLoopLength; path: "app.traktor.decks." + deckId + ".track.cue.active.length"; onValueChanged: { updateLooping() } }

//--------------------------------------------------------------------------------------------------------------------
// WAVEFORM
//------------------------------------------------------------------------------------------------------------------

  property double freezeZoomWidth: freezeWidth.value * freezeCount.value / slicer.zoom_factor * sampleRate.value
  property double freezePositionInWaveform: (freezeStart.value - (0.5 * freezeWidth.value * slicer.zoom_factor)) * sampleRate.value

  function updateLooping() {
    if (propIsLooping.value) {
        var loopStart  = propLoopStart.value  * sampleRate.value;
        var loopLength = propLoopLength.value * sampleRate.value;
        wfPosition.clampPlayheadPos(loopStart, loopLength);
    }
    else wfPosition.unclampPlayheadPos();
  }

  Traktor.WaveformPosition {
    id: wfPosition
    deckId: parent.deckId-1 //because is a Traktor Translator, and in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    followsPlayhead: !freezeEnabled.value && !beatgrid.editEnabled
    waveformPos: beatgrid.editEnabled ? beatgrid.posOnEdit : (freezeEnabled.value ? freezePositionInWaveform : playheadPos)
    sampleWidth: beatgrid.editEnabled ? beatgrid.widthOnEdit : (freezeEnabled.value ? freezeZoomWidth : view.sampleWidth)
    viewWidth: singleWaveform.width

    Behavior on sampleWidth { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on waveformPos { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic }  enabled: (freezeEnabled.value || beatgrid.editEnabled) }
  }

  SingleWaveform {
    id: singleWaveform
    deckId: parent.deckId
    sampleWidth: view.sampleWidth
    waveformPosition: wfPosition
    waveformColors: dynamicWF.value ? dynamicWaveformColorsMap[waveformColor.value] : colors.getDefaultWaveformColors(waveformColor.value)

    anchors.fill: view
    anchors.leftMargin: 3
    anchors.rightMargin: 3

    clip: true
    height: view.height

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Beatgrid
//--------------------------------------------------------------------------------------------------------------------

  property var gridMarkers: beatgrid.gridList //Necessary for the gridMarkers on the waveform & stripe

  BeatGrid {
    id: beatgrid
    deckId: parent.deckId-1 //because is a Traktor Translator, and in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    anchors.fill: parent
    anchors.leftMargin: 3
    anchors.rightMargin: 3
    visible: (!freezeEnabled.value && !beatmatchPracticeMode.value) || beatgrid.editEnabled

    waveformPosition: wfPosition
    sampleWidth: view.sampleWidth
    trackId: primaryKey.value ? primaryKey.value : 0
    editEnabled: false
    clip: true
  }

//--------------------------------------------------------------------------------------------------------------------
// GridMarkers
//--------------------------------------------------------------------------------------------------------------------

  GridMarkers {
    id: waveformGridMarkers
    deckId: parent.deckId
    anchors.fill: parent
    anchors.leftMargin:  3
    anchors.rightMargin: 3

    waveformPosition: wfPosition
    gridMarkers: view.gridMarkers
    visible: displayGridMarkersWF.value
  }

//--------------------------------------------------------------------------------------------------------------------
// CuePoints
//--------------------------------------------------------------------------------------------------------------------

  CuePoints {
    id: waveformCues
    deckId: parent.deckId
    anchors.fill: parent
    anchors.leftMargin:3
    anchors.rightMargin: 3

    waveformPosition: wfPosition
    forceHideLoop: freezeEnabled.value || !isLoaded.value
  }

//--------------------------------------------------------------------------------------------------------------------
// Freeze/Slicer
//--------------------------------------------------------------------------------------------------------------------

  Slicer {
    id: slicer
    deckId: parent.deckId
    anchors.fill: parent
    anchors.leftMargin: 3
    anchors.rightMargin: 3
    anchors.topMargin: 1
    opacity: !beatgrid.editEnabled
  }

//--------------------------------------------------------------------------------------------------------------------
// PlayMarker
//--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    id: play_marker
    followTarget: wfPosition
    pos: 0
    relativeToPlayhead: true
    visible: isLoaded.value ? true : false //if we use .value only --> Traktor logs the unable to assign undefined to bool error

    Rectangle {
        property int sliceModeHeight: stemView.value == StemStyle.track ? waveformContainer.height - 14 : waveformContainer.height - 10

        y: -1
        width: 3
        height: (freezeEnabled.value && !beatgrid.editEnabled ) ? sliceModeHeight : waveformContainer.height + 2
        color: theme.value < 4 ? colors.playmarker : "white"
        border.color: colors.colorBlack31
        border.width: 1
    }
  }

  //Flux PlayMarker
  Traktor.WaveformTranslator {
    followTarget: wfPosition
    pos: 0
    relativeToPlayhead: true
    followFluxPosition: true

    Rectangle {
        id: flux_marker
        x: 0
        y: 0
        width: 3
        height: view.height
        color: colors.orange //colors.playmarker_flux
        border.color: colors.colorBlack31
        border.width: 1
        visible: fluxState.value == 2 // flux mode enabled & fluxing)
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// LoopSize Overlay
//--------------------------------------------------------------------------------------------------------------------

  Widgets.LoopSizeIndicator {
    id: loopSizeOverlay
    anchors.fill: parent
    visible: false //showLoopSize.value
  }

}
