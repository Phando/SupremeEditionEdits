import CSI 1.0
import QtQuick 2.12

CenterOverlay {
  id: quantizeAdjust
  property int deckId: 1

  AppProperty { id: remixQuantizeIndex; path: "app.traktor.decks." + deckId + ".remix.quant_index" }
  AppProperty { id: remixQuantize; path: "app.traktor.decks." + deckId + ".remix.quant" }

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "QUANTIZE"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 47
    font.pixelSize: fonts.superLargeValueFontSize
    font.family: "Pragmatica"
    color: colors.colorWhite
    text: remixQuantize.value ? remixQuantizeIndex.description : "off"
  }
}
