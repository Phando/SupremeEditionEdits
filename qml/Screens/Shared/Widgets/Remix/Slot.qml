import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Item {
  id: slot
  property int deckId: 1
  property int slotId

  //These properties are necessary to establish the connections to traktor AppProperties
  property string playerPropertyPath: remixDeckPropertyPath + ".players." + slotId
  property string columnPropertyPath: remixDeckPropertyPath + ".cell.columns." + slotId

  AppProperty { id: activeCellY; path: playerPropertyPath + ".active_cell_row" }
  AppProperty { id: activeCellName; path: activeCellPath + ".name" }
  AppProperty { id: activeCellColorId; path: activeCellPath + ".color_id" }
  AppProperty { id: activeCellState; path: activeCellPath + ".state" }
  property color  brightColor: colors.palette(1.0, activeCellColorId.value)

  property string activeCellPath: columnPropertyPath + ".rows." + (activeCellY.value+1)
  property int firstRowInCurrentPage: samplePage.value*4+1

  MappingProperty { id: showVolumeFaders; path: "mapping.settings.showVolumeFaders" }
  MappingProperty { id: showFilterFaders; path: "mapping.settings.showFilterFaders" }
  MappingProperty { id: showSlotIndicators; path: "mapping.settings.showSlotIndicators" }
  MappingProperty { id: sequencerMode; path: deckPropertiesPath + ".sequencerMode" }
  MappingProperty { id: sequencerSlot; path: deckPropertiesPath + ".sequencerSlot" }
  MappingProperty { id: sequencerPage; path: deckPropertiesPath + ".sequencerPage" }

  property int previousSamplePage: 0
  property string samplePageChangeState: "Unchanged"
  AppProperty { id: samplePage; path: remixDeckPropertyPath + ".page"; onValueChanged: {
        samplePageChangeState = "Unchanged"
        if (samplePage.value > previousSamplePage) {
            samplePageChangeState = "Increased"
        }
        else if (samplePage.value < previousSamplePage){
            samplePageChangeState = "Decreased"
        }
        previousSamplePage = samplePage.value
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //REMIX DECK MOD: Top Info Squares
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: slotVolume; path: playerPropertyPath + ".volume" }
  AppProperty { id: slotMuted; path: playerPropertyPath + ".muted" }
  AppProperty { id: slotMeter; path: playerPropertyPath + ".level" }
  AppProperty { id: slotFilter; path: playerPropertyPath + ".filter_value" }
  AppProperty { id: slotFilterOn; path: playerPropertyPath + ".filter_on" }
  AppProperty { id: slotKeylock; path: playerPropertyPath + ".key_lock" }
  AppProperty { id: slotFXSend; path: playerPropertyPath + ".fx_send_on" }

  //FIX, PROPERTIES NOT WORKING
  AppProperty { id: slotMonitor; path: playerPropertyPath + ".monitor.on" } //monitor, monitor_on, monitor.on
  AppProperty { id: slotPunch; path: playerPropertyPath + ".punch_on" }

  Row {
    id: row

    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.left: parent.left
    //anchors.right: showFilterFaders.value ? filledFilterFader.left : parent.right
    anchors.right: filledFilterFader.left
    anchors.rightMargin: row.spacing
    visible: showSlotIndicators.value
    spacing: 4

    //KeyLock
    Rectangle {
        width: (parent.width-row.spacing*3)/4
        height: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? width : 3
        radius: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? 2 : 0
        color: slotKeylock.value ? colors.cyan : colors.colorGrey72

        //opacity:	 (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
        Behavior on height { NumberAnimation { duration: durations.deckTransition  } }

        Text {
            anchors.fill: parent
            anchors.topMargin: 1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "♪"
            font.pixelSize: fonts.smallFontSize
            color: "black"
            visible: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value)
        }
    }

    //FX
    Rectangle {
        width: (parent.width-row.spacing*3)/4
        height: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? width : 3
        radius: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? 2 : 0
        color: slotFXSend.value ? colors.cyan : colors.colorGrey72
        //opacity: (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
        Behavior on height { NumberAnimation { duration: durations.deckTransition  } }

        Text {
            anchors.fill: parent
            anchors.topMargin: 1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "FX"
            font.pixelSize: fonts.smallFontSize
            color: "black"
            visible: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value)
        }
    }

    //Precueing
    Rectangle {
        width: (parent.width-row.spacing*3)/4
        height: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? width : 3
        radius: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? 2 : 0
        color: slotMonitor.value ? colors.cyan : colors.colorGrey72
        Behavior on height { NumberAnimation { duration: durations.deckTransition  } }

        Image {
            id: remix_precue
            anchors.centerIn: parent
            width: 12
            height: 12
            source: "../../../Shared/Images/Remix_Precue.png"
        }
    }

    //Punch
    Rectangle {
        width: (parent.width-row.spacing*3)/4
        height: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? width : 3
        radius: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? 2 : 0
        color: slotPunch.value ? colors.cyan : colors.colorGrey72
        //opacity: (isLoaded && headerState != "small" && hasTrackStyleHeader(deckType)) ? 1 : 0
        Behavior on height { NumberAnimation { duration: durations.deckTransition  } }

        Image {
            id: remix_punch
            anchors.centerIn: parent
            width: 17
            height: 12
            source: "../../../Shared/Images/Remix_Punch.png"
        }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  RMX Deck MOD: FILTER
  //--------------------------------------------------------------------------------------------------------------------

  //unfilled bar
  Rectangle {
    id: unfilledFilterFader
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.right: parent.right
    anchors.rightMargin: 4
    width: 4
    height: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value) ? 22 : 3
    color: ((deckSize == "medium" && sequencerMode.value) || deckSize == "small") && slotFilterOn.value ? colors.cyan : colors.colorGrey16
  }
  //filled bar
  Rectangle {
    id: filledFilterFader
    anchors.top: parent.top
    anchors.topMargin: slotFilter.value > 0.5 ?  unfilledFilterFader.anchors.topMargin + (unfilledFilterFader.height/2 - getFilterFaderHeight(slotFilter.value, unfilledFilterFader.height)) : unfilledFilterFader.anchors.topMargin + unfilledFilterFader.height/2
    anchors.right: parent.right
    anchors.rightMargin: unfilledFilterFader.anchors.rightMargin
    width: 4
    height: getFilterFaderHeight(slotFilter.value, unfilledFilterFader.height)
    color: slotFilterOn.value ? colors.cyan : colors.rgba(0, 64, 88, 255)
    visible: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value)
  }
  //slider position on bar
  Rectangle {
    id: sliderFilter
    anchors.top: parent.top;
    anchors.topMargin: slotFilter.value > 0.5 ? unfilledFilterFader.anchors.topMargin-1 + (unfilledFilterFader.height/2 - getFilterFaderHeight(slotFilter.value, unfilledFilterFader.height)) : unfilledFilterFader.anchors.topMargin-1 + (unfilledFilterFader.height/2 + getFilterFaderHeight(slotFilter.value, unfilledFilterFader.height))
    anchors.right: parent.right
    anchors.rightMargin: unfilledFilterFader.anchors.rightMargin-1
    width: 6
    height: 2
    color: slotFilterOn.value ? "white" : colors.colorGrey72
    visible: deckSize == "large" || (deckSize == "medium" && !sequencerMode.value)
  }

  function getFilterFaderHeight(v,h) {
    if (v == 0.5) return 0;
    if (v < 0.5) return ((0.5 - v) * h);
    return ((v - 0.5) * h);
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  RMX Deck MOD: VOLUME
  //--------------------------------------------------------------------------------------------------------------------

  //show unfilled bar
  Rectangle {
    id: unfilledVolumeFader
    anchors.top: remixDeckWaveform.top
    anchors.bottom: remixDeckWaveform.bottom
    anchors.right: parent.right
    anchors.rightMargin: 4
    width: 4
    color: colors.colorGrey16
    visible: showVolumeFaders.value
  }
  //filled bar
  Column {
    id: filledVolumeFader
    anchors.fill: unfilledVolumeFader
    spacing: 1
    rotation: 180
    clip: true
    visible: showVolumeFaders.value

    Repeater {
        model: parseInt(parseInt(slotMeter.value*1000)/1000*(unfilledVolumeFader.height/2)) //the *1000/1000 is necessary because if not, randomly after triggering a sample, it would meter something "random" aprox. 30 times

        Rectangle {
            width: filledVolumeFader.width
            height: filledVolumeFader.spacing
            color: slotMuted.value ? colors.darkerColor(colors.cyan, 0.25) : colors.cyan
        }
    }
  }
  //slider position on bar
  Rectangle {
    id: sliderVolume
    anchors.top: unfilledVolumeFader.top
    anchors.topMargin: (1-slotVolume.value)*(unfilledVolumeFader.height-sliderVolume.height)
    anchors.right: parent.right
    anchors.rightMargin: unfilledFilterFader.anchors.rightMargin-1
    width: 6
    height: 2
    color: "white"
    visible: (deckSize == "large" || (deckSize == "medium" && !sequencerMode.value)) && showVolumeFaders.value
  }

//--------------------------------------------------------------------------------------------------------------------
// Sample Player
//--------------------------------------------------------------------------------------------------------------------

  //Sample Player Name
  Item { // the headline of the player column. Only shown in "large" state
    id: remixDeckHeadline

    anchors.top: showSlotIndicators.value ? row.bottom : parent.top
    anchors.topMargin: 3
    anchors.left: parent.left
    //anchors.right: showVolumeFaders.value ? unfilledVolumeFader.left : parent.right
    anchors.right: parent.right
    anchors.rightMargin: 4
    height: 12 // set in state
    clip: true

    Text {
        anchors.fill: parent
        text: activeCellName.description
        color: brightColor
        font.pixelSize: fonts.scale(12)
        font.capitalization: Font.AllUppercase
        elide: Text.ElideRight
    }
    Behavior on height { NumberAnimation { duration: durations.deckTransition } }
  }

  //Sample Player Waveform
  SampleStripe { //the remix player waveform with position indicator
    id: remixDeckWaveform
    deckId: slot.deckId
    slotId: slot.slotId
    playerPropertyPath: slot.playerPropertyPath
    activeCellPath: slot.activeCellPath

    anchors.top: remixDeckPlayIndicatorTop.bottom
    anchors.topMargin: 1 //pixel between waveform stripe and top indicator bar
    anchors.left: parent.left
    anchors.right: showVolumeFaders.value ? unfilledVolumeFader.left : parent.right
    anchors.rightMargin: showVolumeFaders.value ? 4 : 0
    height: smallHeigth //set in state

    readonly property int smallHeigth: 24
    readonly property int bigHeight: 44 // 65

    Behavior on height { NumberAnimation { duration: durations.deckTransition } }
    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition } }
  }

