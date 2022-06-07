import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../../Defines'
import '../../../../Shared/Widgets' as Widgets
import '../../../../Shared/Widgets/Remix' as Remix

Item {
  id: remixDeck
  property int deckId: 1

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

//--------------------------------------------------------------------------------------------------------------------
// STEP ICON
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: step_icon
    width: 35
    height: 14
    anchors.top: deck_header.top
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

//--------------------------------------------------------------------------------------------------------------------
// REC ICON
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: rec_circle_icon
    anchors.top: deck_header.top
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
    anchors.top: deck_header.top
    anchors.topMargin: 35
    anchors.left: rec_circle_icon.right
    anchors.leftMargin: 5
    visible: isLoaded.value

    text: "REC";
    color: sequencerRecOn.value ? colors.colorWhite : colors.colorGrey72
    font.pixelSize: fonts.miniFontSize
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

        Slot {
            deckId: remixDeck.deckId
            slotId: index+1
            deckSettingsPath: remixDeck.deckSettingsPath
            deckPropertiesPath: remixDeck.deckPropertiesPath
            remixDeckPropertyPath: remixDeck.remixDeckPropertyPath
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
    visible: showLoopSize.value
  }
}
