import CSI 1.0
import QtQuick 2.12

import '../Widgets' as Widgets

 Item {
  id: fxInfoDetails

  property AppProperty parameter		 // set from outside
  property bool		isOn:			 false
  property string	  label:			"DRUMLOOP"
  property string	  buttonLabel:	  "HP ON"
  property bool		fxEnabled:		false
  property bool		indicatorEnabled: fxEnabled && label.length > 0
  property string	  finalValue:	   fxEnabled ? parameter.description : ""
  property string	  finalLabel:	   fxEnabled ? label : ""
  property string	  finalButtonLabel: fxEnabled ? buttonLabel : ""
  property color	   barBgColor		// set from outside

  readonly property int macroEffectChar:  0x00B6
  readonly property bool isMacroFx: (finalLabel.charCodeAt(0) == macroEffectChar)

  width:  120
  height: 51

  // Level indicator for knobs
  Widgets.ProgressBar {
    id: slider
    progressBarHeight:  9
    progressBarWidth:   102
    anchors.left:	   parent.left
    anchors.top:		parent.top
    anchors.topMargin:  3
    anchors.leftMargin: 8

    value:			  parameter.value
    visible:			!(parameter.valueRange.isDiscrete && fxEnabled)

    drawAsEnabled:	  indicatorEnabled

    progressBarColorIndicatorLevel: colors.colorIndicatorLevelOrange
    progressBarBackgroundColor:	 parent.barBgColor
  }

  // stepped progress bar
  Widgets.StateBar {
    id: slider2
    height:  9
    width:			  102
    anchors.left:	   parent.left
    anchors.top:		parent.top
    anchors.leftMargin: 8
    anchors.topMargin:  3

    stateCount:   parameter.valueRange.steps
    currentState: (parameter.valueRange.steps - 1.0 + 0.2) * parameter.value // +.2 to make sure we round in the right direction
    visible:	  parameter.valueRange.isDiscrete && fxEnabled && label.length > 0
    barBgColor:   parent.barBgColor
  }

  // Diverse Elements
  Item {
    id: fxInfoDetailsPanel

    height: 100
    width: parent.width

    Rectangle {
      id: macroIconDetails
      anchors.top:		parent.top
      anchors.left:	   parent.left
      anchors.leftMargin: 8
      anchors.topMargin:  50

      width:   12
      height:  11
      radius:  1
      visible: isMacroFx
      color:   colors.colorGrey216

      Text {
        anchors.fill:	   parent
        anchors.bottomMargin:  -1
        anchors.leftMargin: 1
        text:			   "M"
        font.pixelSize:	 fonts.miniFontSize
        color:			  colors.colorBlack
      }
    }

    // fx name
    Text {
      id: fxInfoSampleName
      font.capitalization: Font.AllUppercase
      text:				isMacroFx? finalLabel.substr(1) : finalLabel
      color:			   colors.colorIndicatorLevelOrange //fxInfoDetails.textColor
      anchors.top:		 parent.top
      anchors.bottom:	  parent.bottom
      anchors.left:		parent.left
      anchors.right:	   parent.right
      anchors.topMargin:   48
      font.pixelSize:	  fonts.scale(11)
      anchors.leftMargin:  isMacroFx ? 24 : 8
      anchors.rightMargin: 9
      elide:			   Text.ElideRight
    }

    // value
    Text {
      id: fxInfoValueLarge
      text:			   finalValue
      font.family:		"Pragmatica" // is monospaced
      color:			  colors.colorWhite
      visible:			label.length > 0
      anchors.top:		parent.top
      anchors.left:	   parent.left
      anchors.leftMargin: 8
      font.pixelSize:	 fonts.largeFontSize
      anchors.topMargin:  22
    }

    // button
    Rectangle {
      id: fxInfoFilterButton
      width: 30
      color: ( fxEnabled ? (isOn ? colors.colorIndicatorLevelOrange : colors.colorBlack) : "transparent" )
      visible: buttonLabel.length > 0
      radius: 1
      anchors.right: parent.right
      anchors.rightMargin: 9
      anchors.top: parent.top
      height: 15
      anchors.topMargin: 24


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