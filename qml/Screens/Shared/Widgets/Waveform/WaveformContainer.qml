import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor

import '../../../../Defines'
import '..' as Widgets

Item {
  id: view
  property int deckId: 1
  property int sampleWidth: 1

  property int waveformX: wfPosition.waveformPos //WIP in TrackDeck.qml

  MappingProperty { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size" }
  readonly property bool showStems: (deckType.value == DeckType.Stem && stemView.value == StemStyle.daw && deckSize == "large")

  AppProperty { id: sampleRate; path: "app.traktor.decks."  + deckId + ".track.content.sample_rate"; onValueChanged: { updateLooping() } }

  // If the playhead is in a loop, isInActiveLoop is TRUE and the loop becomes the active cue.
  AppProperty { id: isInActiveLoop; path: "app.traktor.decks." + deckId + ".loop.is_in_active_loop"; onValueChanged: { updateLooping() } }
  AppProperty { id: cueStart; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos"; onValueChanged: { updateLooping() } }
  AppProperty { id: cueLength; path: "app.traktor.decks." + deckId + ".track.cue.active.length"; onValueChanged: { updateLooping() } }

//--------------------------------------------------------------------------------------------------------------------
// Waveform Position
//------------------------------------------------------------------------------------------------------------------

  property double freezeZoomWidth: freezeWidth.value * sliceCount.value / slicer.zoom_factor * sampleRate.value
  property double freezePositionInWaveform: (freezeStart.value - (0.5 * freezeWidth.value * slicer.zoom_factor)) * sampleRate.value

  function updateLooping() {
    if (isInActiveLoop.value) {
        var loopStart  = cueStart.value  * sampleRate.value;
        var loopLength = cueLength.value * sampleRate.value;
        wfPosition.clampPlayheadPos(loopStart, loopLength);
    }
    else wfPosition.unclampPlayheadPos();
  }

  Traktor.WaveformPosition {
    id: wfPosition
    deckId: view.deckId-1 //because is a Traktor Translator, and in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    followsPlayhead: !freezeEnabled.value && !beatgrid.editEnabled
    waveformPos: beatgrid.editEnabled ? beatgrid.posOnEdit : (freezeEnabled.value ? freezePositionInWaveform : playheadPos)
    sampleWidth: beatgrid.editEnabled ? beatgrid.widthOnEdit : (freezeEnabled.value ? freezeZoomWidth : view.sampleWidth)
    viewWidth: singleWaveform.width

    Behavior on sampleWidth { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on waveformPos { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic }  enabled: (freezeEnabled.value || beatgrid.editEnabled) }
  }

/*
  Traktor.WaveformPosition {
    id: fluxPosition
    deckId: view.deckId
    waveformPos:	playheadPos - 100
    sampleWidth:	 beatgrid.editEnabled ? beatgrid.widthOnEdit : (freezeEnabled.value ? freezeZoomWidth			: view.sampleWidth)
    viewWidth:		 singleWaveform.width

    //followFluxPosition: true
    //followFluxPosition: true
    //relativeToPlayhead: true
    //pos:				0
    //followTarget:		 wfPosition

    Behavior on sampleWidth { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on waveformPos { PropertyAnimation { duration: 150; easing.type: Easing.OutCubic }  enabled: (freezeEnabled.value || beatgrid.editEnabled) }

  }
*/

//--------------------------------------------------------------------------------------------------------------------
// Waveforms¡
//------------------------------------------------------------------------------------------------------------------

  SingleWaveform {
    id: singleWaveform
    deckId: view.deckId
    sampleWidth: view.sampleWidth
    waveformPosition: wfPosition
    waveformColors: dynamicWF.value ? dynamicWaveformColorsMap[waveformColor.value] : colors.getDefaultWaveformColors(waveformColor.value)

    anchors.fill: view
    anchors.leftMargin: 3
    anchors.rightMargin: 3

    clip: true
    visible: !showStems
    height: view.height

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //Stems
  Stems {
    id: stemWaveform
    deckId: view.deckId
    sampleWidth: view.sampleWidth
    waveformPosition: wfPosition

    anchors.top: singleWaveform.top
    anchors.bottom: singleWaveform.bottom
    anchors.bottomMargin: (showStems & freezeEnabled.value) ? 15 : 0
    anchors.left: view.left
    anchors.leftMargin: 4
    anchors.right: view.right
    anchors.rightMargin: 4

    visible: showStems
  }

//--------------------------------------------------------------------------------------------------------------------
// Beatgrid
//--------------------------------------------------------------------------------------------------------------------

  property var gridMarkers: beatgrid.gridList //Necessary for the gridMarkers on the waveform & stripe

  BeatGrid {
    id: beatgrid
    deckId: view.deckId-1 //because is a Traktor Translator, and in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    anchors.fill: parent
    anchors.leftMargin: 3
    anchors.rightMargin: 3
    visible: (!freezeEnabled.value && !beatmatchPracticeMode.value) || beatgrid.editEnabled

    waveformPosition: wfPosition
    sampleWidth: view.sampleWidth
    trackId: primaryKey.value
    clip: true

    editEnabled: isInEditMode && (deckSize != "small")
  }

//--------------------------------------------------------------------------------------------------------------------
// GridMarkers
//--------------------------------------------------------------------------------------------------------------------

  GridMarkers {
    id: gridMarkers
    deckId: view.deckId
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
    deckId: view.deckId
    anchors.fill: parent
    anchors.leftMargin:  3
    anchors.rightMargin: 3

    waveformPosition: wfPosition
    forceHideLoop: freezeEnabled.value || !isLoaded.value
  }

//--------------------------------------------------------------------------------------------------------------------
// Freeze/Slicer
//--------------------------------------------------------------------------------------------------------------------

  Slicer {
    id: slicer
    deckId: view.deckId
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
    visible: isLoaded.value

    Rectangle {
        property int sliceModeHeight: stemView.value == StemStyle.track ? waveformContainer.height - 14 : waveformContainer.height - 10
        //x: -1 //to fix the offset caused by the width
        y: -1
        width: 3
        height: (freezeEnabled.value && !beatgrid.editEnabled ) ? sliceModeHeight : waveformContainer.height + 2
        color: theme.value < 4 ? colors.playmarker : (fluxState.value != 0 ? colors.yellow : (!isPlaying.value && (cuePosition.value != playheadPosition.value) ? colors.red : "white"))
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
    anchors.centerIn: parent
    diamater: parent.height/2
    visible: showLoopSize.value == true && showLoopSizeOverlay.value // == true OR ELSE it will show an error message saying unable to assign undefined to bool
  }

}
