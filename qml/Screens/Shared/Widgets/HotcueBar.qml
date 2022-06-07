import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../Defines'

Item {
  id: hotcueBar
  property int deckId: 1

  MappingProperty { id: displayNumbersHotcuePanel; path: "mapping.settings.displayNumbersHotcuePanel" }

  property var letters: ["A", "B", "C", "D", "E", "F", "G", "H"]

  Row {
    id: row
    anchors.fill: parent
    spacing: 1

    Repeater {
        model: 8
        Rectangle {
            width: (hotcueBar.width - 7*row.spacing)/8
            height: hotcueBar.height
            color: type.value != -1 && exists.value && exists.value > 0 ? (colors.hotcueColor(index+1, type.value, exists.value, hotcueColors.value)) : colors.colorBgEmpty

            AppProperty { id: exists;  path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".exists" }
            AppProperty { id: name;	path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".name" }
            AppProperty { id: type;	path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".type" }

            //Hotcue Bar  (with Index)
            Text {
                id: hotcueIndex
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 2
                visible: displayNumbersHotcuePanel.value

                text: (hotcueColors.value != 0 ? letters[index] : (index+1)) + "."
                color: type.value != -1 && exists.value && exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128
                font.family: "Pragmatica MediumTT"
                font.pixelSize: fonts.smallFontSize
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: hotcueIndex.right
                anchors.leftMargin: 2
                anchors.right: parent.right
                anchors.rightMargin: 2
                //anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 4
                visible: displayNumbersHotcuePanel.value

                text: (exists.value && exists.value > 0 && name.value != "n.n.") ? name.value : ""
                color: exists.value && exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128
                font.family: "Pragmatica MediumTT"
                font.pixelSize: fonts.smallFontSize
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            //Hotcue Bar (without Index)
            Text {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width - 4
                visible: !displayNumbersHotcuePanel.value

                text: (exists.value && exists.value > 0 && name.value != "n.n.") ? name.value : ""
                color: exists.value && exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128
                font.family: "Pragmatica MediumTT"
                font.pixelSize: fonts.smallFontSize
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    Behavior on height { PropertyAnimation {  duration: durations.deckTransition } }
  }
}