//--------------------------------------------------------------------------------------------------------------------
// Samples Grid Container
//--------------------------------------------------------------------------------------------------------------------

  Item {
    id: remixSampleContainer
    clip: true
    anchors.top: remixDeckWaveform.bottom
    anchors.topMargin: 7
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0 //3
    anchors.left: parent.left
    anchors.right: parent.right
    //anchors.rightMargin: 10 to let some space for the filter/volume faders
    visible: !sequencerMode.value
    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition  } }

    Column {
        id: remixDeckSamples
        anchors.fill: parent
        anchors.bottomMargin: 0
        spacing: 3 //7 for when only 2 samples
        clip: true

        Repeater {
            id: sampleColumn
            model: 4
            Sample {
                id: sample;
                deckId: slot.deckId
                slotId: slot.slotId
                cellId: firstRowInCurrentPage + index
                samplePropertyPath: columnPropertyPath + ".rows." +  (firstRowInCurrentPage + index);
                //anchors.topMargin: 0
                anchors.bottomMargin: 0
                height: remixSampleContainer.height/4 - remixDeckSamples.spacing
                width: parent.width
                visible: !sequencerMode.value
            }
        }
    }
  }

    Item {
    id: sampleRowShift
    state: samplePageChangeState
    states: [
        State {
            name: "Unchanged"
        },
        State {
            name: "Increased"
        },
        State {
            name: "Decreased"
        }
    ]
    transitions: [
        Transition {
            to: "Increased"
            SequentialAnimation {
                NumberAnimation { target: sampleColumn; property: "model"; to: 4 ; duration: 0}
                NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; from: 0; to: -remixSampleContainer.height; duration: durations.deckTransition }
                ParallelAnimation {
                    NumberAnimation { target: sampleColumn; property: "model"; to: 4 ; duration: 0}
                    NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; to: 0 ; duration: 0}
                }
            }
        },
        Transition {
            to: "Decreased"
            SequentialAnimation {
                NumberAnimation { target: sampleColumn; property: "model"; to: 4 ; duration: 0}
                NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; from: -remixSampleContainer.height; to: 0; duration: durations.deckTransition }
                ParallelAnimation {
                    NumberAnimation { target: sampleColumn; property: "model"; to: 4 ; duration: 0}
                    NumberAnimation { target: remixDeckSamples; property: "anchors.topMargin"; to: 0 ; duration: 0}
                }
            }
        }
    ]
  }

