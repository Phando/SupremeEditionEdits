import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../Shared/Overlays'
import '../../../Shared/Widgets' as Widgets

FullscreenOverlay {
    id: settings

    anchors.fill: parent
    clip: true

//------------------------------------------------------------------------------------------------------------------
// SUPREME EDITION
//------------------------------------------------------------------------------------------------------------------

  Text{
    id: header
    font.family: "Pragmatica"
    font.pixelSize: 18
    anchors.top: parent.top
    anchors.topMargin: 15
    anchors.fill: parent
    horizontalAlignment: Text.AlignHCenter
    color: colors.cyan
    text: "Supreme Edition 3.0"
  }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS
//------------------------------------------------------------------------------------------------------------------

  property int firstIndex: firstSettingsList.selectedIndex ? firstSettingsList.selectedIndex : 0
  property int secondIndex: secondSettingsList.selectedIndex ? secondSettingsList.selectedIndex : 0
  property int thirdIndex: thirdSettingsList.selectedIndex ? thirdSettingsList.selectedIndex : 0

  //First Column Setting List
  ListView {
    id: firstSettingsList
    anchors.top: parent.top
    anchors.topMargin: parent.height*0.3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width*0.9
    visible: firstSettingsList.selectedIndex == 0
    clip: true

    property int selectedIndex: 0

    model: ["(NW) Traktor Settings", "Traktor S4MK3 Settings", "Map Settings", "Display Settings", "Other Settings"]
    delegate:
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        height: 20
        width: parent.width
        property bool isCurrentItem: ListView.isCurrentItem

        Text {
            id: firstColumnText
            anchors.left: parent.left
            font.pixelSize: 15
            //font.capitalization: Font.AllUppercase
            color: firstSettingsList.selectedIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
            text: modelData
        }

        Component.onCompleted: {
            z = -1
        }
    }
  }

  //Second Column Setting List
  ListView {
    id: secondSettingsList
    anchors.top: parent.top
    anchors.topMargin: parent.height*0.3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width*0.9
    visible: firstSettingsList.selectedIndex != 0 && secondSettingsList.selectedIndex == 0
    clip: true

    property int selectedIndex: 0

    readonly property variant traktorNames: ["Audio Setup", "Output Routing", "Input Routing", "External Sync", "Timecode Setup", "Loading", "Transport", "Decks Layout", "Track Decks", "Remix Decks", "Mixer", "Global Settings", "Effects", "Mix Recorder", "Loop Recorder", "Browser Details", "File Management", "Analyze Options"]
    readonly property variant s4Names: ["Transport", "Haptic Drive", "TT Mode", "LEDs"]
    readonly property variant mapNames: ["Play Button", "Cue Button", "Sync Button", "Browse Encoder", "Loop Size Encoder", "Hotcues Button", "Stems Button", "Pads", "Faders" ]
    readonly property variant displayNames: ["General", "Browser", "Track/Stem Deck", "Remix Deck"]
    readonly property variant otherNames: ["Timers", "Fixes", "Mods"]

    function secondSettingsListNames(index){
        if (index == 1) return traktorNames
        else if (index == 2) return s4Names
        else if (index == 3) return mapNames
        else if (index == 4) return displayNames
        else if (index == 5) return otherNames
    }

    model: secondSettingsListNames(firstSettingsList.selectedIndex)
    delegate:
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        height: 20
        width: parent.width
        property bool isCurrentItem: ListView.isCurrentItem

        Text {
            id: secondColumnText
            anchors.left: parent.left
            font.pixelSize: 15
            color: secondSettingsList.selectedIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
            text: modelData
        }

        Component.onCompleted: {
            z = -1
        }
    }
  }

  //Third Column Setting List
  ListView {
    id: thirdSettingsList
    anchors.top: parent.top
    anchors.topMargin: parent.height*0.3
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 10
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width*0.9
    visible: secondSettingsList.selectedIndex != 0 && thirdSettingsList.selectedIndex == 0
    clip: true

    property int selectedIndex: 0

    //Traktor Settings
    readonly property variant audioDevices: [""]
    readonly property variant transportNames: ["Sync Mode"]

    //S4 MK3 Settings
    readonly property variant s4transportNames: ["Tempo Faders"]
    readonly property variant hapticDriveNames: ["Nudge Ticks", "Jogwheel Tension", "Haptic Hotcues"]
    readonly property variant ttmodeNames: ["Base Speed"]
    readonly property variant ledsNames: ["Brightness", "Deck LEDs"]

    //Map Settings
    readonly property variant playNames: ["Play", "Shift + Play", "Blinker", "V.Break Settings"]
    readonly property variant cueNames: ["Cue","Shift + Cue", "Blinker"]
    readonly property variant syncNames: ["Key Sync"]
    readonly property variant browseEncoderNames: ["Shift + Push Browse", "Browse", "Shift + Browse"] //"BPM Step", "Tempo Step" not necessary since there is the tempo fader
    readonly property variant loopSizeEncoderNames: ["Shift + Loop Size Push"]
    readonly property variant hotcueNames: ["Shift + Hotcues"]
    readonly property variant stemsNames: ["Stems", "Shift + Stems"]
    readonly property variant padsNames: ["Slot Selector Mode", "Hotcues Play Mode", "Hotcue Colors"]
    readonly property variant fadersNames: ["Fader Start"]

    //Display Settings
    readonly property variant deckGeneralNames: ["Theme", "Bright Mode (BETA)"]
    readonly property variant browserNames: ["Browser In Screens", "Related Screens", "Related Browsers", "Browser on Touch", "Rows in Browser", "Displayed Info", "Previously Played", "BPM Match Guides", "Key Match Guides", "Colored Keys"]
    readonly property variant trackNames: ["Waveform Options", "Grid Options", "Stripe Options", "Performance Panel", "Beat Counter Settings", "Beat/Phase Widget", "Key Options"]
    readonly property variant remixNames: ["Slot Indicators", "Filter Fader", "Volume Fader"]

    //Other Settings
    readonly property variant timersNames: ["Browser View", "BPM/Key Overlay", "Mixer FX Overlay", "HotcueType Overlay", "Side Buttons Overlay"]
    readonly property variant fixesNames: ["Hotcue Triggering"]
    readonly property variant modsNames: ["Only focused controls", "Hotcues Play Mode", "Beatmatch Practice", "Autoenable Flux", "AutoZoom Edit Mode", "Shift Mode"]

    function thirdSettingsListNames(firstIndex, secondIndex){
        if (firstIndex == 1) { //Traktor Settings
            if (secondIndex == 1) return audioDevices
            else if (secondIndex == 7) return transportNames
        }
        else if (firstIndex == 2) { //S4 Settings
            if (secondIndex == 1) return s4transportNames
            else if (secondIndex == 2) return hapticDriveNames
            else if (secondIndex == 3) return ttmodeNames
            else if (secondIndex == 4) return ledsNames
        }
        else if (firstIndex == 3) { //Map Settings
            if (secondIndex == 1) return playNames
            else if (secondIndex == 2) return cueNames
            else if (secondIndex == 3) return syncNames
            else if (secondIndex == 4) return browseEncoderNames
            else if (secondIndex == 5) return loopSizeEncoderNames
            else if (secondIndex == 6) return hotcueNames
            else if (secondIndex == 7) return stemsNames
            else if (secondIndex == 8) return padsNames
            else if (secondIndex == 9) return fadersNames
        }
        else if (firstIndex == 4) { //Display Settings
            if (secondIndex == 1) return deckGeneralNames
            else if (secondIndex == 2) return browserNames
            else if (secondIndex == 3) return trackNames
            else if (secondIndex == 4) return remixNames
        }
        else if (firstIndex == 5) { //Other Settings
            if (secondIndex == 1) return timersNames
            else if (secondIndex == 2) return fixesNames
            else if (secondIndex == 3) return modsNames
        }
    }

    model: thirdSettingsListNames(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex)
    delegate:
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        height: 20 //delegateHeight // item (= line) height
        width: parent.width
        property bool isCurrentItem: ListView.isCurrentItem

        Text {
            id: thirdColumnText
            anchors.left: parent.left
            font.pixelSize: 15
            color: thirdSettingsList.selectedIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
            text: modelData
        }

        Component.onCompleted: {
            z = -1
        }
    }
  }

