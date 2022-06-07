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

  readonly property int speed: 40 //Transition speed

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: parent.height*0.09
    color: brightMode.value ? "white" : "black"
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
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

  //Warning Overlay
  Widgets.DeckHeaderMessage {
    id: warning_box
    anchors.fill: deck_header

    permanentMessage: true
    shortMessageHasBackground: true
  }

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER CONTENT
//--------------------------------------------------------------------------------------------------------------------

/*
  //Title
  Text {
    id: titleField
    anchors.top: deck_header.top
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: bpmField.left
    anchors.rightMargin: 5

    text: isLoaded.value ? title.value : (deckType.value == DeckType.Track ? "No Track Loaded" : "No Stem Loaded")
    color: brightMode.value ? colors.colorGrey32 : colors.colorGrey232
    elide: Text.ElideRight
    font.pixelSize: fonts.largeFontSize

    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }
*/

  //Title
  Widgets.ScrollingText {
    id: titleField
    anchors.top: deck_header.top
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: bpmField.left
    anchors.rightMargin: 5
    height: deck_header.height
    width: parent.width - bpmField.width
    textTopMargin: -1
    textFontSize: fonts.largeFontSize
    textColor: brightMode.value ? colors.colorGrey32 : colors.colorGrey232
    containerColor: "transparent"
    marqueeText: isLoaded.value ? title.value : (deckType.value == DeckType.Track ? "No Track Loaded" : "No Stem Loaded")
    doScroll: true
  }

  //BPM
  Text {
    id: bpmField
    anchors.top: deck_header.top
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 60

    text: stableBpm.value.toFixed(2)
    color: colors.colorGrey232
    font.pixelSize: fonts.largeFontSize
    //horizontalAlignment: Text.AlignRight
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
    if (min < 10) minStr = "0" + minStr;

    return "- " + minStr + ":" + secStr;
  }

  Text {
    id: remainingtime
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 3
    //anchors.verticalCenter: phaseMeter.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: phaseMeter.left
    anchors.rightMargin: 5
    height: stripe_box.height
    //visible: isLoaded.value

    color: "white"
    text: getRemainingTimeString()
    font.pixelSize:	fonts.largeFontSize
  }

//--------------------------------------------------------------------------------------------------------------------
// Phase Meter & Beat Counter
//--------------------------------------------------------------------------------------------------------------------

  //Phase Meter
  Widgets.PhaseMeter {
    id: phaseMeter
    deckId: parent.deckId
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 5
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width*(2/5)
    height: parent.height*0.08
    radius: 2
    visible: !beatmatchPracticeMode.value && phaseWidget.value == 1
  }

  //Beat Counter
  Widgets.BeatCounterS4 {
    id: beatCounter
    deckId: trackDeck.deckId
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 5
    anchors.horizontalCenter: parent.horizontalCenter
    height: parent.height*0.08
    width: parent.width*(2/5)
    visible: !beatmatchPracticeMode.value && phaseWidget.value == 2

    //Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Size Indicator
//--------------------------------------------------------------------------------------------------------------------

  //Prime Style Loop
  Item {
    id: alt_loop_size
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 3
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: parent.width*0.25
    height: phaseMeter.height
    visible: displayActive.value ? (loopActive.value && isInActiveLoop.value) : true
    //clip: true

    Image {
        id: loop_arrow
        //anchors.verticalCenter: phaseMeter.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: -8
        anchors.left: parent.left
        width: 38
        height: 38
        source: "../../../../Shared/Images/LoopArrow_Icon.png"
        //source: "../../../../Shared/Images/RemixAssets/Sample_Loop.png.png"
        fillMode: Image.PreserveAspectFit
        visible: false
    }
    ColorOverlay {
        color: displayActive.value ? (isInActiveLoop.value ? colors.greenActive : colors.colorGrey72) : (loopActive.value ? colors.greenActive : colors.colorGrey72)
        anchors.fill: loop_arrow
        source: loop_arrow
    }
    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        width: parent.width-loop_arrow.width
        color: loopActive.value ? colors.colorGrey232 : colors.colorGrey72
        font.pixelSize: fonts.largeFontSize
        horizontalAlignment: Text.AlignHCenter
        text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Stem Overlay
//--------------------------------------------------------------------------------------------------------------------

  Widgets.StemParameters {
    id: stems
    anchors.top: phaseMeter.bottom
    anchors.bottom: stripe_box.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: margins
    visible: deckType.value == DeckType.Stem && slotState.value && activePadsMode.value == PadsMode.stems
    showFX: true
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform
//--------------------------------------------------------------------------------------------------------------------

  readonly property int minSampleWidth: 0x800 //2048 in decimal
  readonly property int sampleWidth: minSampleWidth << controllerZoom.value

  WF.WaveformContainer {
    id: waveformContainer
    deckId: trackDeck.deckId
    sampleWidth: (isInEditMode || freezeEnabled.value) ? trackDeck.sampleWidth : trackDeck.sampleWidth*(width/320)

    anchors.top: deck_header.bottom
    anchors.topMargin: isInEditMode ? 5 : 30
    anchors.bottom: stripe_box.top
    anchors.bottomMargin: 1
    anchors.left: parent.left
    anchors.leftMargin: (isInEditMode || freezeEnabled.value) ? 0 : (-1+waveformOffset.value/50)*parent.width
    anchors.right: parent.right
    visible: isLoaded.value && deckSize != "small" && !stems.visible

    Behavior on height { PropertyAnimation { duration: durations.deckTransition } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Waveform Stripe
//--------------------------------------------------------------------------------------------------------------------

  Stripe.StripeContainer {
    id: stripe_box

    anchors.left: parent.left
    anchors.right: key_box.left
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1 //isInEditMode ? 28 : 1 //28 is the BeatgridFooter overlay height + 1
    anchors.leftMargin: 1
    anchors.rightMargin: 1
    height: parent.height*0.15 //deckSize == "small" ? 40 : 28 //instead of 40, (parent.height-deck_header.height)
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

/*
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
    height: (deckSize == "large" && isLoaded.value && editMode.value == EditMode.disabled && ((deckType.value == DeckType.Stem && stemView.value == StemStyle.track) || deckType.value == DeckType.Track)) ? 30 : 0
  }
*/

//--------------------------------------------------------------------------------------------------------------------
// Empty Deck
//--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------
  Image {
    id: emptyTrackDeckImage
    anchors.top: phaseMeter.bottom
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
