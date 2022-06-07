import CSI 1.0
import QtQuick 2.12

CenterOverlay {
  id: captureSource
  property int deckId: 1

  AppProperty { id: captureSourceIndex; path: "app.traktor.decks." + deckId + ".capture_source" }

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "REMIX CAPTURE SOURCE"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 39
    font.pixelSize: fonts.superLargeValueFontSize
    //font.capitalization: Font.AllUppercase
    color: captureSourceIndex.description == "Loop Rec" ? colors.green : ((captureSourceIndex.value < 2) ? colors.brightBlue : colors.colorWhite)
    text: captureSourceIndex.description
  }

  //Footline
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 24.0
    font.pixelSize: fonts.smallFontSize
    color: colors.colorGrey72
    text: "Note: Only track decks or the Loop Recorder"
  }
  //Footline
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 12.0
    font.pixelSize: fonts.smallFontSize
    color: colors.colorGrey72
    text: "can be selected as capture sources"
  }
}