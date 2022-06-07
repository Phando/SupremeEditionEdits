import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import '../../../../Defines'

import '..' as Widgets

Traktor.Stripe {
  id: stripe
  property int deckId: 1
  property var gridMarkers
  property int windowSampleWidth: 122880

  //Preferences Properties
  MappingProperty { id: brightMode; path: "mapping.settings.brightMode" }
  MappingProperty { id: theme; path: "mapping.settings.theme" }
  MappingProperty { id: waveformOffset; path: "mapping.settings.waveformOffset" }
  MappingProperty { id: displayDarkenerPlayed; path: "mapping.settings.displayDarkenerPlayed" }
  MappingProperty { id: displayGridMarkersStripe; path: "mapping.settings.displayGridMarkersStripe" }
  MappingProperty { id: displayMinuteMarkersStripe; path: "mapping.settings.displayMinuteMarkersStripe" }
  MappingProperty { id: waveformColor; path: "mapping.settings.waveformColor" }

//--------------------------------------------------------------------------------------------------------------------
// Track Properties
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: activePos; path: "app.traktor.decks." + trackDeck.deckId + ".track.cue.active.start_pos" }
  AppProperty { id: aciveLength; path: "app.traktor.decks." + trackDeck.deckId + ".track.cue.active.length" }
  AppProperty { id: fluxPosition; path: "app.traktor.decks." + trackDeck.deckId + ".track.player.flux_position" }
  AppProperty { id: fluxState; path: "app.traktor.decks." + trackDeck.deckId + ".flux.state" }
  AppProperty { id: trackBPM; path: "app.traktor.decks." + trackDeck.deckId + ".tempo.base_bpm" }
  AppProperty { id: propTrackSampleLength; path: "app.traktor.decks." + trackDeck.deckId + ".track.content.sample_count" }
  AppProperty { id: trackLength; path: "app.traktor.decks." + trackDeck.deckId + ".track.content.track_length" }
  AppProperty { id: elapsedTime; path: "app.traktor.decks." + trackDeck.deckId + ".track.player.elapsed_time" }
  AppProperty { id: trackEndWarning; path: "app.traktor.decks." + trackDeck.deckId + ".track.track_end_warning" }
  AppProperty { id: sampleRate; path: "app.traktor.decks." + trackDeck.deckId + ".track.content.sample_rate" }

  function sampleToStripe(sampleValue) {
    return sampleValue/trackLength.value * stripe.width
  }

  readonly property int speed: 834 //900 was the original, but after testing, 835 is the most similar value to the timer in Traktor Pro // blink speed
  readonly property real warningOpacity: 0.45
  readonly property int indicatorBoxWidth: (windowSampleWidth / Math.max(1, propTrackSampleLength.value)) * width
  readonly property var waveformColors: colors.getDefaultWaveformColors(waveformColor.value)

  colorMatrix.high1: waveformColors.high1
  colorMatrix.high2: waveformColors.high2
  colorMatrix.mid1: waveformColors.mid1
  colorMatrix.mid2: waveformColors.mid2
  colorMatrix.low1: waveformColors.low1
  colorMatrix.low2: waveformColors.low2
  colorMatrix.background: theme.value < 4 ? (brightMode.value == true ? colors.colorGrey128 : colors.colorBgEmpty) : "transparent"

