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
        anchors.right: isLoaded.value ? keyField.left : bpmField.left
        anchors.rightMargin: 5

        text: isLoaded.value ? title.value : (deckType.value == DeckType.Track ? "No Track Loaded" : "No Stem Loaded")
        color: brightMode.value ? colors.colorGrey32 : colors.colorGrey232
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    /*
    //Title
    Widgets.ScrollingText {
        id: scrollingTrackName
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.left: topLeftCorner.value == 0 ? parent.left : (topLeftCorner.value == 1 ? cover_small.right : deck_letter_large.right)
        anchors.leftMargin: 5
        anchors.right: isLoaded.value ? keyField.left : bpmField.left
        anchors.rightMargin: 5
        //height: 15
        //width: 60
        textTopMargin: -1
        textFontSize: fonts.middleFontSize
        textColor: brightMode.value ? colors.colorGrey32 : colors.colorGrey232
        containerColor: "transparent"
        marqueeText: isLoaded.value ? title.value : (deckType.value == DeckType.Track ? "No Track Loaded" : "No Stem Loaded")
        doScroll: true
    }
    */

    //Artist
    Text {
        id: artistField
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: isLoaded.value ? keyField.left : bpmField.left
        anchors.rightMargin: 5

        text: isLoaded.value ? artist.value : (showBrowserOnTouch.value ? "Touch the Browse encoder to open the Browser" : "Push the Browse encoder to open the Browser")
        color: brightMode.value ? colors.colorGrey32 : colors.colorGrey72
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

    //Key
    Text {
        id: keyField
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 135
        width: 60
        visible: isLoaded.value

        text: originalKey
        color: keyColor

        font.family: "Pragmatica" // is monospaced
        font.pixelSize: fonts.scale(20)
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }

    //BPM
    Rectangle {
        id: bpmField
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 40
        width: 90
        height: 20
        color: "transparent"
        visible: !beatmatchPracticeMode.value
        Behavior on visible { NumberAnimation { duration: speed } }

        //Decimal Value
        Text {
            id: bpm_anchor
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            text: getBpmDecimalString()
            font.pixelSize: fonts.scale(27)
            font.family: "Pragmatica"
            color: colors.colorGrey72
            function getBpmDecimalString() {
                var dec = (stableBpm.value - Math.floor(stableBpm.value.toFixed(2)))*100;
                var dec = Math.round(dec.toFixed(2));
                if (dec == 0) return "00";
                else if (dec < 10) return "0" + dec;
                else return dec
            }
        }

        //Whole Number Value
        Text {
            anchors.bottom: parent.bottom
            anchors.right: bpm_anchor.left
            anchors.rightMargin:  1

            text: Math.floor(stableBpm.value.toFixed(2)).toString()
            font.pixelSize: fonts.scale(30)
            font.family: "Pragmatica"
            color: colors.colorGrey232
        }
    }

    //FXs Indicators
    Widgets.FXsBox {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5

        onlyTwo: false
        showMixerFX: false
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Master & Sync
//--------------------------------------------------------------------------------------------------------------------

  //Master
  Widgets.MasterBox {
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 10

    width: 68
    height: 20
    radius: 4
    visible: isLoaded.value && deckSize != "small"
  }

  //Sync
  Widgets.SyncBox {
    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 88

    width: 68
    height: 20
    radius: 4
    visible: isLoaded.value && deckSize != "small"

    masterIndicator: true
    phaseIndicator: true
    phaseIndicatorOnlyWhileRunning: true
    phaseLabel: true
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
    visible: isLoaded.value && deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 1
  }

  //Beat Counter
  Widgets.BeatCounter {
    id: beatCounter
    deckId: trackDeck.deckId
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: isLoaded.value && deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 2

    Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Tempo Percentage
//--------------------------------------------------------------------------------------------------------------------

  property real tempoOffset: (stableTempo.value - 1)*100;

  Text {
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 10
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 88
    visible: isLoaded.value && deckSize != "small" && !beatmatchPracticeMode.value

    color: utils.colorRangeTempo(tempoOffset) //colors.colorGrey72
    text: ((tempoOffset <= 0) ? "" : "+") + (tempoOffset).toFixed(1).toString() + "%";
    font.pixelSize: fonts.scale(20)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    Behavior on visible { NumberAnimation { duration: speed } }
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
    anchors.leftMargin: 7
    width: 82
    height: 20
    color: "transparent"
    visible: isLoaded.value && deckSize != "small" && (displayActive.value ? (loopActive.value && isInActiveLoop.value) : true)
//	clip: true

    Image {
      id: loop_arrow
      anchors.top: parent.top
      anchors.topMargin: -11
      anchors.left: parent.left
      anchors.leftMargin: -4
      width: 42
      height: 42
      source: "../../../../Shared/Images/LoopArrow_Icon.png" // "../../../../Shared/Images/LoopArrow_Icon.svg"
      fillMode: Image.PreserveAspectFit
      visible: false
    }
    ColorOverlay {
      color: fluxEnabled.value ? colors.orange : (displayActive.value ? (isInActiveLoop.value ? colors.greenActive : colors.colorGrey72) : (loopActive.value ? colors.greenActive : colors.colorGrey72))
      anchors.fill: loop_arrow
      source: loop_arrow
    }
    Text {
      anchors.top: parent.top
      anchors.topMargin: -1
      anchors.right: parent.right
      width: 50
      color: displayActive.value ? (isInActiveLoop.value ? colors.colorGrey232 : colors.colorGrey72) : (loopActive.value ? colors.colorGrey232 : colors.colorGrey72)
      font.pixelSize: fonts.scale(24)
      font.family: "Pragmatica"
      horizontalAlignment: Text.AlignHCenter
      text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
    }
  }

  Text {
    id: active_indicator
    anchors.left: parent.left
    anchors.leftMargin: 10
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 38 //92
    height: stripe_box.height
    visible: displayActive.value && isLoaded.value && deckSize != "small" && ((loopActive.value && !isInActiveLoop.value) || !loopActive.value)//&& !screen.shift //touch encoder is touched

    text: "ACTIVE"
    color: loopActive.value ? colors.greenActive : colors.colorGrey72
    font.family: "Pragmatica"
    font.pixelSize: fonts.middleFontSize
    verticalAlignment:   Text.AlignVCenter
  }

//--------------------------------------------------------------------------------------------------------------------
// Mixer FX Rectangle Indicator
//--------------------------------------------------------------------------------------------------------------------

  Text {
    id: mixerfx_indicator
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 38
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 40
    color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72
    visible: isLoaded.value && deckSize != "small"

    text: mixerFXLabels[mixerFX.value]
    font.family: "Pragmatica MediumTT"
    font.pixelSize: fonts.smallFontSize + 1
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter

    Behavior on visible { NumberAnimation { duration: speed } }
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
// Waveform
//--------------------------------------------------------------------------------------------------------------------

  readonly property int minSampleWidth: 0x800
  readonly property int sampleWidth: minSampleWidth << controllerZoom.value

  WF.WaveformContainer {
    id: waveformContainer
    deckId: trackDeck.deckId
    sampleWidth: (isInEditMode || freezeEnabled.value) ? trackDeck.sampleWidth : trackDeck.sampleWidth*(width/480)

    anchors.top: deck_header_line.bottom
    anchors.topMargin: isInEditMode ? 5 : 65
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
    anchors.right: key_box.left
    anchors.rightMargin: 1
    anchors.bottom: panelMode.value == 0 ? parent.bottom : (panelMode.value == 1 ? hotcueBar.top : performancePanel.top)
    anchors.bottomMargin: 1 //isInEditMode ? 28 : 1 //28 is the BeatgridFooter overlay height + 1

    height: 28 //deckSize == "small" ? 40 : 28 //instead of 40, (parent.height-deck_header.height)
    visible: isLoaded.value

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  // KeyLock on Stripe
  Widgets.KeyBox {
    id: key_box

    anchors.right: parent.right
    anchors.top: stripe_box.top
    anchors.bottom: stripe_box.bottom
    width: 40
    visible: isLoaded.value
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
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 15
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 15
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source: "../../../../Shared/Images/EmptyDeck.png"
    fillMode: Image.PreserveAspectFit
  }

  // Deck color for empty deck image  ----------------------------------------------------------------------------------
  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    color: colors.colorBgEmpty
    visible: (!isLoaded.value && deckSize != "small")
    source: emptyTrackDeckImage
  }

}
