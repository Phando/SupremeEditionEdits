import CSI 1.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import '../../../../../Defines'
import '../../../../Shared/Widgets' as Widgets
import '../../../../Shared/Widgets/Remix' as Remix

Item {
  id: remixDeck
  property int deckId: 1

  readonly property int speed: 40 //Transition speed
  property int margins: 4

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: parent.height*0.1375
    color: brightMode.value ? "white" : "black"
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  //Title
  Widgets.ScrollingText {
    id: titleField
    anchors.top: deck_header.top
    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    height: deck_header.height
    width: parent.width - bpmField.width
    textTopMargin: -1
    textFontFamily: "Roboto"
    textFontSize: 24
    textColor: brightMode.value ? colors.colorGrey32 : colors.colorGrey232
    containerColor: sequencerRecOn.value ? colors.red : "transparent"
    //containerRadius: margins
    marqueeText: isLoaded.value ? (sequencer.visible ? activeCellName.value : title.value): "No Samples Loaded"
    doScroll: true
    visible: !(sampleParameters.visible || sampleBrowsing.visible)
  }

  //Warning Overlay
  Widgets.DeckHeaderMessage {
    id: warning_box
    anchors.fill: deck_header

    permanentMessage: true
    showLongMessage: false
  }

//--------------------------------------------------------------------------------------------------------------------
// BPM
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: bpmField
    anchors.top: deck_header.bottom
    anchors.left: parent.left
    anchors.leftMargin: margins
    height: parent.height*0.1375
    width: (parent.width-margins*3)/2

    color: (isSyncEnabled.value || isMaster) ? colors.darkerColor(colors.cyan, 0.15) : "black" //colors.background
    radius: margins
    border.width: 2
    border.color: isMaster ? colors.cyan : isSyncEnabled.value ? colors.darkerColor(colors.cyan, 0.15) : colors.colorGrey40
    visible: isLoaded.value && !(sampleParameters.visible || sampleBrowsing.visible || sequencer.visible)

    Text {
        text: stableBpm.value.toFixed(2)
        font.pixelSize: 24
        font.family: "Roboto"
        font.weight: Font.Normal
        color: "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
  }

  function colorForSync(masterId, synched, phase) {
    if ((masterId == -1) && synched) {
        return colors.cyan;
    }
    else if (masterId == deckId && synched) {
        return colors.mint;
    }
    else if (synched) {
        //if (phase == 0.00) { return colors.mint;}
        if (phase >= -0.016 && phase <= 0.016) {
            return colors.greenActive;
        }
        else {
            return colors.red;
        }
    }
    else {
      return colors.colorGrey72;
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Quantize
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: quantizeField
    anchors.top: deck_header.bottom
    anchors.right: parent.right
    anchors.rightMargin: margins
    height: parent.height*0.1375
    width: (parent.width-margins*3)/2

    color: remixQuantize.value ? colors.darkerColor(colors.cyan, 0.15) : "black" //"colors.colorGrey40"
    radius: margins
    border.width: 2
    border.color: remixQuantize.value ? colors.cyan : colors.colorGrey40
    visible: isLoaded.value && !(sampleParameters.visible || sampleBrowsing.visible || sequencer.visible)

    Text {
      anchors.fill:	parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: remixQuantizeIndex.description
      font.family: "Roboto"
      font.pixelSize: fonts.scale(24)
      color: remixQuantize.value ? colors.cyan : colors.colorGrey40
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Remix Beats
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: beatsField
    anchors.top: bpmField.bottom
    anchors.topMargin: margins
    anchors.left: parent.left
    anchors.leftMargin: margins
    height: parent.height*0.275
    width: (parent.width-margins*3)/2

    color: colors.colorGrey40
    radius: margins
    border.width: 2
    border.color: colors.colorGrey40
    visible: isLoaded.value && !(sampleParameters.visible || sampleBrowsing.visible || sequencer.visible)

    Text {
        text: remixBeats.description
        font.pixelSize: 45
        font.family: "Roboto"
        font.weight: Font.Normal
        color: "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Loop Size Indicator
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: loopField
    anchors.top: quantizeField.bottom
    anchors.topMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    height: parent.height*0.275
    width: (parent.width-margins*3)/2

    color:  isInActiveLoop.value ? (fluxEnabled.value ? colors.cyan : (loopActive.value ? colors.green : colors.colorGrey40)) : colors.colorGrey40
    radius: margins
    border.width: 2
    border.color: fluxEnabled.value ? colors.cyan : (loopActive.value ? colors.green : colors.colorGrey40)
    visible: isLoaded.value && !(sampleParameters.visible || sampleBrowsing.visible || sequencer.visible)

    Text {
        text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
        font.pixelSize: 45
        font.family: "Roboto"
        color: isInActiveLoop.value && (fluxEnabled.value || loopActive.value) ? "black" : "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Phase Meter & Beat Counter
//--------------------------------------------------------------------------------------------------------------------

  //Phase Meter
  Widgets.PhaseMeter {
    id: phaseMeter
    deckId: parent.deckId
    anchors.top: beatsField.bottom
    anchors.topMargin: margins
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width-margins*2
    height: parent.height*0.1375
    radius: margins
    visible: isLoaded.value && !beatmatchPracticeMode.value && phaseWidget.value == 1 && !sampleParameters.visible && !sequencer.visible
  }

  //Beat Counter
  Widgets.BeatCounterS4 {
    id: beatCounter
    deckId: parent.deckId
    anchors.top: beatsField.bottom
    anchors.topMargin: margins
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width-margins*2
    height: parent.height*0.1375
    visible: isLoaded.value && !beatmatchPracticeMode.value && phaseWidget.value == 2 && !sampleParameters.visible && !sequencer.visible

    //Behavior on visible { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Remix Parameters Overlay
//--------------------------------------------------------------------------------------------------------------------

  Remix.RemixParameters {
    id: sampleParameters
    anchors.top: parent.top
    anchors.bottom: samples.top
    anchors.bottomMargin: margins
    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    visible: slotState.value && activePadsMode.value == PadsMode.remix
  }

//--------------------------------------------------------------------------------------------------------------------
// Sample Browsing Overlay
//--------------------------------------------------------------------------------------------------------------------

  Grid {
    id: sampleBrowsing

    anchors.top: parent.top
    anchors.bottom: samples.top
    anchors.bottomMargin: margins
    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins

    visible: slotState.value && activePadsMode.value == PadsMode.remix

    Repeater {
        model: 4

        Column {
            spacing: margins

            Row {
                spacing: margins

                Remix.SampleIcon {
                    id: sample

                    AppProperty { id: activeCellY; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".active_cell_row" }

                    deckId: remixDeck.deckId
                    slotId: index+1
                    cellId: activeCellY.value+1
                    samplePropertyPath: "app.traktor.decks." + deckId + ".remix.cell.columns." + (index+1) + ".rows." + (activeCellY.value+1)
                    cellSize: (samples.width-samples.spacing*3)/4
                    cellRadius: margins
                    visible: false //TODO: Fix the Sample Selector
                }
            }
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Step Sequencer Overlay
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: current_step; path: "app.traktor.decks." + deckId + ".remix.players." + sequencerSlot.value + ".sequencer.current_step" }
  AppProperty { id: pattern_length; path: "app.traktor.decks." + deckId + ".remix.players." + sequencerSlot.value + ".sequencer.pattern_length" }
  AppProperty { id: activeStepCellY; path: "app.traktor.decks." + deckId + ".remix.players." + sequencerSlot.value + ".active_cell_row" }
  AppProperty { id: activeCellName; path: "app.traktor.decks." + deckId + ".remix.cell.columns." + sequencerSlot.value + ".rows." + (activeStepCellY.value+1) + ".name" }
  AppProperty { id: activeCellColorId; path: "app.traktor.decks." + deckId + ".remix.cell.columns." + sequencerSlot.value + ".rows." + (activeStepCellY.value+1) + ".color_id" }

  property int numberOfEditableSteps: 8

  Grid {
    id: sequencer

    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    anchors.top: titleField.bottom
    anchors.topMargin: margins
    anchors.bottom: samples.top
    anchors.bottomMargin: margins

    columns: 4
    spacing: margins

    visible: activePadsMode.value == PadsMode.sequencer

    Repeater {
        model: pattern_length.value
        Rectangle {
            AppProperty   { id: step; path: "app.traktor.decks." + deckId + ".remix.players." + sequencerSlot.value + ".sequencer.steps." + (index + 1) }
            id: stepSquare
            radius: margins
            width: (sequencer.width-sequencer.spacing*3)/4
            height: (sequencer.height-sequencer.spacing*3)/4
            color: current_step.value === index ? colors.colorWhite : (step.value ? colors.palette(1.0, activeCellColorId.value) : colors.colorGrey24)
            border.width: 1
            border.color: current_step.value === index ? colors.colorWhite : (step.value ? colors.palette(1.0, activeCellColorId.value) : ((index >= (sequencerPage.value-1)*numberOfEditableSteps && index < sequencerPage.value*numberOfEditableSteps) ? colors.palette(1.0, activeCellColorId.value) : colors.colorGrey24))
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Samples
//--------------------------------------------------------------------------------------------------------------------

  Row {
    id: samples

    anchors.left: parent.left
    anchors.leftMargin: margins
    anchors.right: parent.right
    anchors.rightMargin: margins
    anchors.bottom: parent.bottom
    anchors.bottomMargin: margins

    spacing: margins

    Repeater {
        model: 4

        Remix.SampleIcon {
            id: sample

            AppProperty { id: activeCellY; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".active_cell_row" }

            deckId: remixDeck.deckId
            slotId: index+1
            cellId: activeCellY.value+1
            samplePropertyPath: "app.traktor.decks." + deckId + ".remix.cell.columns." + (index+1) + ".rows." + (activeCellY.value+1)
            cellSize: (samples.width-samples.spacing*3)/4
            width: (samples.width-samples.spacing*3)/4
            height: phaseWidget.value == 0 ? 80 : phaseWidget.value == 1 ? 58 : 60
            cellRadius: margins
            visible: true
        }
    }
  }
}
