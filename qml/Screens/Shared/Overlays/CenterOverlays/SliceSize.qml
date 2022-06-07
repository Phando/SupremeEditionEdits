import CSI 1.0
import QtQuick 2.12

CenterOverlay {
  id: sliceSize
  property int  deckId

  AppProperty { id: sliceSizeIndex; path: "app.traktor.decks." + deckId + ".freeze.slice_size_in_measures" }
  property var beatString: (sliceSizeIndex.value > 1) ? "BEATS" : "BEAT"

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "SLICE SIZE"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 53
    font.pixelSize: fonts.extraLargeValueFontSize
    font.family: "Pragmatica"
    color: colors.colorWhite
    text: sliceSizeIndex.value + "  " + beatString
  }
}
