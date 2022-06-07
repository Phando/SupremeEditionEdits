import QtQuick 2.12
import CSI 1.0

CenterOverlay {
  id: swingAdjust
  property int deckId: 1

  AppProperty { id: swing;	path: "app.traktor.decks." + deckId + ".remix.sequencer.swing" }

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "SWING"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 47
    font.pixelSize: fonts.superLargeValueFontSize
    font.family: "Pragmatica"
    color: colors.colorWhite
    text: swing.description
  }
}
