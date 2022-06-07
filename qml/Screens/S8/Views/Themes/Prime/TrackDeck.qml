import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../../Defines'
import '../../../../Shared/Widgets' as Widgets
import '../../../../Shared/Widgets/Waveform' as WF
import '../../../../Shared/Widgets/Stripe' as Stripe

Item {
  id: trackDeck
  property int deckId: 1
  readonly property int speed: 40  // Transition speed

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: 40
    color: brightMode.value ? colors.colorGrey128 : colors.colorFxHeaderBg
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  //Artwork
  Widgets.ArtworkBox {
    id: artwork_box
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: deck_header.left
    width: deck_header.height
  }

  //Warning Overlay
  Widgets.DeckHeaderMessage {
    id: warning_box
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: topLeftCorner.value == 0 ? parent.left : artwork_box.right
    anchors.right: deck_header.right

    permanentMessage: true
    shortMessageHasBackground: true
  }

  //Bottom line
  Rectangle {
    id: deck_header_line;
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: deck_header.bottom
    width: parent.width
    height: 3
    color: deckColor
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER CONTENT
//--------------------------------------------------------------------------------------------------------------------

  Item {
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: topLeftCorner.value == 0 ? parent.left : artwork_box.right
    anchors.leftMargin: 5
    anchors.right: parent.right

    visible: !warningMessage && !errorMessage

    //Title
    Text {
        id: titleField
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.right: originalBPMField.left
        anchors.rightMargin: 5

        text: title.value
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Artist
    Text {
        id: artistField
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: originalBPMField.left
        anchors.rightMargin: 5

        text: artist.value
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Stem Icon
    Rectangle {
        id: stem_icon
        width: 35
        height: 14
        y: 5
        x: titleField.x + titleField.paintedWidth + 5

        color: "transparent"
        border.width: 1
        border.color: deckColor
        radius: 3

        visible: deckType.value == DeckType.Stem && isLoaded.value

        Text {
            anchors.fill: parent
            anchors.topMargin: 1
            text: "STEM";
            color: deckColor
            font.pixelSize: fonts.miniFontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Behavior on opacity { NumberAnimation { duration: speed } }
    }

    //BPM
    Text {
        id: originalBPMField
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: key_box.left
        anchors.rightMargin: 5
        width: 60

        text: isLoaded.value ? trackBpm.value.toFixed(0) : "-"
        color: isLoaded.value ? "white" : colors.colorGrey72
        font.family: "Pragmatica" // is monospaced
        font.pixelSize: fonts.scale(20)
        horizontalAlignment: Text.AlignRight
    }

    // Key
    Widgets.KeyBox {
        id: key_box

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 60
        visible: isLoaded.value

        color: "transparent"
        adjustColor: "white"

        keyFontSize: 20
        resultingKeyFontSize: 17
        keyAdjustFontSize: 12

        keyUnderliner: true
        originalKeyWhenDisabled: true
        showRoundedWhenNotInRange: true
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Quantize
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 10
    width: 68
    height: 20
    radius: 2
    color: quantize.value ? colors.greenActive : colors.colorGrey72
    visible: deckSize != "small"
    Behavior on visible { NumberAnimation { duration: speed } }

    Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "QUANTIZE"
      font.pixelSize: fonts.smallFontSize
      color: "black"
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Continue
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: continueRectangle
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 88
    width: 68
    height: 20
    radius: 2
    color: fluxEnabled.value ? colors.greenActive : colors.colorGrey72
    visible: deckSize != "small"
    Behavior on visible { NumberAnimation { duration: speed } }

    Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "CONTINUE"
      font.pixelSize: fonts.smallFontSize
      color: "black"
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Phase Meter & Beat Counter
//--------------------------------------------------------------------------------------------------------------------

  //Phase Meter
  Widgets.PhaseMeter {
    id: phaseSyncBar;
    deckId: parent.deckId
    width: parent.width*(2/5)
    height: 20
    radius: 2

    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 1
  }

  //Beat Counter
  Widgets.BeatCounter {
    id: beatCounter
    deckId: trackDeck.deckId
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 2

    Behavior on visible { NumberAnimation { duration: speed } }
  }


//--------------------------------------------------------------------------------------------------------------------
// Sync Icon
//--------------------------------------------------------------------------------------------------------------------

  // Sync Icon
  Image {
    id: syncIcon
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 38
    anchors.left: parent.left
    anchors.leftMargin: 345
    height: 22
    width: 22
    visible: false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source: isSyncEnabled.value ? "../../../../Shared/Images/synchedPrime.png" : "../../../../Shared/Images/syncPrime.png"
    fillMode: Image.PreserveAspectFit
    antialiasing: true
  }
  ColorOverlay {
    id: syncIconColorOverlay
    anchors.fill: syncIcon
    color: isSyncEnabled.value ? colors.greenActive : colors.colorGrey72
    visible: deckSize != "small"
    source: syncIcon
  }

//--------------------------------------------------------------------------------------------------------------------
// BPM
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: bpmField
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 15
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 90
    height: 20
    color: "transparent"
    visible: deckSize != "small" && !beatmatchPracticeMode.value
    Behavior on visible { NumberAnimation { duration: speed } }

    //Decimal Value
    Text {
        id: bpm_anchor
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        text: isLoaded.value ? getBpmDecimalString() : ""
        font.pixelSize: fonts.scale(27)
        font.family: "Pragmatica"
        color: colors.colorGrey72
        function getBpmDecimalString() {
            var dec = (stableBpm.value - Math.floor(stableBpm.value.toFixed(1)))*100;
            var dec = Math.round(dec.toFixed(1));
            if (dec == 0) return "0";
            else return dec
        }
    }

    //Whole Number Value
    Text {
        anchors.bottom: parent.bottom
        anchors.right: bpm_anchor.left
        anchors.rightMargin:  1

        text: isLoaded.value ? Math.floor(stableBpm.value.toFixed(1)).toString() : "-"
        font.pixelSize: fonts.scale(30)
        font.family: "Pragmatica"
        color: isLoaded.value ? colors.colorGrey232 : colors.colorGrey72
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Size Indicator
//--------------------------------------------------------------------------------------------------------------------

  //Prime Style Loop
  Rectangle {
    id: alt_loop_size
    anchors.top:   deck_header_line.bottom
    anchors.topMargin: 38
    anchors.left:  parent.left
    anchors.leftMargin: 10
    width: 80
    height: 20
    color: "transparent"
    visible: deckSize != "small"
    clip: true

    Image {
      id: loop_arrow
      anchors.top: parent.top
      anchors.left: parent.left
      width: 34
      height: 20
      source: "../../../../Shared/Images/loopPrime.png"
      fillMode: Image.PreserveAspectFit
      visible: false
      antialiasing: true
    }
    ColorOverlay {
      color: displayActive.value ? (isInActiveLoop.value ? colors.greenActive : colors.colorGrey72) : (loopActive.value ? colors.greenActive : colors.colorGrey72)
      anchors.fill: loop_arrow
      source: loop_arrow
    }
    Text {
      anchors.top: parent.top
      anchors.topMargin: -1
      anchors.left: loop_arrow.right
      anchors.leftMargin: 5
      anchors.right: parent.right
      color: displayActive.value ? (isInActiveLoop.value ? colors.colorGrey232 : colors.colorGrey72) : (loopActive.value ? colors.colorGrey232 : colors.colorGrey72)
      font.pixelSize: fonts.scale(24)
      font.family: "Pragmatica"
      horizontalAlignment: Text.AlignHCenter
      text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
    }
  }

  Text
    {
      id: active_indicator
      font.family:		 "Pragmatica"
      font.pixelSize:	  fonts.middleFontSize
      anchors.left:		parent.left
      anchors.leftMargin:  10
      anchors.top:   	   deck_header_line.bottom
      anchors.topMargin:   38 //92
      height:			  stripe_box.height
      verticalAlignment:   Text.AlignVCenter
      color:			   loopActive.value ? colors.greenActive : colors.colorGrey72
      text:				"ACTIVE"
      visible: 			   displayActive.value && isLoaded.value && deckSize != "small" && ((loopActive.value && !isInActiveLoop.value) || !loopActive.value)//&& !isShifted.value //touch encoder is touched
    }

//--------------------------------------------------------------------------------------------------------------------
// Track Time
//--------------------------------------------------------------------------------------------------------------------

  Widgets.TimeBox {
    id: timeField
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 35
    anchors.horizontalCenter: parent.horizontalCenter
    visible: isLoaded.value && deckSize != "small"

    timeSize: 30
    msSize: 27
  }

//--------------------------------------------------------------------------------------------------------------------
// Tempo Percentage
//--------------------------------------------------------------------------------------------------------------------

  property real tempoOffset: (stableTempo.value - 1)*100;

  Text {
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 38
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 88
    visible: deckSize != "small" && !beatmatchPracticeMode.value

    color: colors.colorGrey72
    text: ((tempoOffset <= 0) ? "" : "+") + (tempoOffset).toFixed(1).toString() + "%";
    font.pixelSize: fonts.scale(20)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform
//--------------------------------------------------------------------------------------------------------------------

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << controllerZoom.value

  WF.WaveformContainer {
    id: waveformContainer
    deckId: trackDeck.deckId
    sampleWidth: (isInEditMode || freezeEnabled.value) ? trackDeck.sampleWidth : trackDeck.sampleWidth*(width/480)

    anchors.top: deck_header_line.bottom
    anchors.topMargin: isInEditMode ? 5 : 70
    anchors.bottom: stripe_box.top
    anchors.bottomMargin: 1
    anchors.left: parent.left
    anchors.leftMargin: (isInEditMode || freezeEnabled.value) ? 0 : (-1+waveformOffset.value/50)*parent.width
    anchors.right: parent.right
    visible: isLoaded.value && deckSize != "small"

    Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
  }

  // Stem Color Indicators (Left & Right Rectangles)
  WF.StemIndicators {
    id: stemColorIndicators
    deckId: trackDeck.deckId

    anchors.top: waveformContainer.top
    anchors.bottom: waveformContainer.bottom
    anchors.left: trackDeck.left
    anchors.right: trackDeck.right
    visible: isLoaded.value && deckType.value == DeckType.Stem && stemView.value == StemStyle.daw && deckSize == "large"
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform Stripe
//--------------------------------------------------------------------------------------------------------------------

  Stripe.StripeContainer {
    id: stripe_box

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.rightMargin: 1
    anchors.bottom: panelMode.value == 0 ? parent.bottom : (panelMode.value == 1 ? hotcueBar.top : performancePanel.top)
    anchors.bottomMargin: 1 //isInEditMode ? 28 : 1 //28 is the BeatgridFooter overlay height + 1

    height: 28 //deckSize == "small" ? 40 : 28 //instead of 40, (parent.height-deck_header.height)
    visible: isLoaded.value

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Bottom Performance Panel
//--------------------------------------------------------------------------------------------------------------------

  Widgets.HotcueBar {
    id: hotcueBar
    deckId: trackDeck.deckId
    visible: panelMode.value == 1 && height != 0

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: (deckSize == "large" && isLoaded.value && editMode.value == EditMode.disabled && ((deckType.value == DeckType.Stem && stemView.value == StemStyle.track) || deckType.value == DeckType.Track)) ? 18 : 0
  }

  Widgets.PerformancePanel {
    id: performancePanel
    deckId: trackDeck.deckId
    propertiesPath: screen.propertiesPath
    visible: panelMode.value == 2 && height != 0

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: (deckSize == "large" && isLoaded.value && editMode.value == EditMode.disabled && (activePadsMode.value == PadsMode.hotcues || activePadsMode.value == PadsMode.loop || activePadsMode.value == PadsMode.advancedLoop || activePadsMode.value == PadsMode.loopRoll || activePadsMode.value == PadsMode.effects) && ((deckType.value == DeckType.Stem && stemView.value == StemStyle.track) || deckType.value == DeckType.Track)) ? 30 : 0
  }

//--------------------------------------------------------------------------------------------------------------------
// Empty Deck
//--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------
  Image {
    id: emptyTrackDeckImage
    anchors.top: timeField.bottom
    anchors.topMargin: 15
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 15
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source: "../../../../Shared/Images/Prime.png"
    fillMode: Image.PreserveAspectFit
    antialiasing: true
  }

  // Deck color for empty deck image  ----------------------------------------------------------------------------------
  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    color: colors.colorBgEmpty
    visible: !isLoaded.value && deckSize != "small"
    source: emptyTrackDeckImage
  }

}
