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
  readonly property color barBgColor: colors.orangeDimmed //"black"

  anchors.left:  parent.left
  anchors.right: parent.right
  height: 70

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
    anchors.fill: parent
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

  //FX active Decks indicator buttons
  AppProperty { id: fxassignementA;	 path: "app.traktor.mixer.channels.1.fx.assign." + fxUnit }
  AppProperty { id: fxassignementB;	 path: "app.traktor.mixer.channels.2.fx.assign." + fxUnit }
  AppProperty { id: fxassignementC;	 path: "app.traktor.mixer.channels.3.fx.assign." + fxUnit }
  AppProperty { id: fxassignementD;	 path: "app.traktor.mixer.channels.4.fx.assign." + fxUnit }

  Rectangle {
    id: fxAassignementbutton
    width: 15
    height: 15
    radius: 3
    visible: preferences.displayAssignFX

    color: fxassignementA.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2-13*3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

        Text {
            id: fxAassignementtext
            text: "A"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            color: fxassignementA.value == 1 ? colors.colorBlack : colors.colorGrey88
            font.pixelSize: fonts.scale(11)
        }
  }

  Rectangle {
    id: fxBassignementbutton
    width: 15
    height: 15
    radius: 3
    visible: preferences.displayAssignFX

    color: fxassignementB.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.right: parent.right
    anchors.rightMargin: (parent.width/2) -13*3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

        Text {
            id: fxBassignementtext
            text: "B"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            color: fxassignementB.value == 1 ? colors.colorBlack : colors.colorGrey88
            font.pixelSize: fonts.scale(11)
        }
  }

  Rectangle {
    id: fxCassignementbutton
    width: 15
    height: 15
    radius: 3
    visible: preferences.displayAssignFX

    color: fxassignementC.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2-13*5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

        Text {
            id: fxCassignementtext
            text: "C"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            color: fxassignementC.value == 1 ? colors.colorBlack : colors.colorGrey88
            font.pixelSize: fonts.scale(11)
        }
  }

  Rectangle {
    id: fxDassignementbutton
    width: 15
    height: 15
    radius: 3
    visible: preferences.displayAssignFX

    color: fxassignementD.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    anchors.right: parent.right
    anchors.rightMargin: parent.width/2-13*5
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3

        Text {
            id: fxDassignementtext
            text: "D"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            color: fxassignementD.value == 1 ? colors.colorBlack : colors.colorGrey88
            font.pixelSize: fonts.scale(11)
        }
  }

  //Line dividers
  readonly property int dividerHeight: 51 //the top info details height

  Rectangle {
    id: fxInfoDivider0
    width: 1
    height: dividerHeight
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: parent.width*(1/4)
  }

  Rectangle {
    id: fxInfoDivider1
    width: 1
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: parent.width*(2/4)
    height: dividerHeight
  }

  Rectangle {
    id: fxInfoDivider2
    width: 1
    color: colors.colorDivider
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: parent.width*(3/4)
    height: dividerHeight
  }

  //Info Details
  Item {
    id: topInfoDetailsPanel
    anchors.left: parent.left
    anchors.leftMargin: 1
    height: parent.height
    width: parent.width
    clip: true


    Row {
        TopInfoDetails {
            id: topInfoDetails1
            parameter: fxDryWet
            isOn: fxOn.value
            label: singleMode.value ? fxSelect1.description : "DRY/WET"
            buttonLabel: singleMode.value ? "ON" : ""
            fxEnabled: (!singleMode.value) || fxSelect1.value
            barBgColor: barBgColor
            width: topLabels.width/4
        }

        TopInfoDetails {
            id: topInfoDetails2
            parameter: fxParam1
            isOn: fxButton1.value
            label: fxKnob1name.value
            buttonLabel: fxButton1name.value
            fxEnabled: (fxSelect1.value || (singleMode.value && fxSelect1.value) )
            barBgColor: barBgColor
            width: topLabels.width/4
        }

        TopInfoDetails {
            id: topInfoDetails3
            parameter: fxParam2
            isOn: fxButton2.value
            label: fxKnob2name.value
            buttonLabel: fxButton2name.value
            fxEnabled: (fxSelect2.value || (singleMode.value && fxSelect1.value) )
            barBgColor: barBgColor
            width: topLabels.width/4
        }

        TopInfoDetails {
            id: topInfoDetails4
            parameter: fxParam3
            isOn: fxButton3.value
            label: fxKnob3name.value
            buttonLabel: fxButton3name.value
            fxEnabled: (fxSelect3.value || (singleMode.value && fxSelect1.value) )
            barBgColor: barBgColor
            width: topLabels.width/4
        }
    }
  }

  //Black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.top: topLabels.bottom
    width: parent.width
    color: colors.colorIndicatorLevelOrange //colors.colorBlack
    height: 1
  }
  Rectangle {
    id: headerShadow
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: headerBlackLine.bottom
    height: 6
    gradient: Gradient {
        GradientStop { position: 1.0; color: colors.colorBlack0 }
        GradientStop { position: 0.0; color: colors.colorBlack63 }
    }
    visible: false
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