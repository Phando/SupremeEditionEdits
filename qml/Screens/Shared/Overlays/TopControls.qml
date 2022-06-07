import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../Widgets' as Widgets

//--------------------------------------------------------------------------------------------------------------------
//  FX CONTROLS
//--------------------------------------------------------------------------------------------------------------------

// The FxControls are located on the top of the screen and blend in if one of the top knobs is touched/changed

Item {
  id: topLabels
  property string visibleState
  property int fxUnit
  property int yPositionWhenHidden: 0 - topLabels.height - headerBlackLine.height - headerShadow.height // also hides black border & shadow
  property int yPositionWhenShown: 0
  property color barBgColor: colors.orangeDimmed //"black"

  height: 84 // includes darker panel and black border with shadow at the bottom
  anchors.left:  parent.left
  anchors.right: parent.right

  AppProperty { id: singleMode; path: "app.traktor.fx." + fxUnit + ".type" } // singleMode -> fxSelect1.description else "DRY/WET"
  AppProperty { id: fxSelect1; path: "app.traktor.fx." + fxUnit + ".select.1" } // singleMode -> fxKnob1name.value
  AppProperty { id: fxSelect2; path: "app.traktor.fx." + fxUnit + ".select.2" } // singleMode -> fxKnob2name.value
  AppProperty { id: fxSelect3; path: "app.traktor.fx." + fxUnit + ".select.3" } // singleMode -> fxKnob3name.value

  AppProperty { id: fxDryWet; path: "app.traktor.fx." + fxUnit + ".dry_wet" }
  AppProperty { id: fxParam1; path: "app.traktor.fx." + fxUnit + ".parameters.1" }
  AppProperty { id: fxParam2; path: "app.traktor.fx." + fxUnit + ".parameters.2" }
  AppProperty { id: fxParam3; path: "app.traktor.fx." + fxUnit + ".parameters.3" }
  AppProperty { id: fxKnob1name; path: "app.traktor.fx." + fxUnit + ".knobs.1.name" }
  AppProperty { id: fxKnob2name; path: "app.traktor.fx." + fxUnit + ".knobs.2.name" }
  AppProperty { id: fxKnob3name; path: "app.traktor.fx." + fxUnit + ".knobs.3.name" }

  AppProperty { id: fxOn; path: "app.traktor.fx." + fxUnit + ".enabled" }
  AppProperty { id: fxButton1; path: "app.traktor.fx." + fxUnit + ".buttons.1" }
  AppProperty { id: fxButton2; path: "app.traktor.fx." + fxUnit + ".buttons.2" }
  AppProperty { id: fxButton3; path: "app.traktor.fx." + fxUnit + ".buttons.3" }
  AppProperty { id: fxButton1name; path: "app.traktor.fx." + fxUnit + ".buttons.1.name" }
  AppProperty { id: fxButton2name; path: "app.traktor.fx." + fxUnit + ".buttons.2.name" }
  AppProperty { id: fxButton3name; path: "app.traktor.fx." + fxUnit + ".buttons.3.name" }

  //Darker Background
  Rectangle {
    id: topInfoDetailsPanelDarkBg
    anchors {
      top: parent.top
      left:  parent.left
      right: parent.right
    }
    height: topLabels.height
    color: colors.orangeDimmed
  }

  //Headline showing the FX Unit
  Text {
    id: topheadline
    text: "FX " + fxUnit
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3
    color: colors.colorIndicatorLevelOrange
    font.pixelSize: fonts.scale(11)
  }

  // Line dividers
  readonly property int dividerHeight: 60

  Rectangle {
    id: fxInfoDivider0
    width:1;
    height: dividerHeight
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 120
  }

  Rectangle {
    id: fxInfoDivider1
    width:1;
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 240
    height: dividerHeight
  }

  Rectangle {
    id: fxInfoDivider2
    width:1;
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 360
    height: dividerHeight
  }

  // Info Details
  Rectangle {
    id: topInfoDetailsPanel

    height: parent.height
    clip: true
    width: parent.width
    color: "transparent"

    anchors.left: parent.left
    anchors.leftMargin: 1

    Row {
      TopInfoDetails {
        id: topInfoDetails1
        parameter: fxDryWet
        isOn: fxOn.value
        label: singleMode.value ? fxSelect1.description : "DRY/WET"
        buttonLabel: singleMode.value ? "ON" : ""
        fxEnabled: (!singleMode.value) || fxSelect1.value
        barBgColor: barBgColor
      }

      TopInfoDetails {
        id: topInfoDetails2
        parameter: fxParam1
        isOn: fxButton1.value
        label: fxKnob1name.value
        buttonLabel: fxButton1name.value
        fxEnabled: (fxSelect1.value || (singleMode.value && fxSelect1.value) )
        barBgColor: barBgColor
      }

      TopInfoDetails {
        id: topInfoDetails3
        parameter: fxParam2
        isOn: fxButton2.value
        label: fxKnob2name.value
        buttonLabel: fxButton2name.value
        fxEnabled: (fxSelect2.value || (singleMode.value && fxSelect1.value) )
        barBgColor: barBgColor
      }

      TopInfoDetails {
        id: topInfoDetails4
        parameter: fxParam3
        isOn: fxButton3.value
        label: fxKnob3name.value
        buttonLabel: fxButton3name.value
        fxEnabled: (fxSelect3.value || (singleMode.value && fxSelect1.value) )
        barBgColor: barBgColor
      }
    }
  }

  // Black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.top: topLabels.bottom
    width:	   parent.width
    color:	   colors.colorIndicatorLevelOrange //colors.colorBlack
    height:	  1
  }
  Rectangle {
    id: headerShadow
    anchors.left:  parent.left
    anchors.right: parent.right
    anchors.top:   headerBlackLine.bottom
    height:		6
    gradient: Gradient {
      GradientStop { position: 1.0; color: colors.colorBlack0 }
      GradientStop { position: 0.0; color: colors.colorBlack63 }
    }
    visible: false
  }

