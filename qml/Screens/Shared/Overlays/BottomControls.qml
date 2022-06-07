import QtQuick 2.12
import CSI 1.0

import '../../../Defines'
import '../Widgets' as Widgets
import '../Variables' as Variables

Rectangle {
  id: bottomInfoPanel
  property int deckId
  property string sizeState //set in state, in the end of this file
  property string contentState: ""
  property int midiId
  property int fxUnit

  anchors.left: parent.left
  anchors.right: parent.right
  anchors.bottom: parent.bottom
  height: 0 //defined by sizeState, on the end of this file
  color: backgroundColor
  visible: true //defined by sizeState, on the end of this file

  Behavior on height { NumberAnimation { duration: durations.overlayTransition } }

  //Helpers
  property int footerId: side.footerId
  property string deckPropertiesPath: propertiesPath + "." + footerId

  AppProperty { id: deckType; path: "app.traktor.decks." + footerId + ".type" }

  readonly property bool isUpperDeck: footerId < 3
  readonly property bool isTraktorS5: screen.flavor == ScreenFlavor.S5

  property color levelColor: contentState == "FX" ? colors.colorIndicatorLevelOrange : (contentState == "MIDI" ? (screen.focusedDeckId < 3 ? colors.brightBlue : colors.colorWhite) : (isUpperDeck ? colors.brightBlue : colors.colorWhite))
  property color backgroundColor: contentState == "FX" ? colors.orangeDimmed : (contentState == "MIDI" ? colors.colorGrey16 : (isUpperDeck ? colors.footerBlue : colors.colorGrey40))

  MappingProperty { id: editMode; path: propertiesPath + ".edit_mode" }
  MappingProperty { id: footerHasContent; path: propertiesPath + ".footerHasContent" }
  MappingProperty { id: footerHasContentToSwitch; path: propertiesPath + ".footerHasContentToSwitch" }

  property bool isStemDeck: deckType.value == DeckType.Stem

//----------------------------------------------------------------------------------------------------------------------
// Bottom Info Details (Row containing the progress bars + info texts)
//----------------------------------------------------------------------------------------------------------------------

  //readonly property bool showPerformanceFooter: (screen.flavor != ScreenFlavor.S5)
  property bool showSampleName: contentState == "FX" || contentState == "SLOT 1" || contentState == "SLOT 2" || contentState == "SLOT 3" || contentState == "SLOT 4"

  Row {
    id: bottomPanelRow
    property double sliderHeight: 12 //changed in state, needed to simultaniously change the height of all

    Behavior on sliderHeight { NumberAnimation { duration: durations.overlayTransition } }

    anchors.fill: parent
    anchors.leftMargin: 1
    visible: editMode.value != EditMode.full

    Repeater {
        id: rep
        model: isTraktorS5 && (bottomInfoPanel.contentState == "SLOT 1" || bottomInfoPanel.contentState == "SLOT 2" || bottomInfoPanel.contentState == "SLOT 3" || bottomInfoPanel.contentState == "SLOT 4" || bottomInfoPanel.contentState == "MULTIPLES SLOTS") ? (bottomInfoPanel.isStemDeck ? 3 : 5) : 4

        BottomInfoDetails {
            id: bottomInfoDetails
            deckId: bottomInfoPanel.footerId
            slotId: getSlotId(bottomInfoPanel.contentState, index)
            column: index
            width: parent.width/rep.count

            fxUnit: bottomInfoPanel.fxUnit
            midiId: bottomInfoPanel.midiId + (index+1)
            markActive: slotSelected //for the S5 only
            slotState: bottomInfoPanel.contentState == "SLOT 1" || bottomInfoPanel.contentState == "SLOT 2" || bottomInfoPanel.contentState == "SLOT 3" || bottomInfoPanel.contentState == "SLOT 4" || bottomInfoPanel.contentState == "MULTIPLES SLOTS" //for the S5 only

            levelColor: bottomInfoPanel.levelColor
            backgroundColor: bottomInfoPanel.backgroundColor
            sliderHeight: bottomPanelRow.sliderHeight

            showSampleName: bottomInfoPanel.showSampleName
            state: getColumnState(bottomInfoPanel.contentState, index)

            // If content is a slot deck on an S5, check if the current stem is selected (usually done via the pads)
            MappingProperty { id: slotSelectorMode; path: propertiesPath + "." + footerId + ".slot_selector_mode." + (index + 1) }
            property bool slotSelected: bottomInfoPanel.isStemDeck ? ( slotSelectorMode.value === undefined ? false : slotSelectorMode.value ) : false
        }
    }
  }

  function getSlotId(state, column) {
    if (state == "SLOT 1")
        return 1;
    else if (state == "SLOT 2")
        return 2;
    else if (state == "SLOT 3")
        return 3;
    else if (state == "SLOT 4")
        return 4;
    return column+1;
  }

  function getColumnState(state, column) {
    if (!isTraktorS5 && (state == "SLOT 1" || state == "SLOT 2" || state == "SLOT 3" || state == "SLOT 4")) {
        switch (column) {
            case 0:
                return "SAMPLE";
            case 1:
                return "FILTER";
            case 2:
                return "PITCH";
            case 3:
                return "FX SEND";
        }
    }
    else if (isTraktorS5 && (state == "SLOT 1" || state == "SLOT 2" || state == "SLOT 3" || state == "SLOT 4") && deckType.value == DeckType.Remix ) {
        switch (column) {
            case 0:
                return "VOLUME";
            case 1:
                return "SAMPLE";
            case 2:
                return "FILTER";
            case 3:
                return "PITCH";
            case 4:
                return "FX SEND";
        }
    }
    else if (isTraktorS5 && (state == "SLOT 1" || state == "SLOT 2" || state == "SLOT 3" || state == "SLOT 4") && deckType.value == DeckType.Stems ) {
        switch (column) {
            case 0:
                return "VOLUME";
            case 1:
                return "FILTER";
            case 2:
                return "FX SEND";
        }
    }
    return state;
  }

//----------------------------------------------------------------------------------------------------------------------
// Bottom Panel Elements
//----------------------------------------------------------------------------------------------------------------------

  //Bottom Panel Headline
  Text {
    id: bottomPanelHeadline
    text: contentState == "FX" ? ("FX " + fxUnit) : contentState
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 3
    visible: (!showSampleName || (showSampleName && sizeState == "large")) && !(isStemDeck && sizeState != "large")
    color: bottomInfoPanel.levelColor
    font.pixelSize: fonts.scale(11)
  }

  //Line on top of the BottomPanel
  Rectangle {
    id: topLine
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
    color: levelColor
    visible: true
  }

  //Black border on top of the Bottom Panel
  Rectangle {
    id: topBlackLine
    anchors.bottom: bottomPanelRow.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
    color: colors.colorBlack
    visible: true
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

    color: fxOnA.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    visible: contentState == "FX" && sizeState == "large" // preferences.displayAssignFX
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2-13*3
    anchors.top: parent.top
    anchors.topMargin: 3

        Text {
            id: fxAassignementtext
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

    color: fxOnB.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    visible: contentState == "FX" && sizeState == "large" // preferences.displayAssignFX
    anchors.right: parent.right
    anchors.rightMargin: (parent.width/2) -13*3
    anchors.top: parent.top
    anchors.topMargin: 3

        Text {
            id: fxBassignementtext
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

    color: fxOnC.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    visible: contentState == "FX" && sizeState == "large" // preferences.displayAssignFX
    anchors.left: parent.left
    anchors.leftMargin: parent.width/2-13*5
    anchors.top: parent.top
    anchors.topMargin: 3

        Text {
            id: fxCassignementtext
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

    color: fxOnD.value == 1 ? colors.colorIndicatorLevelOrange : colors.colorBlack
    visible: contentState == "FX" && sizeState == "large" // preferences.displayAssignFX
    anchors.right: parent.right
    anchors.rightMargin: parent.width/2-13*5
    anchors.top: parent.top
    anchors.topMargin: 3

    Text {
        id: fxDassignementtext
        text: "D"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: fxOnD.value == 1 ? colors.colorBlack : colors.colorGrey88
        font.pixelSize: fonts.scale(11)
    }
  }

//----------------------------------------------------------------------------------------------------------------------
// Arrow Indicators (Change Footer)
//----------------------------------------------------------------------------------------------------------------------

  Widgets.Triangle {
    id : leftArrow
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 3
    anchors.topMargin: 7
    width: 9
    height: 5
    opacity: 1
    color: levelColor //colors.colorGrey40
    rotation: 90
    visible: footerHasContentToSwitch.value && editMode.value != EditMode.full && (sizeState == "large")
    antialiasing: false
    Behavior on opacity { NumberAnimation { duration: 30 } }
  }

  Widgets.Triangle {
    id : rightArrow
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.rightMargin: 3
    anchors.topMargin: 7
    width: 9
    height: 5
    opacity: 1
    color: levelColor //colors.colorGrey40
    rotation: -90
    visible: footerHasContentToSwitch.value && editMode.value != EditMode.full && (sizeState == "large")
    antialiasing: false
    Behavior on opacity { NumberAnimation { duration: 30 } }
  }

//------------------------------------------------------------------------------------------------------------------
//  BEATGRID FOOTER - EDIT MODE
//------------------------------------------------------------------------------------------------------------------

  BeatgridFooter {
    id: beatgrid
    anchors.fill: parent
    visible: editMode.value == EditMode.full
    deckId: parent.deckId
  }

//------------------------------------------------------------------------------------------------------------------
//  BOTTOM PANEL SIZE STATES
//------------------------------------------------------------------------------------------------------------------

  readonly property int smallStateHeight: 27
  readonly property int bigStateHeight: 81

  state: sizeState
  states: [
    State {
        name: "hide"
        //PropertyChanges { target: bottomInfoPanel; height: hideStateHeight}
        PropertyChanges { target: bottomPanelRow; sliderHeight: 0 }
    },
    State {
        name: "small"
        PropertyChanges { target: bottomInfoPanel; height: smallStateHeight }
        PropertyChanges { target: bottomPanelRow; sliderHeight: 6 }
    },
    State {
        name: "large"
        PropertyChanges { target: bottomInfoPanel; height: bigStateHeight }
        PropertyChanges { target: bottomPanelRow;  sliderHeight: 9 }
    }
  ]
}
