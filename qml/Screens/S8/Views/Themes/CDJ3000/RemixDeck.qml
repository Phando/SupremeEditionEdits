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
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: 20
    color: brightMode.value ? colors.colorGrey128 : colors.colorFxHeaderBg
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
  }

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER TEXT
//--------------------------------------------------------------------------------------------------------------------

  Item {
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: parent.right

    visible: !warningMessage && !errorMessage

    //Title
    Text {
        id: titleField
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: isLoaded.value ? step_icon.right : parent.right
        anchors.rightMargin: 5

        text: isLoaded.value ? "♪ " + title.value : "Not Loaded."
        color: "white"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Step Icon
    Rectangle {
        id: step_icon
        width: 35
        height: 14
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rec_circle_icon.left
        anchors.rightMargin: 5

        color: "transparent"
        border.width: 1
        border.color: sequencerOn.value ? deckColor : colors.colorGrey72
        radius: 3
        visible: isLoaded.value

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "STEP"
            color: sequencerOn.value ? deckColor : colors.colorGrey72
            font.pixelSize: fonts.miniFontSize
        }

        Behavior on opacity { NumberAnimation { duration: speed } }
    }

    //REC Icon
    Rectangle {
        id: rec_circle_icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rec_string.left
        anchors.rightMargin: 5
        color: sequencerRecOn.value ? colors.red : colors.colorGrey72
        width: 10
        height: width
        radius: 0.5*width
        visible: isLoaded.value
    }

    Text {
        id: rec_string
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 5
        visible: isLoaded.value

        text: "REC"
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
    anchors.bottom: deck_bottom.top
    anchors.bottomMargin: 1
    anchors.left: parent.left
    anchors.leftMargin: 3
    anchors.right: parent.right
    anchors.rightMargin: 3

    spacing: 10

    Repeater {  // this repeater creates the four columns of the remix deck
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
// DECK BOTTOM CONTAINER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_bottom;
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: 50
    color: "transparent" //brightMode.value ? colors.colorGrey128 : colors.colorGrey24
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
// Samples Page Indicator
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: pageField
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.bottom: deck_bottom.bottom
    anchors.bottomMargin: 5
    anchors.left: playerIndicator.right
    anchors.leftMargin: 10
    width: 55
    color: colors.colorGrey24
    border.width: 1
    border.color: colors.colorGrey72
    radius: 3

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        text: "PAGE"
        color: colors.colorGrey128 //"white"
        font.pixelSize: fonts.scale(10)
    }

    Rectangle {
        id: pageIndicator
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.right: parent.right
        anchors.rightMargin: 3
        color: "black" //"transparent"
        radius: 3
        //antialiasing: false

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: remixPage.value+1
            color: colors.colorGrey232 //"white"
            font.pixelSize: fonts.scale (20)
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Quantize Indicator
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: quantizeField
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.bottom: deck_bottom.bottom
    anchors.bottomMargin: 5
    anchors.left: pageField.right
    anchors.leftMargin: 5 //19
    width: 55
    color: colors.colorGrey24
    border.width: 1
    border.color: colors.colorGrey72
    radius: 3
    //visible: remixQuantize.value

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        text: "QUANTIZE"
        color: remixQuantize.value ? colors.red : colors.colorGrey128 //"white"
        font.pixelSize: fonts.scale(10)
    }

    Rectangle {
        id: quantizeIndicator
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.right: parent.right
        anchors.rightMargin: 3
        color: "black" //"transparent"
        radius: 3
        //antialiasing: false

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: remixQuantizeIndex.description
            color: remixQuantize.value ? "white" : colors.colorGrey72
            font.pixelSize: fonts.scale (20)
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Beat Counter
//--------------------------------------------------------------------------------------------------------------------

  Widgets.PioneerRemixBeatCounter {
    id: beatCounter
    deckId: remixDeck.deckId
    anchors.top: deck_bottom.top
    anchors.topMargin: 5
    anchors.horizontalCenter: parent.horizontalCenter
    //anchors.horizontalCenterOffset: -20
    visible: deckSize != "small" && !beatmatchPracticeMode.value

    Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Tempo Percentage
//--------------------------------------------------------------------------------------------------------------------

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

  Item {
    anchors.top: deck_bottom.top
    anchors.bottom: deck_bottom.bottom
    anchors.bottomMargin: 4
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
        text: ((tempoOffset >= 0) ? "+" : "-") + (Math.abs(tempoOffset)).toFixed(2).toString();
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
    color: isMaster ? colors.darkerColor(colors.orange, 0.7) : colors.colorGrey24
    border.width: 1
    border.color: isMaster ? colors.orange : colors.colorGrey72
    visible: !beatmatchPracticeMode.value
    clip: true

    Behavior on visible { NumberAnimation { duration: speed } }

    //BPM String
    Text {
        id: bpmString
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.right: parent.right
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter

        text: isMaster ? "MASTER BPM" : "BPM"
        font.pixelSize: fonts.scale(10)
        font.family: "Pragmatica"
        color: isMaster ? "black" : colors.colorGrey72 //"white"
        //horizontalAlignment: Text.AlignRight
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 3
        anchors.right: parent.right
        anchors.rightMargin: 3
        color: "black"

        Item {
            anchors.fill: parent
            anchors.centerIn: parent

            //Decimal Value
            Text {
                id: bpm_anchor
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 8

                text: getBpmDecimalString()
                font.pixelSize: fonts.scale(18)
                font.family: "Pragmatica"
                color: isMaster ? colors.orange : "white"
                function getBpmDecimalString() {
                    var dec = (stableBpm.value - Math.floor(stableBpm.value.toFixed(2)))*100;
                    var dec = Math.round(dec.toFixed(1));
                    if (dec == 0) return ".0";
                    else return "." + dec
                }
            }

            //Whole Number Value
            Text {
                anchors.bottom: parent.bottom
                anchors.right: bpm_anchor.left
                anchors.rightMargin: 1

                text: Math.floor(stableBpm.value.toFixed(2)).toString()
                font.pixelSize: fonts.scale(24)
                font.family: "Pragmatica"
                color: isMaster ? colors.orange : "white"
            }
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// LoopSizeOverlay
//--------------------------------------------------------------------------------------------------------------------

  Widgets.LoopSizeIndicator {
    id: loopSizeOverlay
    anchors.centerIn: parent
    visible: deckSize != "small" && showLoopSize.value == true // == true OR ELSE it will show an error message saying unable to assign undefined to bool
  }
}
