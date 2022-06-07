import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../Shared/Widgets' as Widgets

Item {
  anchors.fill: parent
  property int deckId: 1

  //Preferences Properties
  MappingProperty { id: brightMode; path: "mapping.settings.brightMode" }
  MappingProperty { id: topLeftCorner; path: "mapping.settings.topLeftCorner" }

  MappingProperty { id: padsFXMode;	path: "mapping.settings.preferences_padsFXMode" }

  //Values read from Traktor Settings
  MappingProperty { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1" }
  MappingProperty { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2" }
  MappingProperty { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3" }
  MappingProperty { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4" }

  AppProperty { id: clockBpm; path: "app.traktor.masterclock.tempo" }

  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }
  AppProperty { id: fx1Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.1" }
  AppProperty { id: fx2Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.2" }
  AppProperty { id: fx3Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.3" }
  AppProperty { id: fx4Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.4" }
  AppProperty { id: mixerFX; path: "app.traktor.mixer.channels." + deckId + ".fx.select" }
  AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + deckId + ".fx.on" }

  property color deckColor: colors.colorBgEmpty
  readonly property variant textColors: [colors.brightBlue, colors.brightBlue, colors.colorGrey232, colors.colorGrey232]
  readonly property int speed: 40  // Transition speed

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER CONTAINER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width // (deckSize == "small") ? deck_header.width-18 : deck_header.width
    height: 50
    color: brightMode.value == true ? "white" : "black"
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Deck Letter (A, B, C or D)
//--------------------------------------------------------------------------------------------------------------------

  Image {
    id: deck_letter_large
    anchors.top: deck_header.top
    anchors.left: parent.left
    anchors.topMargin: 2
    anchors.leftMargin: 5
    width: 36
    height: 46
    visible: false //to set the visibility of the Deck Letter, modify the visibility of the Color Overlay
    clip: true
    fillMode: Image.Stretch
    source: "../../../../Shared/Images/Deck_" + deckLetter + ".png"
    Behavior on height { NumberAnimation { duration: speed } }
    Behavior on opacity { NumberAnimation { duration: speed } }
  }

  ColorOverlay {
    id: deck_letter_color_overlay
    color: deckColor
    visible: topLeftCorner.value == 2
    anchors.fill: deck_letter_large
    source: deck_letter_large
  }


//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER TEXT
//--------------------------------------------------------------------------------------------------------------------

  // Deck Type
  Text {
    id: top_left_text
    anchors.top: deck_header.top
    anchors.left: topLeftCorner.value == 2 ? deck_letter_large.right : parent.left
    anchors.topMargin: 2
    anchors.leftMargin: 5
    color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232

    text: "Live Input"
    elide: Text.ElideRight
    font.pixelSize: fonts.middleFontSize

    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

  // Description
  Text {
    id: mid_left_text
    anchors.top: deck_header.top
    anchors.left: topLeftCorner.value == 2 ? deck_letter_large.right : parent.left
    anchors.topMargin: 20
    anchors.leftMargin: 5
    color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

    text: "Audio processed in Traktor (Gain, Equalizers & Effects)"
    elide: Text.ElideRight
    font.pixelSize: fonts.smallFontSize

    Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

  //Clock BPM
  Text {
    id: top_right_text
    anchors.top: deck_header.top
    anchors.right: parent.right
    anchors.topMargin: 2
    anchors.rightMargin: 50
    color: colors.cyan

    text: "Clock"
    font.pixelSize: fonts.middleFontSize

    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

  //Clock BPM Value
  Text {
    id: mid_right_text
    anchors.top: deck_header.top
    anchors.right: parent.right
    anchors.topMargin: 18
    anchors.rightMargin: 50
    color: colors.cyan

    text: clockBpm.value.toFixed(2)
    font.pixelSize: fonts.smallFontSize + 1

    Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
    Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// FX Indicators
//--------------------------------------------------------------------------------------------------------------------

  //FX 1&3
  Rectangle {
    anchors.top: parent.top
    anchors.topMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 21
    width: 14
    height:	14
    radius:	1
    color: (screen.shift && fxMode.value == FxMode.FourFxUnits) ? (fx3Enabled.value ? colors.orange : colors.colorGrey72) : (fx1Enabled.value ? colors.orange : colors.colorGrey72)

    //Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: (screen.shift && fxMode.value == FxMode.FourFxUnits) ? "3" : "1"
        font.pixelSize: fonts.scale(11)
        color: "black"
    }
  }

  //FX 2&4
  Rectangle {
    anchors.top: parent.top
    anchors.topMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5
    width: 14
    height: 14
    radius:	1
    color: (screen.shift && fxMode.value == FxMode.FourFxUnits) ? (fx4Enabled.value ? colors.orange : colors.colorGrey72) : (fx2Enabled.value ? colors.orange : colors.colorGrey72)

    //Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: (screen.shift && fxMode.value == FxMode.FourFxUnits) ? "4" : "2"
        font.pixelSize: fonts.scale(11)
        color: "black"
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Mixer FX Rectangle Indicator
//--------------------------------------------------------------------------------------------------------------------

  readonly property variant mxrFXLabels: ["FLTR", "RVRB", "DLDL", "NOISE", "TIMG", "FLNG", "BRPL", "DTDL", "CRSH"]
  readonly property variant mxrFXNames: ["Filter", "Reverb", "Dual Delay", "Noise", "Time Gater", "Flanger", "Barber Pole", "Dotted Delay", "Crush"]
  property variant mixerFXNames: [mxrFXNames[0], mxrFXNames[mixerFXAssigned1.value], mxrFXNames[mixerFXAssigned2.value], mxrFXNames[mixerFXAssigned3.value], mxrFXNames[mixerFXAssigned4.value] ] // do not change FLTR
  property variant mixerFXLabels: [mxrFXLabels[0], mxrFXLabels[mixerFXAssigned1.value], mxrFXLabels[mixerFXAssigned2.value], mxrFXLabels[mixerFXAssigned3.value], mxrFXLabels[mixerFXAssigned4.value] ] // do not change FLTR

  Text {
    id: mixerfx_indicator
    anchors.top: parent.top
    anchors.topMargin: 18
    anchors.right: parent.right
    anchors.rightMargin: 5
    color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72

    text: mixerFXLabels[mixerFX.value]
    font.family: "Pragmatica MediumTT"
    font.pixelSize: fonts.smallFontSize + 1
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter

    Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Bottom Performance Panel
//--------------------------------------------------------------------------------------------------------------------

  Widgets.PerformancePanel {
    id: performancePanel
    deckId: parent.deckId
    propertiesPath: screen.propertiesPath
    visible: padsFXMode.value && padsMode.value == PadsMode.effects ? true : false // OR ELSE error in Traktor log...

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: (padsFXMode.value && padsMode.value == PadsMode.effects) ? 30 : 0
  }

//--------------------------------------------------------------------------------------------------------------------
// EMPTY IMAGE
//--------------------------------------------------------------------------------------------------------------------

  // Image filler
  Image {
    id: emptyLiveImage
    anchors.top: deck_header.bottom
    anchors.topMargin: 15
    anchors.bottom: performancePanel.top //parent.bottom
    anchors.bottomMargin: 15
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false // visibility is handled by emptyTrackDeckImageColorOverlay
    source: "../../../../Shared/Images/Microphone.png"
    fillMode: Image.PreserveAspectFit
  }
  ColorOverlay {
    id: emptyLiveImageColorOverlay
    anchors.fill: emptyLiveImage
    color: deckColor
    source: emptyLiveImage
  }
}
