import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../Shared/Widgets' as Widgets
import '../../../../Shared/Widgets/Remix' as Remix

Item {
  id: remixDeck
  property int deckId: 1

  readonly property int speed: 40  // Transition speed

//--------------------------------------------------------------------------------------------------------------------
// THEME VARIABLES
//--------------------------------------------------------------------------------------------------------------------

  readonly property int topLeftState: 0
  readonly property int topMiddleState: 29
  readonly property int topRightState: 20

  readonly property int midLeftState: 1
  readonly property int midMiddleState: 28
  readonly property int midRightState: 22

  readonly property int bottomLeftState: 17
  readonly property int bottomMiddleState: 30
  readonly property int bottomRightState: 18

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width // (deckSize == "small") ? deck_header.width-18 : deck_header.width
    height: 50
    color: brightMode.value == true ? "white" : "black"
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
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.right: isLoaded.value ? top_middle_text.left : parent.right
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232

        explicitName: isLoaded.value ? "" : "No Samples Loaded"
        textState: topLeftState
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Top Middle Container
    Widgets.HeaderField {
        id: top_middle_text
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: quant_circle_icon.left
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232

        explicitName: ""
        maxTextWidth: 65 //80 - 15 (circle width + anchors)
        textState: topMiddleState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }
    Rectangle {
        id: quant_circle_icon
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: top_right_text.left
        anchors.rightMargin: 5
        color: remixQuantize.value ? colors.cyan : colors.colorGrey72
        width: 10
        height: width
        radius: 0.5*width
        visible: !warningMessage && !errorMessage
    }

    // Top Right Container
    Widgets.HeaderField {
        id: top_right_text
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232

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
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: isLoaded.value ? mid_middle_text.left : parent.right
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

        explicitName: isLoaded.value ? "" : (showBrowserOnTouch.value ? "Touch the Browse encoder to open the Browser" : "Push the Browse encoder to open the Browser")
        textState: midLeftState
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Middle Mid Container
    Widgets.HeaderField {
        id: mid_middle_text
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: mid_right_text.left
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

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
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

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
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.left: parent.left
        anchors.right: isLoaded.value ? bottom_middle_text.left : parent.right
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72
        visible: true

        explicitName: ""
        maxTextWidth: 120
        textState: bottomLeftState
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Bottom Mid Container
    Widgets.HeaderField {
        id: bottom_middle_text
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.right: bottom_right_text.left
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

        explicitName: ""
        maxTextWidth: 80
        textState: bottomMiddleState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Bottom Right Container
    Widgets.HeaderField {
        id: bottom_right_text
        deckId: remixDeck.deckId
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.right: parent.right
        anchors.rightMargin: 5
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

        explicitName: ""
        maxTextWidth: 80
        textState: bottomRightState
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Step Icon
    Rectangle {
        id: step_icon
        width: 35
        height: 14
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5

        color: "transparent"
        border.width: 1
        border.color: sequencerOn.value ? deckColor : colors.colorGrey72
        radius: 3
        visible: isLoaded.value

        Text {
            x: 5;
            y: 1;
            text: "STEP"
            color: sequencerOn.value ? deckColor : colors.colorGrey72
            font.pixelSize: fonts.miniFontSize
        }

        Behavior on opacity { NumberAnimation { duration: speed } }
    }

    //REC Icon
    Rectangle {
        id: rec_circle_icon
        anchors.top: parent.top
        anchors.topMargin: 37
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 5
        color: sequencerRecOn.value ? colors.red : colors.colorGrey72
        width: 10
        height: width
        radius: 0.5*width
        visible: isLoaded.value
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.left: rec_circle_icon.right
        anchors.leftMargin: 5
        visible: isLoaded.value

        text: "REC";
        color: sequencerRecOn.value ? colors.colorWhite : colors.colorGrey72
        font.pixelSize: fonts.miniFontSize
    }
  }
//--------------------------------------------------------------------------------------------------------------------
// REMIX SLOTS
//--------------------------------------------------------------------------------------------------------------------

  Row {
    id: remixSlotsContainer
    anchors.top: deck_header.bottom
    anchors.topMargin: 1
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 3
    anchors.right: parent.right
    anchors.rightMargin: 3

    spacing: 10

    Repeater { //this repeater creates the four columns of the remix deck
        id: remixSlots
        model: 4

        Remix.Slot {
            deckId: remixDeck.deckId
            slotId: index+1
            height: parent.height
            width: (remixDeck.width-10*3-3*2)/4
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// LoopSizeOverlay
//--------------------------------------------------------------------------------------------------------------------

  Widgets.LoopSizeIndicator {
    id: loopSizeOverlay
    anchors.centerIn: parent
    visible: deckSize != "small" && showLoopSize.value
  }
}