//--------------------------------------------------------------------------------------------------------------------
// Step Sequencer
//--------------------------------------------------------------------------------------------------------------------

  StepSequencer {
    active: sequencerMode.value == true && sequencerSlot.value == (index+1) // == true OR ELSE it will show an error message saying unable to assign undefined to bool
    deckId: slot.deckId
    remixDeckPropertyPath: slot.remixDeckPropertyPath
    playerPropertyPath: slot.playerPropertyPath
    activeCellPath: slot.activeCellPath

    anchors.top: remixDeckWaveform.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: deckSize == "large" ? 3 : 1
    anchors.bottomMargin: 1
    visible: sequencerMode.value == true && (deckSize != "small") // == true OR ELSE it will show an error message saying unable to assign undefined to bool
    clip: true
  }

  //Step Sequencer Frame
  Rectangle {
    id: sequencerFrame
    anchors.fill: parent
    anchors.topMargin: 0 //set in state
    anchors.bottomMargin: 1
    color: "transparent"
    border.width:1
    border.color: brightColor
    visible: sequencerMode.value == true && sequencerSlot.value == (index+1) //&& bottomInfoDetails.state != "FX" && bottomInfoDetails.state != "MIDI" per a que no es vegi si no s'esta controlant si es controla els FX3/4 o la midi
    // == true OR ELSE it will show an error message saying unable to assign undefined to bool
  }

