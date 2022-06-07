import CSI 1.0
import QtQuick 2.12



CenterOverlay {
  id: mixerfx
  property int deckId: 1

  

  AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + deckId + ".fx.on" }
  AppProperty { id: mixerFX; path: "app.traktor.mixer.channels." + deckId + ".fx.select" }

  MappingProperty { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1" }
  MappingProperty { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2" }
  MappingProperty { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3" }
  MappingProperty { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4" }

  readonly property variant mxrFXLabels: ["FLTR", "RVRB", "DLDL", "NOISE", "TIMG", "FLNG", "BRPL", "DTDL", "CRSH"]
  readonly property variant mxrFXNames: ["Filter", "Reverb", "Dual Delay", "Noise", "Time Gater", "Flanger", "Barber Pole", "Dotted Delay", "Crush"]
  property variant mixerFXNames: [mxrFXNames[0], mxrFXNames[mixerFXAssigned1.value], mxrFXNames[mixerFXAssigned2.value], mxrFXNames[mixerFXAssigned3.value], mxrFXNames[mixerFXAssigned4.value] ] // do not change FLTR
  property variant mixerFXLabels: [mxrFXLabels[0], mxrFXLabels[mixerFXAssigned1.value], mxrFXLabels[mixerFXAssigned2.value], mxrFXLabels[mixerFXAssigned3.value], mxrFXLabels[mixerFXAssigned4.value] ] // do not change FLTR

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "MIXER FX " + deckLetters[deckId]
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 55
    font.pixelSize: fonts.extraLargeValueFontSize
    font.family: "Pragmatica"
    color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey40
    text: mixerFXNames[mixerFX.value]
  }

  //Footline
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 24.0
    font.pixelSize: fonts.smallFontSize
    color: colors.colorGrey72
    text: "Push BROWSE to set " + mixerFXNames[mixerFX.value] + " on all decks"
  }

  //Footline 2
    Item {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 8.0
    width: footline2hold.paintedWidth + footline2back.paintedWidth + footline2reset.paintedWidth + footline2value.paintedWidth
    visible: mixerFX.value != 0

    Text {
        id: footline2hold
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "Press "
    }
    Text {
        id: footline2back
        anchors.bottom: parent.bottom
        anchors.left: footline2hold.right
        font.pixelSize: fonts.smallFontSize
        color: colors.orange
        text: "BACK "
    }
    Text {
        id: footline2reset
        anchors.bottom: parent.bottom
        anchors.left: footline2back.right
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "to reset to "
    }
    Text {
        id: footline2value
        anchors.bottom: parent.bottom
        anchors.left: footline2reset.right
        font.pixelSize: fonts.smallFontSize
        color: colors.lightOrange
        text: "FILTER"
    }
  }
}