//------------------------------------------------------------------------------------------------------------------
// PREFERENCES GRID
//------------------------------------------------------------------------------------------------------------------

  SettingsGrid {
    id: settingsGrid
    anchors.fill: parent
    anchors.topMargin: parent.height*0.3
  }

  //Properties Header Text
  readonly property variant thirdSettingName: thirdSettingsList.thirdSettingsListNames(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex) ? thirdSettingsList.thirdSettingsListNames(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex) : []
  Text{
    id: divider
    font.family: "Pragmatica"
    font.pixelSize: 15
    anchors.top: parent.top
    anchors.topMargin: 45
    anchors.fill: parent
    horizontalAlignment: Text.AlignHCenter
    color: "white" //colors.cyan
    text: thirdSettingName[thirdSettingsList.selectedIndex-1] ? thirdSettingName[thirdSettingsList.selectedIndex-1] : ""
    visible: thirdSettingsList.selectedIndex != 0
  }

/*
  //Properties Description Text
  Text{
    id: preference_descriptor
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 20
    anchors.left: parent.left
    anchors.right: parent.right
    color: colors.cyan
    visible: thirdSettingsList.selectedIndex != 0

    text: settingsGrid.updateSettings(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex, thirdSettingsList.selectedIndex, 3, settingsGrid.currentIndex)
    font.family: "Pragmatica"
    font.pixelSize: fonts.middleFontSize
    horizontalAlignment: Text.AlignHCenter
  }
*/

  //Properties Description Text
  Widgets.ScrollingText {
    id: scrollingSettingsText
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 20
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5
    height: 20
    textTopMargin: -1
    textFontSize: fonts.middleFontSize
    textColor: colors.cyan
    containerColor: "transparent"
    marqueeText: (settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 3, settingsGrid.currentIndex) == undefined) ? "" : settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 3, settingsGrid.currentIndex)
    doScroll: true
    centered: true
    visible: thirdSettingsList.selectedIndex != 0
  }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS NAVIGATION