//--------------------------------------------------------------------------------------------------------------------
// Color bar above the waveform showing the currently active cell
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: remixDeckPlayIndicatorTop
    anchors.top: remixDeckHeadline.bottom
    anchors.topMargin: 3 // set in state
    anchors.left: parent.left
    //anchors.right: showVolumeFaders.value ? unfilledVolumeFader.left : parent.right
    anchors.right: parent.right
    anchors.rightMargin: 4
    height: 3
    color: brightColor
    Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition } }
  }

  //Upwards indicator (for playing deck out of focus)
  Traktor.Polygon {
    id : arrowUpBg
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: remixDeckPlayIndicatorTop.bottom
    anchors.bottomMargin: -2
    points: [ Qt.point(0, 0), Qt.point(8.5, 0) , Qt.point(4, 4.5)]
    color: brightColor

    border.width: 3
    border.color: colors.colorBlack

    antialiasing: false
    visible: !sequencerMode.value && ((activeCellY.value < firstRowInCurrentPage-1) && (activeCellState.description == "Playing")) ? true : false
    rotation: 180
  }

  //Downwards indicator (for playing deck out of focus)
  Traktor.Polygon {
    id : arrowDownBg
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: remixDeckPlayIndicatorTop.bottom
    anchors.bottomMargin: -3
    points: [ Qt.point(0, 0), Qt.point(8.5, 0) , Qt.point(4, 4.5)]
    color: brightColor
    border.width: 3
    border.color: colors.colorBlack
    antialiasing: false
    visible: !sequencerMode.value && ((activeCellY.value >= firstRowInCurrentPage+3) && (activeCellState.description == "Playing")) ? true : false
  }

//--------------------------------------------------------------------------------------------------------------------
// DeckSize States
//--------------------------------------------------------------------------------------------------------------------

  state: deckSize
  states: [
    State {
      name: "small"
      PropertyChanges {target: remixDeckWaveform; height: remixDeckWaveform.smallHeigth}
      PropertyChanges {target: remixSampleContainer; height: 0; visible: false}
      PropertyChanges {target: remixDeckHeadline; height: 0}
      PropertyChanges {target: remixDeckPlayIndicatorTop; anchors.topMargin: 1}
      PropertyChanges {target: sequencerFrame; anchors.topMargin: 0}
    },
    State {
      name: "medium"
      PropertyChanges {target: remixDeckWaveform; height: remixDeckWaveform.smallHeigth; anchors.topMargin: 1}
      PropertyChanges {target: remixSampleContainer; anchors.topMargin: 7; visible: true}
      PropertyChanges {target: remixDeckHeadline; height: 0}
      PropertyChanges {target: remixDeckPlayIndicatorTop; anchors.topMargin: 1}
      PropertyChanges {target: sequencerFrame; anchors.topMargin: 0}
    },
    State {
      name: "large"
      PropertyChanges {target: remixDeckWaveform; height: remixDeckWaveform.bigHeight; anchors.topMargin: 1}
      PropertyChanges {target: remixSampleContainer; anchors.topMargin: 7; visible: true}
      PropertyChanges {target: remixDeckHeadline; height: 12}
      PropertyChanges {target: remixDeckPlayIndicatorTop; anchors.topMargin: 1}
      PropertyChanges {target: sequencerFrame; anchors.topMargin: 0}
    }
  ]
}
