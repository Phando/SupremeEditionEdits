import CSI 1.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import '../../../../../Defines'
import '../../../../Shared/Widgets' as Widgets
import '../../../../Shared/Widgets/Waveform' as WF
import '../../../../Shared/Widgets/Stripe' as Stripe

Item {
  id: trackDeck
  property int deckId: 1

  readonly property int speed: 40 //Transition speed
  property int margins: 5

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: parent.height*0.1375
    color: brightMode.value ? "white" : "black"
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  //Warning Overlay
  Widgets.DeckHeaderMessage {
    id: warning_box
    anchors.fill: deck_header

    permanentMessage: true
    showLongMessage: false
  }


  //Title
  Widgets.ScrollingText {
    id: titleField
    anchors.top: deck_header.top
    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    height: deck_header.height
    width: parent.width - bpmField.width
    textTopMargin: -1
    textFontFamily: "Roboto"
    textFontSize: 24
    textColor: brightMode.value ? colors.colorGrey32 : colors.colorGrey232
    containerColor: "transparent"
    marqueeText: isLoaded.value ? title.value : (deckType.value == DeckType.Track ? "No Track Loaded" : "No Stem Loaded")
    doScroll: true
    visible: !stems.visible && !warning_box.visible
  }

//--------------------------------------------------------------------------------------------------------------------
// BPM
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: bpmField
    anchors.top: deck_header.bottom
    anchors.left: parent.left
    anchors.leftMargin: margins
    height: parent.height*0.1375
    width: (parent.width-margins*3)/2

    color: (isSyncEnabled.value || isMaster) ? colors.darkerColor(colors.cyan, 0.15) : "black" //colors.background
    radius: margins
    border.width: 2
    border.color: isMaster ? colors.cyan : isSyncEnabled.value ? colors.darkerColor(colors.cyan, 0.15) : colors.colorGrey40
    visible: isLoaded.value && !stems.visible

    Text {
        text: stableBpm.value.toFixed(2)
        font.pixelSize: 24
        font.family: "Roboto"
        font.weight: Font.Normal
        color: "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
  }

  function colorForSync(masterId, synched, phase) {
    if ((masterId == -1) && synched) {
        return colors.cyan;
    }
    else if (masterId == deckId && synched) {
        return colors.mint;
    }
    else if (synched) {
        //if (phase == 0.00) { return colors.mint;}
        if (phase >= -0.016 && phase <= 0.016) {
            return colors.greenActive;
        }
        else {
            return colors.red;
        }
    }
    else {
      return colors.colorGrey72;
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Key
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: key_box
    anchors.top: deck_header.bottom
    anchors.right: parent.right
    anchors.rightMargin: margins
    height: parent.height*0.1375
    width: (parent.width-margins*3)/2

    color: keyLock.value ? ( (isLoaded.value && resultingKeyIndex.value != -1 && isKeyInRange) ? colors.darkerColor(keyColor, 0.15 ) : colors.cyan ) : colors.colorGrey40
    radius: margins
    border.width: 2
    border.color: keyLock.value ? ( (isLoaded.value && resultingKeyIndex.value != -1 && isKeyInRange) ? (isKeySynchronized ? keyColor : colors.darkerColor(keyColor, 0.15)) : colors.cyan ) : colors.colorGrey40
    visible: isLoaded.value && !stems.visible

    Text {
      anchors.fill:	parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: (keyLock.value && resultingKeyIndex.value != -1 && isKeyInRange && displayResultingKey.value) ? (useKeyText.value ? (displayCamelotKey.value ? utils.convertKeyTextToResultingCamelot(keyText.value, keyAdjust.value) : utils.convertKeyTextToResultingCamelot(keyText.value, keyAdjust.value)) : (displayCamelotKey.value ? Key.toCamelot(resultingKey.value) : resultingKey.value)) : "♪"
      font.family: "Roboto"
      font.pixelSize: fonts.scale(24)
      color: keyLock.value ? keyColor : "white" //colors.colorGrey128
      visible: !keyLock.value || !isKeyAdjusted || !isKeyInRange || !displayResultingKey.value
    }

    Text {
      anchors.fill:	parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: useKeyText.value ? (displayCamelotKey.value ? utils.convertKeyTextToResultingCamelot(keyText.value, keyAdjust.value) : utils.convertKeyTextToResultingCamelot(keyText.value, keyAdjust.value)) : (displayCamelotKey.value ? Key.toCamelot(resultingKey.value) : resultingKey.value)
      font.family: "Roboto"
      font.pixelSize: 24
      color: keyColor
      visible: keyLock.value && isKeyAdjusted && isKeyInRange && displayResultingKey.value
    }

    Text {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter
      anchors.leftMargin: isKeyInRange ? 30 : 25
      verticalAlignment: Text.AlignVCenter
      text: "(" + (keyAdjust.value*12 < 0 ? "" : "+") + (isKeyInRange ? (keyAdjust.value*12).toFixed(0).toString() : (keyAdjust.value*12).toFixed(2).toString()) + ")"
      font.family: "Roboto"
      font.pixelSize: isKeyInRange ? 17 : 14
      color: keyColor
      visible: keyLock.value && isKeyAdjusted && displayResultingKey.value
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Remainning Time
//--------------------------------------------------------------------------------------------------------------------

  function getRemainingTimeString() {
    var seconds = trackLength.value - elapsedTime.value;
    if (seconds < 0) seconds = 0;

    var sec = Math.floor(seconds % 60);
    var min = (Math.floor(seconds) - sec) / 60;

    var secStr = sec.toString();
    if (sec < 10) secStr = "0" + secStr;

    var minStr = min.toString();
    //if (min < 10) minStr = "0" + minStr;

    return "- " + minStr + ":" + secStr;
  }

  Rectangle {
    id: timeField
    anchors.top: bpmField.bottom
    anchors.topMargin: margins
    anchors.left: parent.left
    anchors.leftMargin: margins
    height: parent.height*0.275
    width: (parent.width-margins*3)/2

    color: trackEndBlinkTimer.blink ? colors.red : colors.colorGrey40
    radius: margins
    border.width: 2
    border.color: trackEndWarning.value ? colors.red : colors.colorGrey40
    visible: isLoaded.value && !stems.visible

    Text {
        text: getRemainingTimeString()
        font.pixelSize: 45
        font.family: "Roboto"
        font.weight: Font.Normal
        color: trackEndBlinkTimer.blink ? "black": "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
  }

  Timer {
    id: trackEndBlinkTimer
    property bool blink: false

    interval: 834 //instead of 500 so that it is synched with the stripe blinker
    repeat: true
    running: trackEndWarning.value

    onTriggered: {
        blink = !blink;
    }

    onRunningChanged: {
        blink = running;
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Size Indicator
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: loopField
    anchors.top: key_box.bottom
    anchors.topMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    height: parent.height*0.275
    width: (parent.width-margins*3)/2

    color:  isInActiveLoop.value ? (fluxEnabled.value ? colors.cyan : (loopActive.value ? colors.green : colors.colorGrey40)) : colors.colorGrey40
    radius: margins
    border.width: 2
    border.color: fluxEnabled.value ? colors.cyan : (loopActive.value ? colors.green : colors.colorGrey40)
    visible: isLoaded.value && !stems.visible

    Text {
        text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
        font.pixelSize: 45
        font.family: "Roboto"
        color: isInActiveLoop.value && (fluxEnabled.value || loopActive.value) ? "black" : "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Phase Meter & Beat Counter
//--------------------------------------------------------------------------------------------------------------------

  //Phase Meter
  Widgets.PhaseMeter {
    id: phaseMeter
    deckId: parent.deckId
    anchors.top: timeField.bottom
    anchors.topMargin: margins
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width-margins*2
    height: parent.height*0.1375
    radius: margins
    visible: isLoaded.value && !beatmatchPracticeMode.value && phaseWidget.value == 1 && !stems.visible
  }

  //Beat Counter
  Widgets.BeatCounterS4 {
    id: beatCounter
    deckId: parent.deckId
    anchors.top: timeField.bottom
    anchors.topMargin: margins
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width-margins*2
    height: parent.height*0.1375
    visible: isLoaded.value && !beatmatchPracticeMode.value && phaseWidget.value == 2 && !stems.visible

    //Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Stem Overlay
//--------------------------------------------------------------------------------------------------------------------

  Widgets.StemParameters {
    id: stems
    anchors.top: parent.top
    anchors.bottom: stripe_box.top
    anchors.bottomMargin: margins
    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    visible: deckType.value == DeckType.Stem && slotState.value && activePadsMode.value == PadsMode.stems
    showFX: true
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform
//--------------------------------------------------------------------------------------------------------------------

  readonly property int minSampleWidth: 0x800 //2048 in decimal
  readonly property int sampleWidth: minSampleWidth << controllerZoom.value

  //INFO: Only necessary for obtainning the gridMarkers array. (Less trouble than adding a Traktor.Beatgrid)
  WF.WaveformContainer {
    id: waveformContainer
    deckId: trackDeck.deckId
    sampleWidth: 0
    anchors.fill: parent
    visible: false
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform Stripe
//--------------------------------------------------------------------------------------------------------------------

  Stripe.StripeContainer {
    id: stripe_box

    anchors.top: phaseWidget.value == 0 ? timeField.bottom : phaseMeter.bottom
    anchors.topMargin: margins
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1 //isInEditMode ? 28 : 1 //28 is the BeatgridFooter overlay height + 1
    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    visible: isLoaded.value

    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Empty Deck
//--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------
  Image {
    id: emptyTrackDeckImage
    anchors.top: deck_header.bottom
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
    visible: !isLoaded.value
    source: emptyTrackDeckImage
  }
}
