import CSI 1.0
import QtQuick 2.12

import '../Widgets' as Widgets

 Item {
  id: fxInfoDetails

  property AppProperty parameter //set from outside
  property bool isOn: false
  property string label: "DRUMLOOP"
  property string buttonLabel: "HP ON"
  property bool fxEnabled: false
  property bool indicatorEnabled: fxEnabled && label.length > 0
  property string finalValue: fxEnabled ? parameter.description : ""
  property string finalLabel: fxEnabled ? label : ""
  property string finalButtonLabel: fxEnabled ? buttonLabel : ""
  property color barBgColor //set from outside

  readonly property int macroEffectChar:  0x00B6
  readonly property bool isMacroFx: (finalLabel.charCodeAt(0) == macroEffectChar)

  width: 120
  height: 51

  // Level indicator for knobs
  Widgets.ProgressBar {
    id: slider

    anchors.top: parent.top
    anchors.topMargin: 3
    anchors.left: parent.left
    anchors.leftMargin: 3
    progressBarHeight: 9
    progressBarWidth: parent.width-6

    value: parameter.value
    visible: !(parameter.valueRange.isDiscrete && fxEnabled)

    drawAsEnabled: indicatorEnabled
    progressBarColorIndicatorLevel: colors.colorIndicatorLevelOrange
    progressBarBackgroundColor:	 parent.barBgColor
  }

  // stepped progress bar
  Widgets.StateBar {
    id: slider2
    anchors.top: parent.top
    anchors.topMargin:  3
    anchors.left: parent.left
    anchors.leftMargin: 3
    height: 9
    width: parent.width-6

    stateCount: parameter.valueRange.steps
    currentState: (parameter.valueRange.steps - 1.0 + 0.2) * parameter.value // +.2 to make sure we round in the right direction
    visible: parameter.valueRange.isDiscrete && fxEnabled && label.length > 0
    barBgColor: parent.barBgColor
  }

  //Diverse Elements
  Item {
    id: fxInfoDetailsPanel

    height: 100
    width: parent.width

    Rectangle {
        id: macroIconDetails
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.topMargin: 35

        width: 12
        height: 11
        radius: 1
        visible: isMacroFx
        color: colors.colorGrey216

        Text {
            anchors.fill: parent
            anchors.bottomMargin: -1
            anchors.leftMargin: 1
            text: "M"
            font.pixelSize: fonts.miniFontSize
            color: colors.colorBlack
        }
    }

    //FX Name
    Text {
        id: fxInfoSampleName
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: isMacroFx ? 24 : 3
        anchors.right: parent.right
        anchors.rightMargin: 3

        text: isMacroFx? finalLabel.substr(1) : finalLabel
        color: colors.colorIndicatorLevelOrange
        font.pixelSize: fonts.miniFontSize
        font.capitalization: Font.AllUppercase
        elide: Text.ElideRight
    }

    //FX Parameter Value
    Text {
        id: fxInfoValueLarge
        anchors.top: parent.top
        anchors.topMargin: 20 //18 + 2 to compensat button's vertical alignment
        anchors.left: parent.left
        anchors.leftMargin: 3
        visible: label.length > 0

        text: finalValue
        color: colors.colorWhite
        font.family: "Pragmatica" // is monospaced
        font.pixelSize: fonts.smallFontSize
    }

    //Button
    Rectangle {
        id: fxInfoFilterButton
        anchors.top: parent.top
        anchors.topMargin: 18
        anchors.right: parent.right
        anchors.rightMargin: 3
        height: parent.width*0.20
        width: parent.width*0.35
        color: (fxEnabled ? (isOn ? colors.colorIndicatorLevelOrange : colors.colorBlack) : "transparent")
        visible: buttonLabel.length > 0
        radius: 1

        Text {
            id: fxInfoFilterButtonText
            font.capitalization: Font.AllUppercase
            text: finalButtonLabel
            color: ( fxEnabled ? (isOn ? colors.colorBlack : colors.colorGrey128) : colors.colorGrey128 )
            font.pixelSize: fonts.miniFontSize
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
  }
}