import CSI 1.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

StackLayout {
  id: artworkBox

  MappingProperty { id: topLeftCorner; path: "mapping.settings.topLeftCorner" } //INFO: Can't remove or segmentation fault on CDJ-3000 theme?
  currentIndex: topLeftCorner.value-1 //utils.clamp(topLeftCorner.value-1, -1, 2) //INFO: Selects which of the children (in order) is the visible --> -1: None, 0: First item, etc.

  property int albumBorderWidth: 1
  property color albumBorderColor: colors.colorWhite16

//--------------------------------------------------------------------------------------------------------------------
// Cover Art
//--------------------------------------------------------------------------------------------------------------------

  //Album Container
  Rectangle {
    id: album

    color: darkerDeckColor //deck_header.color
    border.width: albumBorderWidth
    border.color: albumBorderColor

    Behavior on width { NumberAnimation { duration: speed } }
    Behavior on height { NumberAnimation { duration: speed } }

    //CD Style image for empty Album Covers
    CD {
        id: empty
        anchors.fill: parent
        anchors.margins: parent.border.width
        cdColor: deckColor
        centerColor: darkerDeckColor
        visible: !artwork.visible
    }

    /*
    //Traktor Style image for empty Album Covers
    TraktorIcon {
        id: empty
        anchors.fill: parent
        anchors.margins: parent.border.width
        fillColor: "white"
    }
    */

    //Album Cover
    Image {
      id: artwork
      source: visible ? "image://covers/" + albumCoverDirectory.value : ""
      anchors.fill: parent
      anchors.margins: parent.border.width
      sourceSize.width: width
      sourceSize.height: height
      fillMode: Image.PreserveAspectCrop
      visible: isLoaded && albumCoverDirectory.value
      Behavior on height { NumberAnimation { duration: speed } }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Deck Letter (A, B, C or D)
//--------------------------------------------------------------------------------------------------------------------

  Text {
    id: deck_letter
    Layout.topMargin: parent.height*0.15 //TODO: not working

    text: deckLetter
    color: deckColor
    font.pixelSize: fonts.scale(parent.height)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on height { NumberAnimation { duration: speed } }
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Deck Index (1, 2, 3 or 4)
//--------------------------------------------------------------------------------------------------------------------

  Text {
    id: deck_index
    Layout.topMargin: parent.height*0.15 //TODO: not working

    text: deckId
    color: "white"
    font.pixelSize: fonts.scale(parent.height)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on height { NumberAnimation { duration: speed } }
    Behavior on opacity { NumberAnimation { duration: speed } }
  }
}