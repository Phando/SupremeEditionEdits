import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../Shared/Overlays'
import '../../../Shared/Widgets' as Widgets

FullscreenOverlay {
    id: settings

    anchors.fill: parent
    clip: true

    readonly property bool isTraktorS5: screen.flavor == ScreenFlavor.S5
    readonly property bool isTraktorS8: screen.flavor == ScreenFlavor.S8
    readonly property bool isTraktorD2: screen.flavor == ScreenFlavor.D2

//------------------------------------------------------------------------------------------------------------------
// SUPREME EDITION
//------------------------------------------------------------------------------------------------------------------

    Text{
        id: header
        font.family: "Pragmatica"
        font.pixelSize: 22
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        color: colors.cyan
        text: "Supreme Edition " + version.beta
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
        anchors.topMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 15
        height: 120
        width: 140
        clip: true

        property int selectedIndex: 0

        model: ["(NW) Traktor Settings", isTraktorS5  ? "Traktor S5 Settings" : (isTraktorS8 ? "Traktor S8 Settings" : "Traktor D2 Settings"), "Map Settings", "Display Settings", "Other Settings"]
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
                color: firstIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
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
        anchors.topMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 170
        height: 120
        width: 140
        visible: firstIndex != 0
        clip: true

        property int selectedIndex: 0

        readonly property variant traktorNames: ["Audio Setup", "Output Routing", "Input Routing", "External Sync", "Timecode Setup", "Loading", "Transport", "Decks Layout", "Track Decks", "Remix Decks", "Mixer", "Global Settings", "Effects", "Mix Recorder", "Loop Recorder", "Browser Details", "File Management", "Analyze Options"]
        readonly property variant s8Names: ["Touch Controls", "Touchstrip", "LEDs", "MIDI"]
        readonly property variant s5Names: ["Touch Controls", "Touchstrip", "LEDs", "Stem Controls"]
        readonly property variant mapNames: ["Play Button", "Cue Button", "Sync Button", "Browse Encoder", isTraktorS5 ? "Loop Encoder" : "FX Select Button", isTraktorS5 ? "Hotcue Button" : "Loop Button", "Freeze Button", "Pads", isTraktorD2 ? "D2 Buttons" : "Faders" ]
        readonly property variant displayNames: ["General", "Browser", "Track/Stem Deck", "Remix Deck"]
        readonly property variant otherNames: ["Timers", "Fixes", "Mods"]

        function secondSettingsListNames(index){
            if (index == 1) return traktorNames
            else if (index == 2 && isTraktorS5) return s5Names
            else if (index == 2 && !isTraktorS5) return s8Names
            else if (index == 3) return mapNames
            else if (index == 4) return displayNames
            else if (index == 5) return otherNames
        }

        model: secondSettingsListNames(firstIndex)
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
                color: secondIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
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
        anchors.topMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 325
        height: 120
        width: 140
        visible: secondIndex != 0
        clip: true

        property int selectedIndex: 0

        //Traktor Settings
        readonly property variant audioDevices: [""]
        readonly property variant transportNames: ["Sync Mode"]

        //Controller Settings
        readonly property variant s8TouchControlsNames: ["Browser", "Top FX Controls", "Performance Controls"]
        readonly property variant s5TouchControlsNames: ["Browser", "Top FX Controls"]
        readonly property variant touchstripNames: ["Nudge Sensivity", "Scratch Sensivity", "Touchstrip Mode"]
        readonly property variant ledsNames: ["Brightness"]
        readonly property variant midiNames: ["MIDI Controls"]
        readonly property variant stemNames: ["Stem Select", "Stem Loading"]

        //Map Settings
        readonly property variant playNames: ["Play", "Shift + Play", "Blinker", "V.Break Settings"]
        readonly property variant cueNames: ["Cue","Shift + Cue", "Blinker"]
        readonly property variant syncNames: ["Key Sync"]
        readonly property variant browseEncoderNames: ["Shift + Push Browse", "Browse", "Shift + Browse", "BPM Step", "Tempo Step"]
        readonly property variant fxSelectNames: ["FX Select", "Shift + FX Select"] //S8/D2 Only
        readonly property variant loopEncoderNames: ["Loop Encoder", "Shift + Loop Encoder"] //S5 Only
        readonly property variant loopNames: ["Loop", "Shift + Loop"] //S8/D2 Only
        readonly property variant hotcueNames: ["Shift + Hotcue"] //S5 Only
        readonly property variant freezeNames: ["Freeze", "Shift + Freeze"]
        readonly property variant padsNames: ["Slot Selector Mode", "Hotcues Play Mode", "Hotcue Colors"]
        readonly property variant fadersNames: ["Fader Start"]
        readonly property variant d2Names: ["D2 Deck Buttons"]

        //Display Settings
        readonly property variant deckGeneralNames: ["Theme", "Panels", "Bright Mode (BETA)", "Top Left Corner"]
        readonly property variant browserNames: ["Related Screens", "Related Browsers", "Browser on Touch", "Rows in Browser", "Displayed Info", "Previously Played", "BPM Match Guides", "Key Match Guides", "Colored Keys", "Footer Info"]
        readonly property variant trackNames: ["Waveform Options", "Grid Options", "Stripe Options", "Performance Panel", "Beat Counter Settings", "Beat/Phase Widget", "Key Options"]
        readonly property variant remixNames: ["Volume Fader", "Filter Fader", "Slot Indicators"]

        //Other Settings
        readonly property variant timersNames: ["Browser View", "BPM/Key Overlay", "Mixer FX Overlay", "HotcueType Overlay", "Side Buttons Overlay"]
        readonly property variant fixesNames: ["BPM Controls", "Hotcue Triggering"]
        readonly property variant modsNames: ["Only focused controls", "Hotcues Play Mode", "Beatmatch Practice", "Autoenable Flux", "AutoZoom Edit Mode", "Shift Mode"]
        readonly property variant modsNamesD2: ["Only focused controls", "Hotcues Play Mode", "Beatmatch Practice", "Autoenable Flux", "AutoZoom Edit Mode"]

        function thirdSettingsListNames(firstIndex, secondIndex){
            if (firstIndex == 1) { //Traktor Settings
                if (secondIndex == 1) return audioDevices
                else if (secondIndex == 7) return transportNames
            }
            else if (firstIndex == 2) { //Controller Settings
                if (secondIndex == 1) return isTraktorS5 ? s5TouchControlsNames : s8TouchControlsNames
                else if (secondIndex == 2) return touchstripNames
                else if (secondIndex == 3) return ledsNames
                else if (secondIndex == 4) return isTraktorS5 ? stemNames : midiNames
            }
            else if (firstIndex == 3) { //Map Settings
                if (secondIndex == 1) return playNames
                else if (secondIndex == 2) return cueNames
                else if (secondIndex == 3) return syncNames
                else if (secondIndex == 4) return browseEncoderNames
                else if (secondIndex == 5) return isTraktorS5 ? loopEncoderNames : fxSelectNames
                else if (secondIndex == 6) return isTraktorS5 ? hotcueNames : loopNames
                else if (secondIndex == 7) return freezeNames
                else if (secondIndex == 8) return padsNames
                else if (secondIndex == 9 && !isTraktorD2) return fadersNames
                else if (secondIndex == 9 && isTraktorD2) return d2Names
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
                else if (secondIndex == 3) return isTraktorD2 ? modsNamesD2 : modsNames
            }
        }

        model: thirdSettingsListNames(firstIndex, secondIndex)
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
                color: thirdIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
                text: modelData
            }

            Component.onCompleted: {
                z = -1
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// Divider
//------------------------------------------------------------------------------------------------------------------

    Text{
        id: divider
        font.family: "Pragmatica"
        font.pixelSize: 15
        anchors.top: parent.top
        anchors.topMargin: 175
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        color: colors.cyan
        text: "*********************************************************"
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS GRID
//------------------------------------------------------------------------------------------------------------------

    SettingsGrid {
        id: settingsGrid
        anchors.fill: parent
        anchors.topMargin: 190
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
        visible: thirdIndex != 0

        text: settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 3, settingsGrid.currentIndex)
        font.family: "Pragmatica"
        font.pixelSize: fonts.middleFontSize
        horizontalAlignment: Text.AlignHCenter
    }
    */

    //Properties Description Text
    Widgets.ScrollingText {
        id: scrollingSettingsText
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
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
        visible: thirdIndex != 0
    }

    //------------------------------------------------------------------------------------------------------------------
    // SETTINGS NAVIGATION
    //------------------------------------------------------------------------------------------------------------------

    property int prePreferencesNavMenuValue: 0
    MappingProperty { id: settingsNavigation; path: propertiesPath + ".preferencesNavigation";
        onValueChanged: {
            var delta = settingsNavigation.value - prePreferencesNavMenuValue;
            prePreferencesNavMenuValue = settingsNavigation.value;

            if (firstIndex == 0) {
                var index = firstSettingsList.currentIndex + delta
                firstSettingsList.currentIndex = utils.clamp(index, 0, firstSettingsList.count-1)
            }
            else {
                if (secondIndex == 0) {
                    var index = secondSettingsList.currentIndex + delta
                    secondSettingsList.currentIndex = utils.clamp(index, 0, secondSettingsList.count-1)
                }
                else {
                    if (thirdIndex == 0) {
                        var index = thirdSettingsList.currentIndex + delta
                        thirdSettingsList.currentIndex = utils.clamp(index, 0, thirdSettingsList.count-1)
                    }
                    /*
                    else if (integerEditor.value) {
                        settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)
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
            if (thirdIndex != 0 && integerEditor.value == false) {thirdIndex = 0; settingsGrid.currentIndex = 0}
            else if (secondIndex != 0 && thirdIndex == 0) secondIndex = 0;
            else if (firstIndex != 0 && secondIndex == 0) {firstIndex = 0; backBright.value = false}
        }
    }

    MappingProperty { id: settingsPush; path: propertiesPath + ".preferencesPush";
        onValueChanged: {
            if (firstIndex == 0) {firstIndex = firstSettingsList.currentIndex+1; backBright.value = true}
            else if (secondIndex == 0) secondIndex = secondSettingsList.currentIndex+1;
            else if (thirdIndex == 0) {thirdIndex = thirdSettingsList.currentIndex+1; settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)}
            else {
                settingsGrid.updateSettingsParameters(firstIndex, secondIndex, thirdIndex)
            }
        }
    }
}
