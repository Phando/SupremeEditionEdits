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
    height: 20
    color: brightMode.value == true ? colors.colorGrey128 : colors.darkerColor(colors.pioneerRed, 0.5)
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  //Warning Overlay
  Widgets.DeckHeaderMessage {
    id: warning_box
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: parent.left
    anchors.right: deck_header.right

    permanentMessage: true
    shortMessageHasBackground: true
    showLongMessage: false
  }


//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER CONTENT
//--------------------------------------------------------------------------------------------------------------------

  Item {
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: parent.left //topLeftCorner.value == 0 ? parent.left : artwork_box.right
    anchors.leftMargin: 5
    anchors.right: parent.right

    visible: !warningMessage && !errorMessage

    //Title
    Text {
        id: titleField
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: keyField.left
        anchors.rightMargin: 5

        text: isLoaded.value ? "♪ " + title.value : "Not Loaded."
        color: "white" //brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

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
            x: 3;
            y: 1;
            text: "STEM";
            color: deckColor
            font.pixelSize: fonts.miniFontSize
        }

        Behavior on opacity { NumberAnimation { duration: speed } }
    }

    //Key
    Text {
        id: keyField
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 5
        width: 60
        visible: isLoaded.value

        text: useKeyText.value ? (displayCamelotKey.value ? Key.toCamelot(keyText.value) : keyText.value) : (displayCamelotKey.value ? Key.toCamelot(key.value) : key.value)
        color: "white"
        font.family: "Pragmatica" // is monospaced
        font.pixelSize: fonts.middleFontSize
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
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

    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 1
  }

  //Beat Counter
  Widgets.PioneerBeatCounter {
    id: beatCounter
    deckId: trackDeck.deckId
    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: deckSize != "small" && !beatmatchPracticeMode.value && (phaseWidget.value == 2 || (phaseWidget.value == 3 && masterDeckType.value == DeckType.Remix))

    Behavior on visible { NumberAnimation { duration: speed } }
  }

  //Waveform Widget
  Item {
    id: wavefromPhaseWidget
    anchors.top: deck_header.bottom
    anchors.topMargin: 1
    anchors.bottom: waveformContainer.top
    anchors.left: parent.left
    anchors.right: parent.right
    visible: deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 3 && ((masterDeckType.value == DeckType.Track || masterDeckType.value == DeckType.Stem) || masterId.value == -1)

    WF.WaveformWidget {
        id: masterWaveformContainer
        deckId: masterId.value+1
        deckPropertiesPath: propertiesPath + "." + (masterId.value+1)
        sampleWidth: trackDeck.sampleWidth*(width/480)*trackBpm.value/masterTrackBpm.value

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: (-1+waveformOffset.value/50)*parent.width
        anchors.right: parent.right
        visible: masterId.value != -1 && !isMaster && isLoaded.value && deckSize != "small" && !isInEditMode && !freezeEnabled.value
    }
    LinearGradient {
        id: waveformWidgetBlackRectangle
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 0.8*(waveformOffset.value/100)*parent.width
        start: Qt.point(0, 0)
        end: Qt.point(width, 0)
        gradient: Gradient {
            //orientation: Gradient.Horizontal
            GradientStop { position: 0.85; color: "black" }
            GradientStop { position: 1; color: "transparent" }
        }
    }
    Widgets.WaveformBeatCounter{
        deckId: trackDeck.deckId
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2
        anchors.left: parent.left
        anchors.right: waveformWidgetBlackRectangle.right
        anchors.rightMargin: waveformWidgetBlackRectangle.width*0.2
    }
    Rectangle {
        id: masterPlayerText
        anchors.verticalCenter:parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: 120
        height: parent.height/2
        color: colors.orange
        visible: isMaster

        Text {
              anchors.fill: parent
              anchors.topMargin: 2

              text: "MASTER PLAYER"
              color: "black"
              font.pixelSize:	fonts.scale(14)
              font.family: "Pragmatica"
              verticalAlignment: Text.AlignVCenter
              horizontalAlignment: Text.AlignHCenter
        }
    }
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

    anchors.top: deck_header.bottom
    anchors.topMargin: (isInEditMode || phaseWidget.value == 0) ? 5 : 40
    anchors.bottom: deck_bottom.top
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
// DECK BOTTOM CONTAINER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_bottom;
    anchors.bottom: stripe_box.top
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: 50
    color: "transparent" //brightMode.value == true ? colors.colorGrey128 : colors.colorGrey24
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Player Indicator
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: playerIndicator
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.bottom: deck_bottom.bottom
    anchors.bottomMargin: 5
    anchors.left: parent.left
    anchors.leftMargin: 5
    width: 50
    color: "transparent"
    border.width: 1
    border.color: "white"
    radius: 3
    antialiasing: false

    Text {
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.horizontalCenter: parent.horizontalCenter
        text: "PLAYER"
        color: "white"
        font.pixelSize: fonts.smallFontSize
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.horizontalCenter: parent.horizontalCenter
        text: deckId
        color: "white"
        font.pixelSize: fonts.scale(22)
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// A.Hot Cue / Auto Cue
//--------------------------------------------------------------------------------------------------------------------

  //A.Hot Cue
  Rectangle {
    id: aHotCueRectangle
    anchors.top: deck_bottom.top
    anchors.topMargin: 8
    anchors.left: playerIndicator.right
    anchors.leftMargin: 10
    width: 70
    height: 15
    radius: 1
    color: "transparent"
    border.width: 1
    border.color: colors.red
    visible: true //INFO: Always true because Traktor always loads the current loaded track hotcues.

    Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "A.HOT CUE"
      font.pixelSize: fonts.scale(11)
      color: colors.red
    }
  }

  //Auto Cue
  Rectangle {
    id: autoCueRectangle
    anchors.top: aHotCueRectangle.bottom
    anchors.topMargin: 5
    anchors.left: playerIndicator.right
    anchors.leftMargin: 10
    width: 70
    height: 15
    radius: 1
    color: "transparent"
    border.width: 1
    border.color: colors.red
    visible: false //TO-DO: Read mod setting which refers to automatically playing a track when loaded

    Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "AUTO CUE"
      font.pixelSize: fonts.scale(11)
      color: colors.red
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Remaining Time
//--------------------------------------------------------------------------------------------------------------------

  //Remain String
  Text {
    id: remainString
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.left: parent.left
    anchors.leftMargin: 145
    visible: deckSize != "small"
    color: "white"
    font.pixelSize: fonts.scale(10)
    font.family: "Pragmatica"
    text: "REMAIN"

    Behavior on visible { NumberAnimation { duration: speed } }
  }

  Item {
    id: remainningTimeField
    anchors.bottom: deck_bottom.bottom
    //anchors.bottomMargin: 5
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: -33
    width: 148
    visible: deckSize != "small"
    Behavior on visible { NumberAnimation { duration: speed } }

    //Decimal Value
    Text {
        id: time_anchor
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.right: parent.right
        color: "white"
        font.pixelSize: fonts.scale(22)
        font.family: "Pragmatica"

        function getRemainingTimeDecimalString() {
            var seconds = trackLength.value - elapsedTime.value;
            if (seconds < 0) seconds = 0;

            var ms = Math.floor((seconds % 1) * 1000);
            var msString = ms.toString();

            if (ms < 10) msString = "00" + msString
            else if (ms < 100) msString = "0" + msString
            return "." + msString;
        }
        text: getRemainingTimeDecimalString()
    }
    //Whole Number Value
    Text {
        id: remainWholeString
        anchors.bottom: parent.bottom
        anchors.right: time_anchor.left
        color: "white"
        font.pixelSize: fonts.scale(33)
        font.family: "Pragmatica"

        function getRemainingTimeString() {
            var seconds = trackLength.value - elapsedTime.value;
            if (seconds < 0) seconds = 0;

            var sec = Math.floor(seconds % 60);
            var min = (Math.floor(seconds) - sec) / 60;

            var secStr = sec.toString();
            if (sec < 10) secStr = "0" + secStr;

            var minStr = min.toString();
            if (min < 10) minStr = "0" + minStr;

            return minStr + ":" + secStr;
        }
        text: getRemainingTimeString()
    }
  }

  //Single / Continue String
  Text {
    id: continueString
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.right: remainningTimeField.right
    color: "white"
    font.pixelSize: fonts.scale(10)
    font.family: "Pragmatica"
    text: "SINGLE" //TO-DO: Read Traktor setting which refers to automatically loading next track once the current finishes --> CONTINUE
  }

//--------------------------------------------------------------------------------------------------------------------
// Tempo Percentage
//--------------------------------------------------------------------------------------------------------------------

  //Tempo Master (KeyLock)
  Rectangle {
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.right: syncRectangle.left
    anchors.rightMargin: 5
    width: 30
    height: 15
    radius: 2
    color: "transparent"
    border.width: 1
    border.color: colors.red
    visible: keyLock.value && deckSize != "small"
    Behavior on visible { NumberAnimation { duration: speed } }

    Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "MT"
      font.pixelSize: fonts.smallFontSize
      color: colors.red
    }
  }

  //Sync
  Rectangle {
    id: syncRectangle
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.right: bpmField.left
    anchors.rightMargin: 10
    width: 40
    height: 15
    radius: 2
    color: "white"
    visible: isSyncEnabled.value && deckSize != "small"
    Behavior on visible { NumberAnimation { duration: speed } }

    Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: isSyncEnabled.value ? ((phase >= -0.016 && phase <= 0.016) ? "SYNC" : "PHASE") : "SYNC"
      font.pixelSize: fonts.smallFontSize
      color: "black"
    }
  }

  property real tempoOffset: (stableTempo.value - 1)*100;

  Item {
    anchors.top: deck_bottom.top
    anchors.bottom: deck_bottom.bottom
    anchors.bottomMargin: 2
    anchors.right: bpmField.left
    anchors.rightMargin: 10
    width: 100

    Text {
        id: tempoPercentage
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: "%"
        color: "white"
        font.pixelSize: fonts.scale(14)
    }
    Text {
        anchors.bottom: parent.bottom
        anchors.right: tempoPercentage.left
        anchors.rightMargin: 1
        width: 88
        visible: deckSize != "small" && !beatmatchPracticeMode.value

        color: "white" //utils.colorRangeTempo(tempoOffset) //colors.colorGrey72
        text: tempoOffset > 99.995 ? ((tempoOffset >= 0) ? "+" : "-") + (Math.abs(tempoOffset)).toFixed(1).toString() : ((tempoOffset >= 0) ? "+" : "-") + (Math.abs(tempoOffset)).toFixed(2).toString()
        font.pixelSize: fonts.scale(24)
        font.family: "Pragmatica"
        horizontalAlignment: Text.AlignRight
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// BPM
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: bpmField
    anchors.top: deck_bottom.top
    anchors.bottom: deck_bottom.bottom
    anchors.topMargin: 5
    anchors.bottomMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 82
    radius: 3
    color: "transparent"
    border.width: 1
    border.color: isMaster ? colors.orange : "white"
    visible: !beatmatchPracticeMode.value
    clip: true

    Behavior on visible { NumberAnimation { duration: speed } }

    //Decimal Value
    Text {
        id: bpm_anchor
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 3

        text: getBpmDecimalString()
        font.pixelSize: fonts.scale(24)
        font.family: "Pragmatica"
        color: isMaster ? colors.orange : "white"
        function getBpmDecimalString() {
            var dec = (stableBpm.value - Math.floor(stableBpm.value.toFixed(2)))*100;
            var dec = parseInt((dec/10).toFixed(1));
            return "." + dec
        }
    }

    //Whole Number Value
    Text {
        anchors.top: parent.top
        anchors.right: bpm_anchor.left
        anchors.rightMargin: 1

        text: Math.floor(stableBpm.value.toFixed(2)).toString()
        font.pixelSize: fonts.scale(30)
        font.family: "Pragmatica"
        color: isMaster ? colors.orange : "white"
    }

    //BPM String
    Text {
        id: bpmString
        anchors.top: parent.top
        anchors.topMargin: 28
        anchors.right: parent.right
        anchors.rightMargin: 3

        text: "BPM"
        font.pixelSize: fonts.scale(10)
        font.family: "Pragmatica"
        color: "white"
        visible: !isMaster
        //horizontalAlignment: Text.AlignRight
    }

    //Master String
    Rectangle {
        id: masterField
        anchors.bottom:	parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 12
        color: colors.orange
        visible: isMaster
        radius: 3

        Text {
            id: masterString
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: "MASTER"
            font.pixelSize: fonts.scale(10)
            font.family: "Pragmatica"
            color: "black"
            //horizontalAlignment: Text.AlignRight
        }
    }
    Rectangle {
        id: masterRectangleRadiusFix
        anchors.top: masterField.top
        anchors.left: parent.left
        height: 3
        width: 3
        color: colors.orange
        visible: isMaster
    }
    Rectangle {
        id: masterRectangleRightRadiusFix
        anchors.top: masterField.top
        anchors.right: parent.right
        height: 3
        width: 3
        color: colors.orange
        visible: isMaster
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Quantize Indicator
//--------------------------------------------------------------------------------------------------------------------

  Item {
    id: quantizeField
    anchors.top: stripe_box.top
    anchors.bottom: stripe_box.bottom
    anchors.left: parent.left
    anchors.leftMargin: 5
    width: 50
    //visible: quantize.value

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        text: "QUANTIZE"
        color: quantize.value ? colors.red : colors.colorGrey72 //"white"
        font.pixelSize: fonts.scale(10)
    }

    Rectangle {
        id: quantizeIndicator
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"
        border.width: 1
        border.color: quantize.value ? colors.red : colors.colorGrey72
        radius: 3
        //antialiasing: false

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:   Text.AlignVCenter
            text: "1"
            color: quantize.value ? colors.red : colors.colorGrey72
            font.pixelSize: fonts.smallFontSize
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform Stripe
//--------------------------------------------------------------------------------------------------------------------

  Stripe.StripeContainer {
    id: stripe_box

    anchors.left: quantizeField.right
    anchors.right: loopField.left
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1 //isInEditMode ? 28 : 1 //28 is the BeatgridFooter overlay height + 1
    anchors.rightMargin: 5

    height: 38 //deckSize == "small" ? 40 : 28 //instead of 40, (parent.height-deck_header.height)
    visible: isLoaded.value

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Size Indicator
//--------------------------------------------------------------------------------------------------------------------

  Item {
    id: loopField
    anchors.top: stripe_box.top
    anchors.bottom: stripe_box.bottom
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 50
    //visible: deckSize != "small"

    Image {
        id: loop_arrow
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: loopString.left
        width: 20
        height: 9
        source: "../../../../Shared/Images/loopNexus.png"
        fillMode: Image.PreserveAspectFit
        visible: false
    }
    ColorOverlay {
        color: isInActiveLoop.value ? (fluxEnabled.value ? colors.cyan : colors.orange) : colors.colorGrey72
        anchors.fill: loop_arrow
        source: loop_arrow
    }

    Text {
        id: loopString
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.right: parent.right
        text: fluxEnabled.value ? "SLIP" : "LOOP"
        color: loopActive.value ? (fluxEnabled.value ? colors.cyan : colors.orange) : colors.colorGrey72
        font.pixelSize: fonts.scale(10)
      }

    Rectangle {
        id: loop_size_indicator
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        radius: 3
        color: "transparent"
        border.width: 1
        border.color: loopActive.value ? (fluxEnabled.value ? colors.cyan : colors.orange) : colors.colorGrey72

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: loopActive.value ? (fluxEnabled.value ? colors.cyan : colors.orange) : colors.colorGrey72
            font.pixelSize: fonts.scale(18)
            font.family: "Pragmatica"
            text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Empty Deck
//--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------
  Image {
    id: emptyTrackDeckImage
    anchors.top: deck_header.bottom
    anchors.topMargin: 40 //15 + tempoMeterheight
    anchors.bottom: deck_bottom.top
    anchors.bottomMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source: "../../../../Shared/Images/Pioneer.png"
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
