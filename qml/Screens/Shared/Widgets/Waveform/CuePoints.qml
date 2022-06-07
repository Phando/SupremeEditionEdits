import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import '..' as Widgets

Item {
  id: view
  property int deckId: 1
  property var waveformPosition
  property bool forceHideLoop

  anchors.fill: parent

  property int cueType: activeCueType.value ? activeCueType.value : 0 //if we use .value only --> Traktor logs the unable to assign undefined to int error
  property int cueStart: activeCueStart.value * sampleRate.value
  property int cueLength: activeCueLength.value * sampleRate.value

  property int  loop_length: samples_to_waveform_x(cueLength)
  property bool is_looping:  (cueType == 5) && (loopActive.value == true)

  // test begin
  property var highOpacity: 1
  property var lowOpacity: 0.25
  property var blinkFreq: 500
  // test end

  MappingProperty { id: theme; path: "mapping.settings.theme" }

  AppProperty { id: sampleRate; path: "app.traktor.decks." + deckId + ".track.content.sample_rate" }
  AppProperty { id: loopActive; path: "app.traktor.decks." + deckId + ".loop.active" }
  AppProperty { id: isInActiveLoop; path: "app.traktor.decks." + deckId + ".loop.is_in_active_loop" }
  AppProperty { id: activeCueType; path: "app.traktor.decks." + deckId + ".track.cue.active.type" }
  AppProperty { id: activeCueStart; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" }
  AppProperty { id: activeCueLength; path: "app.traktor.decks." + deckId + ".track.cue.active.length" }
  AppProperty { id: loopSizePos; path: "app.traktor.decks." + deckId + ".loop.size" }

  function samples_to_waveform_x( sample_pos ) { return (sample_pos / waveformPosition.sampleWidth) * waveformPosition.viewWidth }

//--------------------------------------------------------------------------------------------------------------------
// Hot Cues
//--------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: hotcues
    model: 8

    Traktor.WaveformTranslator {
        AppProperty { id: pos; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".start_pos" }
        AppProperty { id: length; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".length" }

        followTarget: waveformPosition
        pos: pos.value * sampleRate.value // pos in samples

        Widgets.Hotcue {
            deckId: view.deckId
            hotcueId: index + 1
            hotcueLength: samples_to_waveform_x(length.value* sampleRate.value)
            showHead: deckSize != "small"
            smallHead: false

            anchors.topMargin: 3
            height: view.height
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Overlay & Cue Markers
//--------------------------------------------------------------------------------------------------------------------

  readonly property int lineWidthAdjustment: 1 //set to 1 so that it actually overlaps the 1 pixel width of the beatmarkers
  //set to 2 so that it doesn't overlap the beatmarkers and prevent the buzz effect

  Traktor.WaveformTranslator {
    followTarget: waveformPosition
    pos: cueStart
    //visible: !forceHideLoop && (is_looping || theme.value != 1)
    anchors.fill: view

    //Colorize WF Background when Loop Active
    Rectangle {
        id: loopOverlay
        color: theme.value == 1 ? colors.defaultLoopOverlay : (theme.value <= 3 ? (loopActive.value ? colors.loopOverlayBackground_green : colors.colorDarkGreyLoopOverlay) : (theme.value == 4 ? (loopActive.value ? colors.loopOverlayBackground_green : colors.colorLightGreyLoopOverlay) : (loopActive.value ? colors.orangeLoopOverlay : colors.colorLightGreyLoopOverlay)))
        x: 0
        y: theme.value <= 4 ? 0 : view.height*0.05
        height: theme.value <= 4 ? view.height : view.height*0.9
        width: samples_to_waveform_x(cueLength)
    }

    // Active Cue Indicators
    Widgets.ActiveCue {
        id: activeCueIndicators
        deckId: view.deckId
        anchors.bottom: parent.bottom
        height: 8
        width: samples_to_waveform_x(cueLength)
        x: 0
        isSmall: false
        clip: false
        displayRightIndicator: theme.value <= 4
        visible: isLoaded.value && deckSize != "small" ? true : false //if we use .value only --> Traktor logs the unable to assign undefined to bool error
    }

    //Active Cue Loop In Marker
    Rectangle {
        id: loopInMarker
        anchors.left: loopOverlay.left
        height: parent.height
        width: 1
        color: colors.green
        visible: theme.value == 1 && activeCueIndicators.isLoop
    }

    ///Active Cue Loop Out Marker
    Rectangle {
        id: loopOutMarker
        anchors.right: loopOverlay.right
        height: parent.height
        width: 1
        color: colors.green
        visible: theme.value == 1 && activeCueIndicators.isLoop
    }
  }
}