//------------------------------------------------------------------------------------------------------------------

  property int prePreferencesNavMenuValue: 0
  MappingProperty { id: settingsNavigation; path: propertiesPath + ".preferencesNavigation";
    onValueChanged: {
        var delta = settingsNavigation.value - prePreferencesNavMenuValue;
        prePreferencesNavMenuValue = settingsNavigation.value;

        if (firstSettingsList.selectedIndex == 0) {
            var index = firstSettingsList.currentIndex + delta
            firstSettingsList.currentIndex = utils.clamp(index, 0, firstSettingsList.count-1)
        }
        else {
            if (secondSettingsList.selectedIndex == 0) {
                var index = secondSettingsList.currentIndex + delta
                secondSettingsList.currentIndex = utils.clamp(index, 0, secondSettingsList.count-1)
            }
            else {
                if (thirdSettingsList.selectedIndex == 0) {
                    var index = thirdSettingsList.currentIndex + delta
                    thirdSettingsList.currentIndex = utils.clamp(index, 0, thirdSettingsList.count-1)
                }
/*
                else if (integerEditor.value) {
                    settingsGrid.updateSettings(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex, thirdSettingsList.selectedIndex, 0, 0)
                }
*/
            }
        }
    }
  }

  MappingProperty { id: integerEditor; path: propertiesPath + ".integer_editor" }
  MappingProperty { id: backBright; path: propertiesPath + ".backBright" }
  MappingProperty { id: settingsBack; path: propertiesPath + ".preferencesBack";
    onValueChanged: {
        if (thirdSettingsList.selectedIndex != 0 && integerEditor.value == false) {thirdSettingsList.selectedIndex = 0; settingsGrid.currentIndex = 0}
        else if (secondSettingsList.selectedIndex != 0 && thirdSettingsList.selectedIndex == 0) secondSettingsList.selectedIndex = 0;
        else if (firstSettingsList.selectedIndex != 0 && secondSettingsList.selectedIndex == 0) {firstSettingsList.selectedIndex = 0; backBright.value = false}
    }
  }

  MappingProperty { id: settingsPush; path: propertiesPath + ".preferencesPush";
    onValueChanged: {
        if (firstSettingsList.selectedIndex == 0) {firstSettingsList.selectedIndex = firstSettingsList.currentIndex+1; backBright.value = true}
        else if (secondSettingsList.selectedIndex == 0) secondSettingsList.selectedIndex = secondSettingsList.currentIndex+1;
        else if (thirdSettingsList.selectedIndex == 0) {thirdSettingsList.selectedIndex = thirdSettingsList.currentIndex+1; settingsGrid.updateSettings(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex, thirdSettingsList.selectedIndex, 0, 0)}
        else {
            settingsGrid.updateSettingsParameters(firstSettingsList.selectedIndex, secondSettingsList.selectedIndex, thirdSettingsList.selectedIndex)
        }
    }
  }
}