//----------------------------------------------------------------------------------------------------------------------
// FX Indicators
//----------------------------------------------------------------------------------------------------------------------

  AppProperty { id: fxOnA;	 path: "app.traktor.mixer.channels.1.fx.assign." + fxUnit }
  AppProperty { id: fxOnB;	 path: "app.traktor.mixer.channels.2.fx.assign." + fxUnit }
  AppProperty { id: fxOnC;	 path: "app.traktor.mixer.channels.3.fx.assign." + fxUnit }
  AppProperty { id: fxOnD;	 path: "app.traktor.mixer.channels.4.fx.assign." + fxUnit }

  Rectangle {
    id: fxOnAdisplay
    width: 15
    height: 15
    radius: 3

    color: fxOnA.value ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2-13*3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

    Text {
        text: "A"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: fxOnA.value == 1 ? colors.colorBlack : colors.colorGrey88
        font.pixelSize: fonts.scale(11)
    }
  }

  Rectangle {
    id: fxOnBdisplay
    width: 15
    height: 15
    radius: 3

    color: fxOnB.value ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.right: parent.right
    anchors.rightMargin: (parent.width/2) -13*3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

    Text {
        text: "B"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: fxOnB.value == 1 ? colors.colorBlack : colors.colorGrey88
        font.pixelSize: fonts.scale(11)
    }
  }

  Rectangle {
    id: fxOnCdisplay
    width: 15
    height: 15
    radius: 3

    color: fxOnC.value ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2-13*5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

    Text {
        text: "C"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: fxOnC.value == 1 ? colors.colorBlack : colors.colorGrey88
        font.pixelSize: fonts.scale(11)
    }
  }

  Rectangle {
    id: fxOnDdisplay
    width: 15
    height: 15
    radius: 3

    color: fxOnD.value ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.right: parent.right
    anchors.rightMargin: parent.width/2-13*5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

    Text {
        text: "D"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: fxOnD.value == 1 ? colors.colorBlack : colors.colorGrey88
        font.pixelSize: fonts.scale(11)
    }
  }

//------------------------------------------------------------------------------------------------------------------
//  TOP PANEL STATES
//------------------------------------------------------------------------------------------------------------------

  Behavior on y { PropertyAnimation { duration: durations.overlayTransition;  easing.type: Easing.InOutQuad } }

  Item {
    id: showHide
    state: visibleState
    states: [
      State {
        name: "show";
        PropertyChanges { target: topLabels;   y: yPositionWhenShown}
      },
      State {
        name: "hide";
        PropertyChanges { target: topLabels;   y: yPositionWhenHidden}
      }
    ]
  }
}