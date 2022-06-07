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
// THEME VARIABLES
//--------------------------------------------------------------------------------------------------------------------

  readonly property int topLeftState: preferences.topLeftState
  readonly property int topMiddleState:	preferences.topMiddleState
  readonly property int topRightState: preferences.topRightState

  readonly property int midLeftState: preferences.midLeftState
  readonly property int midMiddleState: preferences.midMiddleState
  readonly property int midRightState: preferences.midRightState

  readonly property int bottomLeftState: preferences.bottomLeftState
  readonly property int bottomMiddleState: preferences.bottomMiddleState
  readonly property int bottomRightState: preferences.bottomRightState

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: 50
    color: colors.background
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

    // Title - Top Left Container
    Widgets.HeaderField {
        id: top_left_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.right: isLoaded.value ? top_middle_text.left : parent.right
        anchors.rightMargin: 5
        color: colors.text

        explicitName: isLoaded.value ? "" : (deckType.value == DeckType.Stem ? "No Stem loaded" : "No Track loaded")
        textState: topLeftState
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Top Middle Container
    Widgets.HeaderField {
        id: top_middle_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: top_right_text.left
        anchors.rightMargin: 5
        color: colors.text

        explicitName: ""
        textState: topMiddleState
        maxTextWidth: 80
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Top Right Container
    Widgets.HeaderField {
        id: top_right_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: colors.text

        explicitName: ""
        maxTextWidth: 80
        textState: topRightState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Artist - Mid Left Container
    Widgets.HeaderField {
        id: mid_left_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: isLoaded.value ? mid_middle_text.left : parent.right
        anchors.rightMargin: 5
        color: colors.darkText

        explicitName: isLoaded.value ? "" : (showBrowserOnTouch.value ? "Touch" : "Push")  + " the Browse encoder to open the Browser"
        textState: midLeftState
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Middle Mid Container
    Widgets.HeaderField {
        id: mid_middle_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: mid_right_text.left
        anchors.rightMargin: 5
        color: colors.darkText

        explicitName: ""
        maxTextWidth: 80
        textState: midMiddleState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Middle Right Container
    Widgets.HeaderField {
        id: mid_right_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: colors.darkText

        explicitName: ""
        maxTextWidth: 80
        textState: midRightState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Bottom Left Container
    Widgets.HeaderField {
        id: bottom_left_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.left: parent.left
        anchors.right: isLoaded.value ? bottom_middle_text.left : parent.right
        anchors.rightMargin: 5
        color: colors.darkText

        explicitName: ""
        textState: bottomLeftState
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Bottom Mid Container
    Widgets.HeaderField {
        id: bottom_middle_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.right: bottom_right_text.left
        anchors.rightMargin: 5
        color: colors.darkText

        explicitName: ""
        maxTextWidth: 80
        textState:  bottomMiddleState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Bottom Right Container
    Widgets.HeaderField {
        id: bottom_right_text
        deckId: trackDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: colors.darkText

        explicitName: ""
        maxTextWidth: 80
        textState: bottomRightState
        horizontalAlignment: Text.AlignRight
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
        x: top_left_text.x + top_left_text.paintedWidth + 5

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
  }


//--------------------------------------------------------------------------------------------------------------------
// Master & Sync
//--------------------------------------------------------------------------------------------------------------------

  //Sync
  Widgets.SyncBox {
    id: sync_box

    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 1

    width: 68
    height: 20
    visible: isLoaded.value && deckSize != "small"

    phaseIndicator: true
    phaseIndicatorOnlyWhileRunning: true
    phaseIndicatorOkWhilePaused: false

    textColor: colors.colorGrey128
    backgroundColor: colors.colorGrey24

    syncColor: colors.cyan
    phaseColor: backgroundColor
  }

  //Master
  Widgets.MasterBox {
    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.left: parent.left
    anchors.leftMargin: 71

    width: 68
    height: 20
    visible: isLoaded.value && deckSize != "small"

    textColor: colors.colorGrey128
    backgroundColor: colors.colorGrey24

    masterColor: colors.cyan
  }

//--------------------------------------------------------------------------------------------------------------------
// Phase Meter & Beat Counter
//--------------------------------------------------------------------------------------------------------------------

  //Phase Meter
  Widgets.PhaseMeter {
    id: phaseMeter;
    deckId: trackDeck.deckId
    width: parent.width*(2/5)
    height: 20
    radius: 2

    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: isLoaded.value && deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 1
  }

  //Beat Counter
  Widgets.BeatCounter {
    id: beatCounter
    deckId: trackDeck.deckId
    anchors.top: deck_header.bottom
    anchors.topMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    visible: isLoaded.value && deckSize != "small" && !beatmatchPracticeMode.value && phaseWidget.value == 2

    Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Size Indicator
//--------------------------------------------------------------------------------------------------------------------

  Widgets.SpinningLoopSize {
    id: loop_size
    anchors.top: deck_header.bottom
    anchors.topMargin: 5
    anchors.left: parent.left
    anchors.leftMargin: 395
    diamater: 30
    visible: isLoaded.value && deckSize != "small"

    spinOnActive: true
    fluxIndicator: true
  }

//--------------------------------------------------------------------------------------------------------------------
// FX Indicators
//--------------------------------------------------------------------------------------------------------------------

  //FXs Indicators
  Widgets.FXsBox {
      anchors.top: parent.top
      anchors.topMargin: 55
      anchors.right: parent.right
      anchors.rightMargin: 5

      onlyTwo: true
      showMixerFX: true

      visible: isLoaded.value && deckSize != "small"
  }


//--------------------------------------------------------------------------------------------------------------------
// Waveform
//--------------------------------------------------------------------------------------------------------------------

  readonly property int minSampleWidth: 0x800 //2048 in decimal
  readonly property int sampleWidth: minSampleWidth << controllerZoom.value

  WF.WaveformContainer {
    id: waveformContainer
    deckId: trackDeck.deckId
    sampleWidth: (isInEditMode || freezeEnabled.value) ? trackDeck.sampleWidth : trackDeck.sampleWidth*(width/480)

    anchors.top: deck_header.bottom
    anchors.topMargin: isInEditMode ? 5 : 40
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
    height: (deckSize == "large" && isLoaded.value && editMode.value == EditMode.disabled && ((deckType.value == DeckType.Stem && !stemView.value) || deckType.value == DeckType.Track)) ? 18 : 0
  }

  Widgets.PerformancePanel {
    id: performancePanel
    deckId: trackDeck.deckId
    propertiesPath: screen.propertiesPath
    visible: panelMode.value == 2 && height != 0

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: (deckSize == "large" && isLoaded.value && editMode.value == EditMode.disabled && (activePadsMode.value == PadsMode.hotcues || activePadsMode.value == PadsMode.loop || activePadsMode.value == PadsMode.advancedLoop || activePadsMode.value == PadsMode.loopRoll || activePadsMode.value == PadsMode.effects) && ((deckType.value == DeckType.Stem && !stemView.value) || deckType.value == DeckType.Track)) ? 30 : 0
  }

//--------------------------------------------------------------------------------------------------------------------
// Empty Deck
//--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------
  Image {
    id: emptyImage
    anchors.top: deck_header.bottom
    anchors.topMargin: 15
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 15
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source: "../../../../Shared/Images/EmptyDeck.png"
    fillMode: Image.PreserveAspectFit
  }

  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyImage
    source: emptyImage
    color: colors.darkGrey
    visible: (!isLoaded.value && deckSize != "small")
  }

/* TO-DO: DEVELOPER STUFF
  AppProperty { id: gridOffset; path: "app.traktor.decks." + trackDeck.deckId + ".content.grid_offset" }
  property int waveformPos: parseInt((elapsedTime.value*1000-gridOffset.value)*bpm.value/60000) //waveformContainer.waveformX
  property int waveformPos2: parseInt((elapsedTime.value*1000*sampleRate.value/sampleWidth)*wfPosition.view) //waveformContainer.waveformX

  Text {
    anchors.fill: parent
    anchors.topMargin: 1
    horizontalAlignment: Text.AlignHCenter
    text: waveformPos
    font.pixelSize: fonts.smallFontSize
    color: "white"
  }
  Text {
    anchors.fill: parent
    anchors.topMargin: 20
    horizontalAlignment: Text.AlignHCenter
    text: waveformPos2
    font.pixelSize: fonts.smallFontSize
    color: "white"
  }
*/
}
