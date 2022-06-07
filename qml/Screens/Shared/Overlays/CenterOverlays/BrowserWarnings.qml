import CSI 1.0
import QtQuick 2.12

CenterOverlay {
  id: browserWarning
  property int  deckId

  AppProperty { id: warningMessage;	  path: "app.traktor.informer.deck_loading_warnings." + deckId + ".long"  }
  AppProperty { id: warningMessageShort; path: "app.traktor.informer.deck_loading_warnings." + deckId + ".short" }

  Item {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width
    height: headline.height + text.paintedHeight + text.anchors.topMargin

    //Overlay Headline
    Text {
        id: headline
        width: parent.width - 20
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: fonts.largeFontSize
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        color: colors.orange
        text: warningMessageShort.value
        font.capitalization: Font.AllUppercase
    }

    //Content
    Text {
        id: text
        width: parent.width - 20
        anchors.top: headline.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 4
        font.pixelSize: fonts.middleFontSize
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        color: colors.orange
        text: warningMessage.value
    }
  }
}
