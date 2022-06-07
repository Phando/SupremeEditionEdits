import QtQuick 2.12
import CSI 1.0

import '../Widgets' as Widgets

Rectangle {
  id: bottomInfoDetails
  property int deckId: 1
  property int slotId
  property int column

  property int fxUnit
  property int midiId
  property bool showSampleName
  property bool slotState

  property color  levelColor
  property color  backgroundColor

  // If markActive is true, this cell will be "highlighted" to show the user that it is parameterOn
  // Currently the highlight is done by underlining the label
  property alias  markActive: bottomInfoTextUnderline.visible

  readonly property bool isTraktorS5: screen.flavor == ScreenFlavor.S5
  MappingProperty { id: performanceEncoderControls; path: deckPropertiesPath + ".performanceEncoderControls" }

  anchors.top: parent.top
  anchors.bottom: parent.bottom
  color: isTraktorS5 && slotState && (performanceEncoderControls.value != column && column != 0) ? darkerColor(backgroundColor, 0.5) : backgroundColor
  function darkerColor( c, factor ) { return Qt.rgba(factor*c.r, factor*c.g, factor*c.b, c.a) }

  AppProperty { id: stemColorId; path: stemDeckPropertyPath + (index + 1) + ".color_id" }
  property color  textColor:  isStemDeck && (state != "FX") && (state != "MIDI") ? colors.palette(1.0, stemColorId.value) : colors.colorFontFxHeader
  property double sliderHeight: 0
  readonly property color sliderBackgroundcolor: "black"

//----------------------------------------------------------------------------------------------------------------------
// Info Item
//----------------------------------------------------------------------------------------------------------------------

  Item {
    id: bottomInfoDetailsPanel // prevents text to show up beneath the progress bars on size change animation

    anchors.top: parent.top
    anchors.left: parent.left

    height: parent.height - (bottomInfoDetails.sliderHeight) - 3
    width: parent.width
    clip: true

    //Name
    Text {
        id: name
        property string labelText: "" // updated via states

        anchors.top: parent.top
        anchors.topMargin: (sizeState == "large") ? 21 : 2
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8

        visible: sizeState == "large" || showSampleName || isStemDeck

        text: labelText
        color: levelColor //bottomInfoDetails.textColor
        font.pixelSize: fonts.scale(11)
        font.capitalization: Font.AllUppercase
        elide: Text.ElideRight
    }

    //Parameter Value/Description (Only visible in large state)
    Item {
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.left: parent.left
        anchors.leftMargin: 8
        height: 20
        visible: isEnabled

        Text {
            id: parameterDisplayText
            anchors.verticalCenter: parent.verticalCenter
            text: toPercent ? Math.floor(parameter.description * 100 + 0.1) + "%" : parameter.description
            color: colors.colorWhite
            font.family: "Pragmatica" // is monospaced
            font.pixelSize: fonts.largeValueFontSize

            property bool toPercent: false
        }
    }

    //Parameter Active Button (Only visible in large state)
    Rectangle {
        id: activeButton
        anchors.top: parent.top
        anchors.topMargin: 42
        anchors.right: parent.right
        anchors.rightMargin: parent.width*0.15/2
        width: parent.width/4
        height: 15
        color: (parameterOn.value ? levelColor : "black")
        radius: 1

        Text {
            id: activeButtonText
            anchors.centerIn: parent
            font.capitalization: Font.AllUppercase
            text: ""
            color: parameterOn.value ? colors.colorBlack : colors.colorGrey88
            font.pixelSize: fonts.miniFontSize
        }
    }

    //Underline the name (S5 ONLY)
    Rectangle {
        id: bottomInfoTextUnderline

        color: bottomInfoDetails.textColor
        height: 1

        anchors.top: name.bottom
        anchors.topMargin: -1
        anchors.left: name.left
        anchors.right: name.right

        visible: true
    }
  }

//----------------------------------------------------------------------------------------------------------------------
// Info Widgets for values
//----------------------------------------------------------------------------------------------------------------------

  //Dividers
  Rectangle {
    id: bottomInfoDivider
    anchors.bottom: parent.bottom
    anchors.right:  parent.right
    width: 1
    height: sizeState == "large" ? 57 : 0
    color: colors.colorDivider
    visible: !isTraktorS5 || (isTraktorS5 && column == 0 && (bottomInfoPanel.contentState == "SLOT 1" || bottomInfoPanel.contentState == "SLOT 2" || bottomInfoPanel.contentState == "SLOT 3" || bottomInfoPanel.contentState == "SLOT 4" || bottomInfoPanel.contentState == "MULTIPLES SLOTS"))

    Behavior on height { NumberAnimation { duration: durations.overlayTransition } }
  }

  //Progress Bar
  Widgets.ProgressBar {
    id: progressBarWidget
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3
    anchors.left: parent.left
    anchors.leftMargin: parent.width*0.15/2
    progressBarWidth: parent.width*0.85
    progressBarHeight: bottomInfoDetails.sliderHeight
    visible: !(parameter.valueRange.isDiscrete && isEnabled) && !bipolarBarWidget.visible && bottomInfoDetails.state != "EMPTY" && bottomInfoDetails.state != "MULTIPLE SLOTS"

    progressBarColorIndicatorLevel: isActive ? parent.levelColor : colors.darkerColor(parent.levelColor, 0.3)
    progressBarBackgroundColor: parent.sliderBackgroundcolor //set in parent
    value: (bottomInfoDetails.state == "PITCH") ? (0.5*parameter.value + 0.5) : (parameter.value != undefined ? parameter.value : 0.0)
    drawAsEnabled: isEnabled && (name.name != "")
  }

  //Bipolar Bar
  Widgets.BipolarBar {
    id: bipolarBarWidget
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3
    anchors.left: parent.left
    anchors.leftMargin: parent.width*0.15/2
    progressBarWidth: parent.width*0.85
    progressBarHeight: bottomInfoDetails.sliderHeight
    visible: (bottomInfoDetails.state == "PITCH") ||  (bottomInfoDetails.state == "FILTER")

    progressBarColorIndicatorLevel: isActive ? parent.levelColor : colors.darkerColor(parent.levelColor, 0.3)
    progressBarBackgroundColor: parent.sliderBackgroundcolor //set in parent
    value: (bottomInfoDetails.state == "PITCH") ? (0.5*parameter.value + 0.5) : (parameter.value != undefined ? parameter.value : 0.0)
    drawAsEnabled: isEnabled && (name.name != "")
  }

  //Discrete Bar
  Widgets.StateBar {
    id: discreteBarWidget
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 3
    anchors.left: parent.left
    anchors.leftMargin: parent.width*0.15/2
    height: bottomInfoDetails.sliderHeight
    width: parent.width*0.85
    visible: (bottomInfoDetails.state == "FX") ? (parameter.valueRange.isDiscrete && isEnabled && (name.name != "")) : false

    barColor: isActive ? parent.levelColor : colors.darkerColor(parent.levelColor, 0.3)
    barBgColor: parent.sliderBackgroundcolor //set in parent
    stateCount: (bottomInfoDetails.state == "FX") ?	parameter.valueRange.steps : 0
    currentState: (bottomInfoDetails.state == "FX") ? ( (parameter.valueRange.steps - 1) * parameter.value) : 0
  }

  MappingProperty { id: selectedCellLock; path: deckPropertiesPath + ".sequencerSampleLockSlot" + slotId }
  //Locked button (SAMPLE STATE ONLY)
  Text {
    id: lockedText
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 8
    anchors.right: parent.right
    anchors.rightMargin: 8
    visible: bottomInfoDetails.state == "SAMPLE"

    font.capitalization: Font.AllUppercase
    text: "SAMPLE   LOCKED"
    color: selectedCellLock.value ? bottomInfoDetails.levelColor : "black"
    font.pixelSize: fonts.miniFontSize
  }

//------------------------------------------------------------------------------------------------------------------
// BOTTOM PANEL CONTENT STATES
//------------------------------------------------------------------------------------------------------------------

  //Necessary for the FX Names
  readonly property string finalLabel: column == 0 ? (singleMode.value ? fxSelect1.description : "DRY/WET") : parameterName.description
  readonly property int	macroEffectChar: 0x00B6
  readonly property bool isMacroFx: finalLabel.charCodeAt(0) == macroEffectChar

  //These properties are necessary to establish the connections to traktor AppProperties
  AppProperty { id: sequencerOn;  path: "app.traktor.decks." + deckId + ".remix.sequencer.on" }
  AppProperty { id: sequencerSelectedRow;  path: playerPropertyPath + ".sequencer.selected_cell" }
  AppProperty { id: activeCellRow; path: playerPropertyPath + ".active_cell_row" }
  property int sampleId: sequencerOn.value ? (sequencerSelectedRow.value+1) : (activeCellRow.value+1)

  property string fxUnitPath: "app.traktor.fx." + fxUnit
  property string stemDeckPropertyPath : "app.traktor.decks." + deckId + ".stems."
  property string remixDeckPropertyPath: "app.traktor.decks." + deckId + ".remix."
  property string playerPath: isStemDeck ? stemDeckPropertyPath + slotId : remixDeckPropertyPath + "players." + slotId
  property string slotPropertyPath: "app.traktor.decks." + deckId + ".remix_slots." + slotId
  property string playerPropertyPath: remixDeckPropertyPath + "players." + slotId
  property string columnPropertyPath: remixDeckPropertyPath + "cell.columns." + slotId
  property string activeCellPath: columnPropertyPath + ".rows." + sampleId //(activeCellRow.value+1)

  //the path of the following properties is modified for each content
  AppProperty { id: parameter; path: playerPath + ".filter_value" }
  AppProperty { id: parameterOn; path: playerPath + ".filter_on" }
  AppProperty { id: parameterName; path: fxUnitPath + ".name" }

  AppProperty { id: fxButtonName; path: fxUnitPath + ".buttons." + column + ".name" }
  AppProperty { id: singleMode; path: fxUnitPath + ".type" }
  AppProperty { id: fxSelect1; path: fxUnitPath + ".select.1" }
  AppProperty { id: fxColumnSelect; path: fxUnitPath + ".select." + column }

  property bool isEnabled: false
  property bool isActive: bottomInfoDetails.state == "FX" ? true : (bottomInfoDetails.state == "VOLUME" ? !parameterOn.value : parameterOn.value) || false //for Volume, the property is Muted, and we need the opposite

  state: "EMPTY"
  states: [
    State {
        name: "EMPTY"
        PropertyChanges { target: name; labelText: "" }
        PropertyChanges { target: parameterName; path: "" }
        PropertyChanges { target: parameter; path: "" }
        PropertyChanges { target: parameterOn; path: "" }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: false }
        PropertyChanges { target: activeButtonText; text: "ON" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: false }
    },
    State {
        name: "MULTIPLE SLOTS"
        PropertyChanges { target: name; labelText: "" }
        PropertyChanges { target: parameterName; path: "" }
        PropertyChanges { target: parameter; path: "" }
        PropertyChanges { target: parameterOn; path: "" }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: false }
        PropertyChanges { target: activeButtonText; text: "ON" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: false }
    },
    State {
        name: "FX"
        PropertyChanges { target: name; labelText: isMacroFx ? finalLabel.substr(1) : finalLabel }
        PropertyChanges { target: parameterName; path: column == 0 ? (fxUnitPath + ".enabled") : (fxUnitPath + ".knobs." + column + ".name") }
        PropertyChanges { target: parameter; path: column == 0 ? (fxUnitPath + ".dry_wet") : (fxUnitPath + ".parameters." + column ) }
        PropertyChanges { target: parameterOn; path: column == 0 ? (fxUnitPath + ".enabled") : (fxUnitPath + ".buttons." + column) }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: column != 0 || singleMode.value }
        PropertyChanges { target: activeButtonText; text: column == 0 ? "ON" : fxButtonName.value }
        PropertyChanges { target: bottomInfoDetails; isEnabled: column == 0 ? ((!singleMode.value) || fxSelect1.value)  : (fxColumnSelect.value || (singleMode.value && fxSelect1.value)) }
    },
    State {
        name: "FILTER"
        PropertyChanges { target: name; labelText: showSampleName ? "FILTER" : (parameterName.description == "" ? "SLOT "+slotId : parameterName.description) }
        PropertyChanges { target: parameterName; path: isStemDeck ? playerPath + ".name" : activeCellPath + ".name" }
        PropertyChanges { target: parameter; path: playerPath + ".filter_value" }
        PropertyChanges { target: parameterOn; path: playerPath + ".filter_on" }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: true }
        PropertyChanges { target: activeButtonText; text: "ON" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: true }
    },
    State {
        name: "PITCH"
        PropertyChanges { target: name; labelText: showSampleName ? "PITCH" : (parameterName.description == "" ? "SLOT "+slotId : parameterName.description)  }
        PropertyChanges { target: parameterName; path: isStemDeck ? playerPath + ".name" : activeCellPath + ".name" }
        PropertyChanges { target: parameter; path: activeCellPath + ".pitch" }
        PropertyChanges { target: parameterOn; path: playerPath + ".key_lock" }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: true }
        PropertyChanges { target: activeButtonText; text: "ON" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: true }
    },
    State {
        name: "FX SEND"
        PropertyChanges { target: name; labelText: showSampleName ? "FX SEND" : (parameterName.description == "" ? "SLOT "+slotId : parameterName.description) }
        PropertyChanges { target: parameterName; path: isStemDeck ? playerPath + ".name" : activeCellPath + ".name" }
        PropertyChanges { target: parameter; path: playerPath + ".fx_send" }
        PropertyChanges { target: parameterOn; path: playerPath + ".fx_send_on" }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: true }
        PropertyChanges { target: activeButtonText; text: "ON" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: true }
    },
    State {
        name: "MIDI"
        PropertyChanges { target: name; labelText: "MIDI " + midiId }
        PropertyChanges { target: parameterName; path: "" }
        PropertyChanges { target: parameter; path: "app.traktor.midi.knobs." + midiId }
        PropertyChanges { target: parameterOn; path: "app.traktor.midi.buttons." + midiId }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: true }
        PropertyChanges { target: activeButtonText; text: "ON" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: true }
    },
    State {
        name: "VOLUME"
        PropertyChanges { target: name; labelText: showSampleName ? "VOLUME" : (parameterName.description == "" ? "SLOT "+slotId : parameterName.description)  }
        PropertyChanges { target: parameterName; path: isStemDeck ? playerPath + ".name" : activeCellPath + ".name" }
        PropertyChanges { target: parameter; path: playerPath + ".volume" }
        PropertyChanges { target: parameterOn; path: playerPath + ".muted" }
        PropertyChanges { target: parameterDisplayText; toPercent: true }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.largeValueFontSize }
        PropertyChanges { target: activeButton; visible: true }
        PropertyChanges { target: activeButtonText; text: "MUTE" }
        PropertyChanges { target: bottomInfoDetails; isEnabled: true }
    },
    State {
        name: "SAMPLE"
        PropertyChanges { target: name; labelText: showSampleName ? "SLOT "+slotId : (parameterName.description == "" ? "SLOT "+slotId : parameterName.description) }
        PropertyChanges { target: parameterName; path: isStemDeck ? playerPath + ".name" : activeCellPath + ".name" }
        PropertyChanges { target: parameter; path: playerPath + ".sequencer.selected_cell" }
        PropertyChanges { target: parameterOn; path: "" }
        PropertyChanges { target: parameterDisplayText; toPercent: false }
        PropertyChanges { target: parameterDisplayText; font.pixelSize: fonts.middleFontSize }
        PropertyChanges { target: activeButton; visible: false }
        PropertyChanges { target: bottomInfoDetails; isEnabled: true }
    }
  ]
}