//--------------------------------------------------------------------------------------------------------------------
// Stripe
//--------------------------------------------------------------------------------------------------------------------

  //Track Played Darken Overlay
  Rectangle {
    id: darkenAlreadyPlayedBox

    anchors.top: parent.top
    anchors.left: parent.left
    height: parent.height
    width: Math.max(Math.min(elapsedTime.value / trackLength.value, 1), 0) * parent.width
    visible: displayDarkenerPlayed.value

    radius: 1
    color: colors.colorBlack66
  }

  //Track End Warning Red Overlay
  Rectangle {
    id: trackEndWarningOverlay
    anchors.top: posIndicatorBox.top
    anchors.bottom: posIndicatorBox.bottom
    anchors.left: parent.left
    anchors.right: posIndicatorBox.horizontalCenter
    anchors.topMargin: 2
    anchors.bottomMargin: 2
    anchors.rightMargin: 2

    color: colors.red
    opacity: 0 // initial state
    visible: (trackEndWarning.value) ? true : false

    Timer {
        id: timer
        property bool  blinker: false

        interval: speed
        repeat: true
        running: trackEndWarning.value

        onTriggered: {
            trackEndWarningOverlay.opacity = (blinker) ? warningOpacity : 0;
            blinker = !blinker;
        }

        onRunningChanged: {
            blinker = running
        }
    }
  }

  //Grid Markers
  Repeater {
    id: grids
    model: gridMarkers.length ? gridMarkers.length : 0
    Widgets.GridMarker {
        property int roundedX: sampleToStripe(gridMarkers[index]/sampleRate.value) // ensures that the flags are drawn "on the pixel"

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        showHead: deckSize != "small" ? true : false
        smallHead: false
        x: roundedX
        visible: displayGridMarkersStripe.value
    }
  }

  //Hotcues
  Repeater {
    id: hotcues
    model: 8
    Widgets.Hotcue {
        AppProperty { id: pos;	path: "app.traktor.decks." + trackDeck.deckId + ".track.cue.hotcues." + (index + 1) + ".start_pos" }
        AppProperty { id: length; path: "app.traktor.decks." + trackDeck.deckId + ".track.cue.hotcues." + (index+1) + ".length" }
        deckId: stripe.deckId+1
        hotcueId: index + 1
        hotcueLength: sampleToStripe(length.value)
        showHead: deckSize != "small" ? true : false;
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        x: sampleToStripe(pos.value)
        opacity: editMode.value != EditMode.full ? 1 : 0
    }
  }

  //Active Cue Triangles
  Widgets.ActiveCue {
    deckId: stripe.deckId+1
    anchors.bottom: parent.bottom
    height: 8
    width: sampleToStripe(aciveLength.value)
    x: sampleToStripe(activePos.value)
    isSmall: true
    clip: false
  }

  //Position Indicator
  Rectangle {
    id: posIndicatorBox
    property int roundedX: Math.floor((relativePlayPos * (stripe.width))) - (waveformOffset.value/100)*width
    readonly property real relativePlayPos: elapsedTime.value / trackLength.value
    x: roundedX
    anchors.top: parent.top
    height: stripe.height
    width: Math.max (parent.indicatorBoxWidth - (1 - parent.indicatorBoxWidth%2) , 5) //

    radius: 1
    color: "transparent"
    border.color: editMode.value == EditMode.full ? "transparent" : (theme.value < 4 ? "white" : "transparent")
    border.width: 1

    Rectangle {
        id: posIndicatorShadow
        anchors.horizontalCenter: posIndicator.horizontalCenter
        anchors.verticalCenter: posIndicator.verticalCenter
        width: 3
        //height: posIndicator.height + 2
        height: stripe.height + 2
        color: colors.colorBlack50
    }

    Rectangle {
        id: posIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: parent.width*(waveformOffset.value-50)/100
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 2
        anchors.bottomMargin: 2

        color: theme.value < 4 ? colors.playmarker : "white"
        width: 1
    }
  }

  //Flux Position Indicator
  Rectangle {
    id: fluxPosIndicator
    property int roundedX: fluxPosIndicator.relativePlayPos * (stripe.width - 1)
    readonly property real relativePlayPos: fluxPosition.value / trackLength.value

    anchors.top: parent.top
    anchors.topMargin: 2

    height: stripe.height
    width: 1
    x: roundedX

    antialiasing:			 false
    visible: fluxState.value == 2
    color: colors.orange //colors.playmarker_flux

    Rectangle {
        id: fluxPosIndicatorShadow
        anchors.horizontalCenter: fluxPosIndicator.horizontalCenter
        anchors.verticalCenter: fluxPosIndicator.verticalCenter
        width: 3
        //height: fluxPosIndicator.height + 2
        height: stripe.height + 2
        color: colors.colorBlack50
    }
  }

  //Edit Mode - Visible Beats
  MappingProperty { id: editMode; path: propertiesPath + ".edit_mode" }
  MappingProperty { id: editPosition; path: propertiesPath + ".beatgrid.position" }
  Rectangle {
    id: editVisibleBeatsBox
    property int roundedX: sampleToStripe(editPosition.value/sampleRate.value)
    x: roundedX
    anchors.top: parent.top
    height: stripe.height
    width: 4*(stripe.width/(trackLength.value/60*trackBPM.value))

    radius: 1
    color: "transparent"
    border.color: colors.orange
    border.width: 1
    visible: editMode.value == EditMode.full
  }

  //Minute Markers on stripe
  Repeater {
    id: minuteMarkers
    model: Math.floor(trackLength.value / 60)
    Rectangle {
        visible: displayMinuteMarkersStripe.value
        anchors.bottom:  parent.bottom
        x: sampleToStripe(60*(index + 1))
        width: 1
        height: stripe.height
        color: colors.colorWhite
    }
  }
}
