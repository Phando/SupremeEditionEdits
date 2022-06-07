import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as T

import '..' as Widgets

Item {
  id: view
  property int deckId: 1
  readonly property int stemCount:  4

  //Left rectangles
  Repeater {
    model: stemCount

    Rectangle {
        property color stemColor: colors.palette(1.0, stemColorId.value)
        AppProperty { id: stemColorId; path: "app.traktor.decks." + deckId + ".stems." + (index + 1) + ".color_id" }
        AppProperty { id: stemName; path: "app.traktor.decks." + deckId + ".stems." + (index + 1) + ".name" }

        anchors.left: parent.left
        y: index * view.height/stemCount
        width: 60
        height: view.height/stemCount
        color: "black"

        Rectangle {
            id: leftStemRectanglesColors
            anchors.top: parent.top
            anchors.left: parent.left
            height: parent.height-1
            width:  4
            color:  stemColor
            border.width: 1
            border.color: "black"
        }
        Rectangle {
            id: leftStemRectanglesInfo
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height-1
            width:  parent.width-leftStemRectanglesColors.width
            color:  colors.colorGrey24
            border.width: 1
            border.color: "black"

            Text {
                id: stemNameString
                anchors.fill: parent
                anchors.leftMargin: 3

                text: stemName.value
                color: colors.colorGrey104
                font.capitalization: Font.AllUppercase
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight

            }
        }
    }
  }

  //Right rectangles
  Repeater {
    model: stemCount

    Rectangle {
        property color stemColor: colors.palette(1.0, stemColorId.value)
        AppProperty { id: stemColorId; path: "app.traktor.decks." + deckId + ".stems." + (index + 1) + ".color_id" }

        anchors.right: parent.right
        y: index * view.height/stemCount
        width: 4
        height: view.height/stemCount
        color: "black"

        Rectangle {
            id: rightStemRectangles
            anchors.fill: parent
            height: parent.height-1
            color:  stemColor
            border.width: 1
            border.color: "black"
        }
    }
  }

}
