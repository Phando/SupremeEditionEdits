import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
  id: settingsGrid

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR SETTINGS
//------------------------------------------------------------------------------------------------------------------

  //Settings - Transport
  MappingProperty { id: relativeTempoFaders; path: "mapping.settings.tempo_fader_relative" }

  //Settings - Haptic Drive
  MappingProperty { id: ticksOnNudging; path: "mapping.settings.haptic.ticks_density" }
  MappingProperty { id: jogwheelTension; path: "mapping.settings.haptic.tension"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: hapticHotcues; path: "mapping.settings.haptic.hotcues_enabled" }

  //Settings - TT Mode
  MappingProperty { id: baseSpeed; path: "mapping.settings.haptic.platter_speed" }

  //LEDs
  MappingProperty { id: onBrightness; path: "mapping.settings.led_on_brightness"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: dimmedBrightness; path: "mapping.settings.led_dimmed_percentage"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)}  }

  MappingProperty { id: deckALED; path: "mapping.settings.1.deckColor"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: deckBLED; path: "mapping.settings.2.deckColor"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: deckCLED; path: "mapping.settings.3.deckColor"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: deckDLED; path: "mapping.settings.4.deckColor"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

//------------------------------------------------------------------------------------------------------------------
// MAPPING SETTINGS
//------------------------------------------------------------------------------------------------------------------

  //Shift
  MappingProperty { id: globalShiftEnabled; path: "mapping.settings.globalShift" }

  //Transport buttons
  MappingProperty { id: playButton; path: "mapping.settings.playButton" } //0: Play/Pause, 1: Vinyl Break
  MappingProperty { id: shiftPlayButton; path: "mapping.settings.shiftPlayButton" } //0: TimeCode, 1: Vinyl Break, 2: KeyLock (preserve), 3: KeyLock (reset)
  MappingProperty { id: playBlinker; path: "mapping.settings.playBlinker" }

  MappingProperty { id: cueButton; path: "mapping.settings.cueButton" } //0: Cue, 1: CUP, 2: Restart, 3: Pioneer (CUE + CUP)
  MappingProperty { id: shiftCueButton; path: "mapping.settings.shiftCueButton" } //0: Cue, 1: CUP, 2: Restart, 3: Pioneer (CUE + CUP)
  MappingProperty { id: cueBlinker; path: "mapping.settings.cueBlinker" }

  MappingProperty { id: shiftSyncButton; path: "mapping.settings.shiftSyncButton" }

  //Vinyl break
  MappingProperty { id: vinylBreakInBeats; path: "mapping.settings.vinylBreakInBeats" }
  MappingProperty { id: vinylBreakDurationInBeats; path: "mapping.settings.vinylBreakDurationInBeats"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: vinylBreakDurationInSeconds; path: "mapping.settings.vinylBreakDurationInSeconds"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

  //Key Sync
  MappingProperty { id: fuzzyKeySync; path: "mapping.settings.fuzzyKeySync" }
  MappingProperty { id: useKeyText; path: "mapping.settings.useKeyText" }

  //Encoders
  MappingProperty { id: browseEncoder; path: "mapping.settings.browseEncoder" } //0: Coarse BPM, 1: Fine BPM, 2: Controller Zoom, 3: TP3 Zoom
  MappingProperty { id: shiftBrowseEncoder; path: "mapping.settings.shiftBrowseEncoder" } //0: Coarse BPM, 1: Fine BPM, 2: Controller Zoom, 3: TP3 Zoom
  MappingProperty { id: shiftBrowsePush; path: "mapping.settings.shiftBrowsePush" } //0: Disabled, 1: Instant Doubles, 2: Load Next Track, 3: Load Previous Track

  MappingProperty { id: shiftPushLoopSize; path: "mapping.settings.shiftPushLoopSize" }

  //Pads - Mode Selector
  MappingProperty { id: shiftHotcueButton; path: "mapping.settings.shiftHotcueButton" }

  MappingProperty { id: stemsButton; path: "mapping.settings.stemsButton" }
  MappingProperty { id: shiftStemsButton; path: "mapping.settings.shiftStemsButton" }

  //Pads - Loop Mode
  MappingProperty { id: enableFluxOnLoopMode; path: "mapping.settings.enableFluxOnLoopMode" }

  //Pads - Loop Roll Mode
  MappingProperty { id: enableFluxOnLoopRoll; path: "mapping.settings.enableFluxOnLoopRoll" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size1" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size2" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size3" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size4" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size5" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size6" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size7" }
  MappingProperty { path: "mapping.settings.pad_loop_roll_size8" }

  //Pads - Others
  MappingProperty { id: slotSelectorMode; path: "mapping.settings.slotSelectorMode" }
  MappingProperty { id: hotcuesPlayMode; path: "mapping.settings.hotcuesPlayMode" }

  //Mods
  MappingProperty { id: fixBPMControl; path: "mapping.settings.fixBPMControl" }
  MappingProperty { id: fixHotcueTrigger; path: "mapping.settings.fixHotcueTrigger" }
  MappingProperty { id: beatmatchPracticeMode; path: "mapping.state.beatmatchPracticeMode" }

  //Timers
  MappingProperty { id: browserTimer; path: "mapping.settings.browserTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: overlayTimer; path: "mapping.settings.overlayTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: hotcueTypeTimer; path: "mapping.settings.hotcueTypeTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

  //Other Settings
  MappingProperty { id: traktorRelatedBrowser; path: "mapping.settings.traktorRelatedBrowser" }
  MappingProperty { id: autoZoomTPwaveform; path: "mapping.settings.autoZoomTPwaveform" }
  MappingProperty { id: onlyFocusedDeck; path: "mapping.settings.onlyFocusedDeck" }

//------------------------------------------------------------------------------------------------------------------
// DISPLAY SETTINGS
//------------------------------------------------------------------------------------------------------------------

  //General
  MappingProperty { id: theme; path: "mapping.settings.theme" }
  MappingProperty { id: brightMode; path: "mapping.settings.brightMode" }
  MappingProperty { id: topLeftCorner; path: "mapping.settings.topLeftCorner" }
  //MappingProperty { id: topRightCorner; path: "mapping.settings.topRightCorner" }
  MappingProperty { id: displayCamelotKey; path: "mapping.settings.displayCamelotKey" }
  //MappingProperty { id: displayKeyText; path: "mapping.settings.displayKeyText" }
  MappingProperty { id: displayActive; path: "mapping.settings.displayActive" }

  //General - Top&Bottom Panel
  MappingProperty { id: showAssignedFXOverlays; path: "mapping.settings.show_assigned_fx_overlays" }
  MappingProperty { id: hideBottomPanel; path: "mapping.settings.hide_bottom_panel" }

  //Browser
  MappingProperty { id: browserRows; path: "mapping.settings.browserRows"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: browserFooterInfo; path: "mapping.settings.browserFooterInfo" }
  MappingProperty { id: showTracksPlayedDarker; path: "mapping.settings.showTracksPlayedDarker" }
  MappingProperty { id: independentScreenBrowser; path: "mapping.settings.independentScreenBrowser" }

  //Browser - Displayed info
  MappingProperty { id: browserAlbum; path: "mapping.settings.browserAlbum" }
  MappingProperty { id: browserArtist; path: "mapping.settings.browserArtist" }
  MappingProperty { id: browserBPM; path: "mapping.settings.browserBPM" }
  MappingProperty { id: browserKey; path: "mapping.settings.browserKey" }
  MappingProperty { id: browserRating; path: "mapping.settings.browserRating" }

  //Browser - BPM
  MappingProperty { id: highlightMatchRecommendations; path: "mapping.settings.highlightMatchRecommendations" }
  MappingProperty { id: perfectTempoMatchLimit; path: "mapping.settings.perfectTempoMatchLimit"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: regularTempoMatchLimit; path: "mapping.settings.regularTempoMatchLimit"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

  //Browser - Key
  MappingProperty { id: keyColorsInBrowser; path: "mapping.settings.keyColorsInBrowser" }
  MappingProperty { id: keyMatch2p; path: "mapping.settings.keyMatch2p" }
  MappingProperty { id: keyMatch2m; path: "mapping.settings.keyMatch2m" }
  MappingProperty { id: keyMatch5p; path: "mapping.settings.keyMatch5p" }
  MappingProperty { id: keyMatch5m; path: "mapping.settings.keyMatch5m" }
  MappingProperty { id: keyMatch6; path: "mapping.settings.keyMatch6" }

  //Deck - Widget
  MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: beatCounterMode; path: "mapping.settings.beatCounterMode"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: phaseWidget; path: "mapping.settings.phaseWidget" }

  //Deck - Waveform
  MappingProperty { id: waveformColor; path: "mapping.settings.waveformColor"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: waveformOffset; path: "mapping.settings.waveformOffset"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: dynamicWF; path: "mapping.settings.dynamicWF" }

  //Deck - Grid
  MappingProperty { id: gridMode; path: "mapping.settings.gridMode"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
  MappingProperty { id: displayGridMarkersWF; path: "mapping.settings.displayGridMarkersWF" }
  MappingProperty { id: displayBarsWF; path: "mapping.settings.displayBarsWF" }
  MappingProperty { id: displayPhrasesWF; path: "mapping.settings.displayPhrasesWF" }

  //Deck - Stripe
  MappingProperty { id: displayDarkenerPlayed; path: "mapping.settings.displayDarkenerPlayed" }
  MappingProperty { id: displayGridMarkersStripe; path: "mapping.settings.displayGridMarkersStripe" }
  MappingProperty { id: displayMinuteMarkersStripe; path: "mapping.settings.displayMinuteMarkersStripe" }
  MappingProperty { id: displayRemainingTimeStripe; path: "mapping.settings.displayRemainingTimeStripe" }
  MappingProperty { id: displayDeckLetterStripe; path: "mapping.settings.displayDeckLetterStripe" }
  MappingProperty { id: displayResultingKey; path: "mapping.settings.displayResultingKey" }

  //Deck - Performance Panel
  MappingProperty { id: panelMode; path: "mapping.settings.panelMode" }
  MappingProperty { id: displayNumbersHotcuePanel; path: "mapping.settings.displayNumbersHotcuePanel" }

  //Remix Deck
  MappingProperty { id: showVolumeFaders; path: "mapping.settings.showVolumeFaders" }
  MappingProperty { id: showFilterFaders; path: "mapping.settings.showFilterFaders" }
  MappingProperty { id: showSlotIndicators; path: "mapping.settings.showSlotIndicators" }

//------------------------------------------------------------------------------------------------------------------
// EDITOR STATES
//------------------------------------------------------------------------------------------------------------------

  //Integer Editor State Properties
  MappingProperty { id: integerEditor; path: propertiesPath + ".integer_editor" }

  //Traktor settings
  MappingProperty { id: jogwheelTensionEditor; path: propertiesPath + ".jogwheelTension_editor" }
  MappingProperty { id: onBrightnessEditor; path: propertiesPath + ".onBrightness_editor" }
  MappingProperty { id: dimmedBrightnessEditor; path: propertiesPath + ".dimmedBrightness_editor" }
  MappingProperty { id: deckALEDEditor; path: propertiesPath + ".deckALED_editor" }
  MappingProperty { id: deckBLEDEditor; path: propertiesPath + ".deckBLED_editor" }
  MappingProperty { id: deckCLEDEditor; path: propertiesPath + ".deckCLED_editor" }
  MappingProperty { id: deckDLEDEditor; path: propertiesPath + ".deckDLED_editor" }

  //Mapping settings
  MappingProperty { id: vinylBreakDurationInBeatsEditor; path: propertiesPath + ".vinylBreakDurationInBeats_editor" }
  MappingProperty { id: vinylBreakDurationInSecondsEditor; path: propertiesPath + ".vinylBreakDurationInSeconds_editor" }

  MappingProperty { id: stepBpmEditor; path: propertiesPath + ".stepBpm_editor" }
  MappingProperty { id: stepShiftBpmEditor; path: propertiesPath + ".stepShiftBpm_editor" }
  MappingProperty { id: stepTempoEditor; path: propertiesPath + ".stepTempo_editor" }
  MappingProperty { id: stepShiftTempoEditor; path: propertiesPath + ".stepShiftTempo_editor" }

  MappingProperty { id: browserTimerEditor; path: propertiesPath + ".browserTimer_editor" }
  MappingProperty { id: overlayTimerEditor; path: propertiesPath + ".overlayTimer_editor" }
  MappingProperty { id: hotcueTypeTimerEditor; path: propertiesPath + ".hotcueTypeTimer_editor" }

  //Display settings
  MappingProperty { id: browserRowsEditor; path: propertiesPath + ".browserRows_editor" }
  MappingProperty { id: waveformColorEditor; path: propertiesPath + ".waveformColor_editor" }
  MappingProperty { id: waveformOffsetEditor; path: propertiesPath + ".waveformOffset_editor" }
  MappingProperty { id: beatsxPhraseEditor; path: propertiesPath + ".beatsxPhrase_editor" }
  MappingProperty { id: gridModeEditor; path: propertiesPath + ".gridMode_editor" }
  MappingProperty { id: beatCounterModeEditor; path: propertiesPath + ".beatCounterMode_editor" }

  MappingProperty { id: perfectTempoMatchLimitEditor; path: propertiesPath + ".perfectTempoMatchLimit_editor" }
  MappingProperty { id: regularTempoMatchLimitEditor; path: propertiesPath + ".regularTempoMatchLimit_editor" }

//------------------------------------------------------------------------------------------------------------------
// APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

  //Traktor settings
  AppProperty { id: traktorWFColor; path: "app.traktor.settings.waveform.color" }
  AppProperty { id: syncMode; path: "app.traktor.settings.transport.syncMode" }
  //<Entry Name="Transport.SyncMode" Type="1" Value="0"></Entry>
  //AppProperty { id: syncMode; path: "app.traktor.transport.syncMode" }
  //AppProperty { id: syncMode; path: "app.traktor.transport.sync_mode" }
  //AppProperty { id: syncMode; path: "app.traktor.settings.transport.sync_mode" }

  //Other Properties
  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }
  AppProperty { id: deckASync; path: "app.traktor.decks.1.sync.enabled" }
  AppProperty { id: deckBSync; path: "app.traktor.decks.2.sync.enabled" }
  AppProperty { id: deckCSync; path: "app.traktor.decks.3.sync.enabled" }
  AppProperty { id: deckDSync; path: "app.traktor.decks.4.sync.enabled" }

//------------------------------------------------------------------------------------------------------------------
// Header Text
//------------------------------------------------------------------------------------------------------------------

  Text{
    id: preference_header
    font.family: "Pragmatica"
    font.pixelSize: fonts.middleFontSize
    anchors.top: parent.top
    anchors.topMargin: 20
    anchors.fill: parent
    horizontalAlignment: Text.AlignHCenter
    color: colors.cyan
    text: "Header"
    visible: false
  }

//------------------------------------------------------------------------------------------------------------------
// Properties Grid
//------------------------------------------------------------------------------------------------------------------
  property int currentIndex: 0
  property variant dataNames: []
  property variant highlightText: []
  property variant descriptionText: []

  Item {
    anchors.fill: parent

    Grid {
        id: grid

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.leftMargin: columnSpacing
        anchors.rightMargin: columnSpacing
        visible: thirdIndex != 0

        columns: 1 //(dataNames.length%2 != 0 && dateNames.length <= 3) ? 1 : 2
        rowSpacing: 5
        columnSpacing: 10

        Repeater{
            model: dataNames.length

            Rectangle {
                width: settingsGrid.width-80
                height: 20
                color: colors.colorGrey16
                border.width: 1
                border.color: (index == settingsGrid.currentIndex) ? colors.cyan : colors.colorGrey32
                //visible: dataNames[index] != "-"

                Text {
                    id: settingName
                    anchors.centerIn: parent
                    x: 9
                    font.pixelSize: fonts.middleFontSize
                    text: updateSettings(firstIndex, secondIndex, thirdIndex, 1, index)
                    color: updateSettings(firstIndex, secondIndex, thirdIndex, 2 ,index) ? colors.cyan : colors.colorFontFxHeader
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
  }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS NAVIGATION
//------------------------------------------------------------------------------------------------------------------

  readonly property variant ledColorNames: ["Black (Off)", "Red", "Dark Orange", "Light Orange", "Warm Yellow", "Yellow", "Lime", "Green", "Mint", "Cyan", "Turquoise", "Blue", "Plum",  "Violet", "Purple", "Magenta", "Fuchsia", "White"]
  readonly property variant waveformColorNames: ["Default", "Red", "Dark Orange", "Light Orange", "Warm Yellow", "Yellow", "Lime", "Green", "Mint", "Cyan", "Turquoise", "Blue", "Plum",  "Violet", "Purple", "Magenta", "Fuchsia", "Prime", "CDJ-2000NXS2", "CDJ-3000", "Supreme", "Customized"]
  readonly property variant gridNames: ["Full", "Dim", "Ticks", "Invisible"]
  readonly property variant beatCounterModeNames: ["X BARS","X.Z BARS", "X.Y.Z","-X.Y.Z"] //"X.Y.Z from grid"]

  property int prePreferencesNavMenuValue: 0
  MappingProperty { id: settingsNavigation; path: propertiesPath + ".preferencesNavigation";
    onValueChanged: {
        var delta = settingsNavigation.value - prePreferencesNavMenuValue;
        prePreferencesNavMenuValue = settingsNavigation.value;
        if (thirdIndex != 0 && !integerEditor.value) {
            var btn = settingsGrid.currentIndex;
            btn = (btn + delta) % dataNames.length;
            settingsGrid.currentIndex = (btn < 0) ? dataNames.length + btn : btn
        }
    }
  }

  function updateSettings(firstIndex, secondIndex, thirdIndex, info, index) {
    //Traktor Settings
    if (firstIndex == 1) {  //["Audio Setup", "Output Routing", "Input Routing", "External Sync", "Timecode Setup", "Loading", "Transport", "Decks Layout", "Track Decks", "Remix Decks", "Mixer", "Global Settings", "Effects", "Mix Recorder", "Loop Recorder", "Browser Details", "File Management", "Analyze Options"]
        if (secondIndex == 7) { //Transport
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Tempo Sync", "Beat Sync", "PhraseSync (NW)"]
                    highlightText = [false, false, false]
                    descriptionText = ["Only BPM will be synched", "BPM and Phase will be synched", "Synched to the Phrases of each track"]
                }
            }
        }
        else {
            if (info == 1) return dataNames[index]
            else if (info == 2) return highlightText[index]
            else if (info == 3) return descriptionText[index]
            else {
                dataNames = ["NW", "NW"]
                highlightText = [false, false]
                descriptionText = ["Not Working", "Not Working"]
            }
        }
    }

    //S4 MK3 Settings
    else if (firstIndex == 2) {
        //Transport
        if (secondIndex == 1) {
            //Tempo Faders
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Absolute", "Relative"]
                    highlightText = [!relativeTempoFaders.value, relativeTempoFaders.value]
                    descriptionText = ["", ""]
                }
            }
        }
        //Haptic Drive Settings
        else if (secondIndex == 2) {
            //Ticks on Nudging
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["None", "Coarse", "Fine"]
                    highlightText = [ ticksOnNudging.value == 0, ticksOnNudging.value == 1, ticksOnNudging.value == 2]
                    descriptionText = ["", "", ""]
                }
            }
            //Jogwheel Tension
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Tension: " + jogwheelTension.value]
                    highlightText = [jogwheelTensionEditor.value]
                    descriptionText = ["Adjust the jogwheel tension"]
                }
            }
            //Haptic Hotcues
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!hapticHotcues.value, hapticHotcues.value]
                    descriptionText = ["", ""]
                }
            }
        }
        //TT Mode Settings
        else if (secondIndex == 3) {
            //Base Speed
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["33.3 RPM", "45 RPM"]
                    highlightText = [baseSpeed.value == 0, baseSpeed.value == 1]
                    descriptionText = ["", ""]
                }
            }
        }
        //LED Settings
        else if (secondIndex == 4) {
            //Brightness
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Bright: " + onBrightness.value, "Dimmed: " + dimmedBrightness.value]
                    highlightText = [onBrightnessEditor.value, dimmedBrightnessEditor.value]
                    descriptionText = ["Adjust the LEDs maximum brightness", "Adjust the LEDs minimum brightness"]
                }
            }
            //Deck LEDs
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Deck A: " + ledColorNames[deckALED.value], "Deck B: " + ledColorNames[deckBLED.value], "Deck C: " + ledColorNames[deckCLED.value], "Deck D: " + ledColorNames[deckDLED.value]]
                    highlightText = [deckALEDEditor.value, deckBLEDEditor.value, deckCLEDEditor.value, deckDLEDEditor.value]
                    descriptionText = ["Adjust the LED color of deck A", "Adjust the LED color of deck B", "Adjust the LED color of deck C", "Adjust the LED color of deck D"]
                }
            }
        }
    }
    //Map Settings
    else if (firstIndex == 3) {
        //Play Button
        if (secondIndex == 1) {
            //Play
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Play/Pause", "Vinyl Break"]
                    highlightText = [playButton.value == 0, playButton.value == 1]
                    descriptionText = ["Instant Play/Pause", "Instant Play + Vinyl Break pause effect"]
                }
            }
            //Shift + Play
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["TimeCode", "Vinyl Break"]
                    highlightText = [shiftPlayButton.value == 0, shiftPlayButton.value == 1]
                    descriptionText = ["TimeCode", "Instant Play + Vinyl Break pause effect"]
                }
            }
            //Blinker
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!playBlinker.value, playBlinker.value]
                    descriptionText = ["The LED will not blink. It will respond in the way Traktor's GUI does", "The LED will blink when deck is paused or cueing"]
                }
            }
            //Vinyl Break Settings
            else if (thirdIndex == 4) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Duration: " + (vinylBreakInBeats.value ? (vinylBreakDurationInBeats.value + " beats") : ((vinylBreakDurationInSeconds.value/1000).toFixed(1) + " sec.")), "Seconds", "Beats"]
                    highlightText = [vinylBreakDurationInBeatsEditor.value || vinylBreakDurationInSecondsEditor.value, !vinylBreakInBeats.value, vinylBreakInBeats.value]
                    descriptionText = ["Set the Vinyl Break Effect duration in seconds/beats", "Duration in seconds", "Duration in beats"]
                }
            }
        }
        //Cue Button
        else if (secondIndex == 2) {
            //Cue
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["CUE", "CUP", "Restart", "CUE + CUP"]
                    highlightText = [cueButton.value == 0, cueButton.value == 1, cueButton.value == 2, cueButton.value == 3]
                    descriptionText = ["CUE behaviour", "CUE Play behaviour (when pressed, the deck will start playing regardless the previous state)", "Go to the beginning of the track", "Pioneer CUE + CUP style: CUE behaviour unless deck paused and playmarker is not in the Active Cue position"]
                }
            }
            //Shift + Cue
            if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["CUE", "CUP", "Restart", "CUE + CUP"]
                    highlightText = [shiftCueButton.value == 0, shiftCueButton.value == 1, shiftCueButton.value == 2, shiftCueButton.value == 3]
                    descriptionText = ["CUE behaviour", "CUE Play behaviour (when pressed, the deck will start playing regardless the previous state)", "Go to the beginning of the track", "Pioneer CUE + CUP style: CUE behaviour unless deck paused and playmarker is not in the Active Cue position"]
                }
            }
            //Blinker
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!cueBlinker.value, cueBlinker.value]
                    descriptionText = ["The LED will not blink. It will respond in the way Traktor's GUI does", "The LED will blink when the deck is paused and the playhead position isn't in the Cue position"]
                }
            }
        }
        //Sync Button
        else if (secondIndex == 3) {
            //Key Sync
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Fuzzy Sync", "Use Key Text"]
                    highlightText = [fuzzyKeySync.value, useKeyText.value]
                    descriptionText = ["The opposite scale adjacent keys will also be considered a valid match (the controller browser will also reflect this)", "Wherever possible, key text value will be used over the key value"]
                }
            }
        }
        //Browse Encoder
        else if (secondIndex == 4) {
            //Shift + Browse Push
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Instant Doubles", "Load next", "Load previous"]
                    highlightText = [shiftBrowsePush.value == 0, shiftBrowsePush.value == 1, shiftBrowsePush.value == 2, shiftBrowsePush.value == 3]
                    descriptionText = ["Disabled", "Duplicate the opposite deck (only works on the S5/S8/S4MK3)", "Load next track", "Load previous track"]
                }
            }
            //Browse
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["BPM Coarse", "BPM Fine", "Zoom", "Traktor Zoom"]
                    highlightText = [browseEncoder.value == 0, browseEncoder.value == 1, browseEncoder.value == 2, browseEncoder.value == 3]
                    descriptionText = ["±1 BPM", "± 0.01 BPM", "Zoom for the controller's Waveform", "Zoom for Traktor's Waveform" ]
                }
            }
            //Shift + Browse
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["BPM Coarse", "BPM Fine", "Zoom", "Traktor Zoom"]
                    highlightText = [shiftBrowseEncoder.value == 0, shiftBrowseEncoder.value == 1, shiftBrowseEncoder.value == 2, shiftBrowseEncoder.value == 3]
                    descriptionText = ["±1 BPM", "± 0.01 BPM", "Zoom for the controller's Waveform", "Zoom for Traktor's Waveform" ]
                }
            }
        }
        //Loop Size Encoder
        else if (secondIndex == 5) {
            //Shift + Loop Size Encoder
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Key Reset", "KeyLock", "KeyLock", "Key Sync"]
                    highlightText = [shiftPushLoopSize.value == 0, shiftPushLoopSize.value == 1, shiftPushLoopSize.value == 2, shiftPushLoopSize.value == 3]
                    descriptionText = ["Key adjust will be reset to 0", "KeyLock (with key adjust reset to 0)", "KeyLock (without key adjust reset)", "Key Sync (if internal clock isn't master)"]
                }
            }
        }
        //Hotcues Button
        else if (secondIndex == 6) {
            //Shift + Hotcues
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Legacy Loop Mode", "Advanced Loop Mode", "Loop Roll Mode", "Tone Play Mode"]
                    highlightText = [shiftHotcueButton.value == 0, shiftHotcueButton.value == 1, shiftHotcueButton.value == 2, shiftHotcueButton.value == 3]
                    descriptionText = ["Default S8/D2 Loop Mode (Top 4 pads: Loop Roll, Bottom 4 pads: BeatJumps)", "6 BeatJumps + Loop In/Out controls", "Full 8-pad Loop Roll", "Tone Play pads"]
                }
            }
        }
        //Stems Button
        else if (secondIndex == 7) {
            //Stems
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Stems Mode", "Pad FX Mode"]
                    highlightText = [stemsButton.value == 0, stemsButton.value == 1]
                    descriptionText = ["Stems Mode", "Up to 64 fully customizable single Pad Effects"]
                }
            }
            //Shift + Stems
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Stems Mode", "Pad FX Mode"]
                    highlightText = [shiftStemsButton.value == 0, shiftStemsButton.value == 1]
                    descriptionText = ["Stems Mode", "Up to 64 fully customizable single Pad Effects"]
                }
            }
        }
        //Pads
        else if (secondIndex == 8) {
            //Selector Mode
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Hold", "Toggle", "Hold + Toggle"]
                    highlightText = [slotSelectorMode.value == 0, slotSelectorMode.value == 1, slotSelectorMode.value == 2]
                    descriptionText = ["Stem Tracks/Remix Slots will be selectable ONLY holding the bottom pads", "Stem Tracks/Remix Slots will be selectable ONLY toggling the bottom pads", "Stem Tracks/Remix Slots will be selectable holding + toggling the bottom pads"]
                }
            }
            //Hotcues Play Mode
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Gate", "Cue Play"]
                    highlightText = [!hotcuesPlayMode.value, hotcuesPlayMode.value]
                    descriptionText = ["(Traktor's default behaviour) While holding the pad, the deck will play. When released, unless play is pressed, the deck will pause and return to the Hotcue", "If a hotcue pad is pressed, the deck will start playing from the Hotcue"]
                }
            }
            //Hotcue Colors
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Traktor scheme", "RB CDJ scheme", "RB Colorful scheme"]
                    highlightText = [hotcueColors.value == 0, hotcueColors.value == 1, hotcueColors.value == 2]
                    descriptionText = ["Colors will depend on the hotcue type", "Colors will depend on the hotcue type (CDJ style)", "Colors will depend on the hotcue index. Based on RekordBox's 'Colorful' scheme"]
                }
            }
        }
        //Faders
        else if (secondIndex == 9) {
            //Fader Start
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!faderStart.value, faderStart.value]
                    descriptionText = ["Default behavior", "Deck will automatically Play/Cue when deck is 'on air' (Volume Fader + XFader)"]
                }
            }
        }
    }
    //Display Settings
    else if (firstIndex == 4) {
        //General Settings
        if (secondIndex == 1) {
            //Theme
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    //dataNames = ["Original", "Original Pro", "Supreme"]
                    dataNames = ["Original Pro", "Supreme"]
                    highlightText = [theme.value == 1, theme.value == 2]
                    descriptionText = ["Original S4 MK3 Theme with enhancements", "Redesigned theme with waveform"]
                }
            }
            //Bright Mode
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled" , "Enabled"]
                    highlightText = [!brightMode.value, brightMode.value]
                    descriptionText = ["For club/dimm ambient sets", "(BETA) For daylight sets"]
                }
            }
        }
        //Browser Options
        else if (secondIndex == 2) {
            //Browser in Screens
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!browserInScreens.value, browserInScreens.value]
                    descriptionText = ["Original browse behaviour", "An adapted version of the Browser will be displayed on the S4 MK3 screen"]
                }
            }
            //Related Screens
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [independentScreenBrowser.value, !independentScreenBrowser.value]
                    descriptionText = ["While Browsing, both screens can display the Browser", "While Browsing, only one screen can display the Browser"]
                }
            }
            //Related Browsers
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!traktorRelatedBrowser.value, traktorRelatedBrowser.value]
                    descriptionText = ["The Traktor PRO browser is independent of the Controller's browser", "The Traktor PRO browser will be in full-screen when any controller screen is in the Browser"]
                }
            }
            //Open on Browse Touch
            else if (thirdIndex == 4) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!showBrowserOnTouch.value, showBrowserOnTouch.value]
                    //descriptionText = ["Browser will open when the encoder is pushed", "Browser will open (and auto-close) when the encoder is touched"]
                    descriptionText = ["Browser won't auto-open when the encoder is touch (enabling secondary functions)", "Browser will auto-open/close when touching the encoder"]
                }
            }
            //Browser Rows
            else if (thirdIndex == 5) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Rows: " + browserRows.value ]
                    highlightText = [browserRowsEditor.value]
                    descriptionText = ["Customize the number of rows that will be displayed on the Controller's browser"]
                }
            }
            //Displayed Info
            else if (thirdIndex == 6) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Album Cover", "Artist", "BPM", "Key", "Rating"]
                    highlightText = [browserAlbum.value, browserArtist.value, browserBPM.value, browserKey.value, browserRating.value]
                    descriptionText = ["", "", "", "", "", ""]
                }
            }
            //Previously Played Tracks
            else if (thirdIndex == 7) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!showTracksPlayedDarker.value, showTracksPlayedDarker.value]
                    descriptionText = ["All tracks will look the same in the controller's browser", "Already played tracks will be displayed darker"]
                }
            }
            //BPM Match Guides
            else if (thirdIndex == 8) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Enabled", "Perfect: " + perfectTempoMatchLimit.value + "%", "Regular: " + regularTempoMatchLimit.value + "%"]
                    highlightText = [highlightMatchRecommendations.value, perfectTempoMatchLimitEditor.value, regularTempoMatchLimitEditor.value]
                    descriptionText = ["", "Maximum value of difference to be considered a 'perfect match'", "Maximum value of difference to be considered a 'regular match' (WIP: use the tempo range percentage)"]
                }
            }
            //Key Match Options
            else if (thirdIndex == 9) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["+2", "-2", "+5", "-5", "±6"]
                    highlightText = [keyMatch2p.value, keyMatch2m.value, keyMatch5p.value, keyMatch5m.value, keyMatch6.value]
                    descriptionText = ["", "", "", "", ""]
                }
            }
            //Colored Keys
            else if (thirdIndex == 10) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["All Keys", "Matching", "Matching", "None"]
                    highlightText = [keyColorsInBrowser.value == 0, keyColorsInBrowser.value == 1, keyColorsInBrowser.value == 2, keyColorsInBrowser.value == 3]
                    descriptionText = ["All keys will be displayed in their corresponding color", "Matching (& adjacent) keys in their corresponding color", "Keys displayed in the 'energy guide' colors", "No keys will be colored in the controller's browser"]
                }
            }
        }
        //Track/Stem Deck
        else if (secondIndex == 3) {
            //Waveform Options
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Offset: " + waveformOffset.value, "Color: " + waveformColorNames[waveformColor.value], "Dynamic WF"]
                    highlightText = [waveformOffsetEditor.value, waveformColorEditor.value, dynamicWF.value]
                    descriptionText = ["Select the offset position of the Waveform", "Select the colours of the Waveform", "The 3 EQ bands will be displayed depending of the 3 EQ values"]
                }
            }
            //Grid Options
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Grid: " + gridNames[gridMode.value], "Grid Markers", "Phrase Markers", "Bar Markers"]
                    highlightText = [gridModeEditor.value, displayGridMarkersWF.value, displayPhrasesWF.value, displayBarsWF.value]
                    descriptionText = ["Select how the Grid is displayed above the Waveform", "Show/Hide Grid Markers on the Waveform", "Show/Hide Phrase Markers on the Waveform", "Show/Hide Bar Markers on the Waveform"]
                }
            }
            //Stripe Options
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Deck Letter", "Played Darker", "Minute Markers", "Grid Markers"]
                    highlightText = [displayDeckLetterStripe.value, displayDarkenerPlayed.value, displayMinuteMarkersStripe.value, displayGridMarkersStripe.value]
                    descriptionText = ["Display the Deck's Letter at the left of the Stripe", "The part already played of the track is displayed darker", "Display the minute markers on the Stripe", "Display the Grid Markers on the Stripe"]
                }
            }
            //Performance Panel
            else if (thirdIndex == 4) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Hotcue Bar", "Performance Panel"]
                    highlightText = [panelMode.value == 0, panelMode.value == 1, panelMode.value == 2]
                    descriptionText = ["The Performance Panel will be hidden", "The Performance Panel will display the Hotcue Bar with its names", "The Performance Panel will display what the Performance pads will trigger"]
                }
            }
            //Beat Counter Settings
            else if (thirdIndex == 5) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Beats x Phrase: " + beatsxPhrase.value, "Mode: " + beatCounterModeNames[beatCounterMode.value]]
                    highlightText = [beatsxPhraseEditor.value, beatCounterModeEditor.value]
                    descriptionText = ["Customize the Beats per Phrase value", "Customize how the beat counter is displayed"]
                }
            }
            //Beat/Phase Widget
            else if (thirdIndex == 6) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Empty", "Phase Meter", "Beat Counter"]
                    highlightText = [phaseWidget.value == 0, phaseWidget.value == 1, phaseWidget.value == 2]
                    descriptionText = ["Nothing will be displayed where the phase meter would have to", "Traktor PRO's phase meter will be displayed", "A beat counter will be displayed"]
                }
            }
            //Key Options
            else if (thirdIndex == 7) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Camelot Key", "Resulting Key", "Use KeyText"]
                    highlightText = [displayCamelotKey.value, displayResultingKey.value, useKeyText.value]
                    descriptionText = ["Use Camelot Key system instead of Traktor PRO's current key system", "Display the resulting key insead of the original track's key", "Wherever possible, key text value will be used over the key value"]
                }
            }
        }
        //Remix Deck
        else if (secondIndex == 4) {
            //Volume Fader
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!showVolumeFaders.value, showVolumeFaders.value]
                    descriptionText = ["Hide the volume faders of each slot", "Show the volume faders of each slot"]
                }
            }
            //Filter Fader
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!showFilterFaders.value, showFilterFaders.value]
                    descriptionText = ["Hide the filter faders of each slot", "Show the filter faders of each slot"]
                }
            }
            //Slot Indicators
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!showSlotIndicators.value, showSlotIndicators.value]
                    descriptionText = ["Hide the slot indicators of each slot", "Show the slot indicators of each slot"]
                }
            }
        }
    }
    //Other Settings
    else if (firstIndex == 5) {
        //Timers
        if (secondIndex == 1) {
            //Browser Timer
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = [browserTimer.value/1000 + (browserTimer.value/1000 != 1 ? " seconds" : " second")]
                    highlightText = [browserTimerEditor.value]
                    descriptionText = ["Customize how long it takes to auto-close the browser"]
                }
            }
            //Overlay Timer
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = [overlayTimer.value/1000 + (overlayTimer.value/1000 != 1 ? " seconds" : " second")]
                    highlightText = [overlayTimerEditor.value]
                    descriptionText = ["Customize how long it takes to auto-close generic overlays"]
                }
            }
            //HotcueType Timer
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = [hotcueTypeTimer.value/1000 + (hotcueTypeTimer.value/1000 != 1 ? " seconds" : " second")]
                    highlightText = [hotcueTypeTimerEditor.value]
                    descriptionText = ["Customize how long it takes to auto-close the Hotcue Type selector overlay"]
                }
            }
        }
        //Fixes
        else if (secondIndex == 2) {
            //Hotcue Triggering Fix
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!fixHotcueTrigger.value, fixHotcueTrigger.value]
                    descriptionText = ["It doesn't prevent that when triggering hotcues which aren't a Loop behave as if they were in an invisible loop", "It prevents that when triggering hotcues which aren't a Loop behave as if they were in an invisible loop"]
                }
            }
        }
        //Mods
        else if (secondIndex == 3) {
            //Only focused controls
            if (thirdIndex == 1) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!onlyFocusedDeck.value, onlyFocusedDeck.value]
                    descriptionText = ["You can control and see certain things of the unfocused deck", "You will only see and control the focused deck"]
                }
            }
            //Beatmatch Practice Mode
            else if (thirdIndex == 2) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!beatmatchPracticeMode.value, beatmatchPracticeMode.value]
                    descriptionText = ["Allows 'sync' to be used", "Disables all 'sync' helpers and options"]
                }
            }
            //Autoenable Flux when accessing LoopRoll mode or Loop Mode
            else if (thirdIndex == 3) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!enableFluxOnLoopRoll.value, enableFluxOnLoopRoll.value]
                    descriptionText = ["", "When pads are in Loop Roll, Flux will automatically enable"]
                }
            }
            //Autozoom when Zoom in Edit Mode
            else if (thirdIndex == 4) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Disabled", "Enabled"]
                    highlightText = [!autoZoomTPwaveform.value, autoZoomTPwaveform.value]
                    descriptionText = ["", "When Zoom is enabled in Edit Mode, Traktor PRO's waveform will also zoom in to the maximum"]
                }
            }
            //Shift Mode
            else if (thirdIndex == 5) {
                if (info == 1) return dataNames[index]
                else if (info == 2) return highlightText[index]
                else if (info == 3) return descriptionText[index]
                else {
                    dataNames = ["Focused Side", "Global"]
                    highlightText = [!globalShiftEnabled.value, globalShiftEnabled.value]
                    descriptionText = ["Shift functions for Left/Right sides of the controller will only work if the focused side 'shift' is held", "Shift functions for Left/Right sides of the controller will work if any 'shift' is held"]
                }
            }
        }
    }
  }

  function updateSettingsParameters(firstIndex, secondIndex, thirdIndex) {
    //Traktor Settings
    if (firstIndex == 1) {  //["Audio Setup", "Output Routing", "Input Routing", "External Sync", "Timecode Setup", "Loading", "Transport", "Decks Layout", "Track Decks", "Remix Decks", "Mixer", "Global Settings", "Effects", "Mix Recorder", "Loop Recorder", "Browser Details", "File Management", "Analyze Options"]
        if (secondIndex == 7) { //Transport
            if (thirdIndex == 1) {
            }
        }
        else {
        }
    }

    //S4 MK3 Settings
    else if (firstIndex == 2) {
        //Transport Settings
        if (secondIndex == 1) {
            //Tempo Faders
            if (thirdIndex == 1) {
                if (currentIndex == 0) relativeTempoFaders.value = false
                else if (currentIndex == 1) relativeTempoFaders.value = true
            }
        }
        //Haptic Drive Settings
        else if (secondIndex == 2) {
            //Ticks on Nudging
            if (thirdIndex == 1) {
                ticksOnNudging.value = currentIndex
            }
            //Jogwheel Tension
            else if (thirdIndex == 2) {
                if (currentIndex == 0) {integerEditor.value = !integerEditor.value; jogwheelTensionEditor.value = !jogwheelTensionEditor.value }
            }
            //Haptic Hotcues
            else if (thirdIndex == 3) {
                if (currentIndex == 0) hapticHotcues.value = false
                else if (currentIndex == 1) hapticHotcues.value = true
            }
        }
        //TT Mode Settings
        else if (secondIndex == 3) {
            //Base Speed
            if (thirdIndex == 1) {
                if (currentIndex == 0) baseSpeed.value = 0
                else if (currentIndex == 1) baseSpeed.value = 1
            }
        }
        //LED Settings
        else if (secondIndex == 4) {
            //Brightness
            if (thirdIndex == 1) {
                if (currentIndex == 0) { integerEditor.value = !integerEditor.value; onBrightnessEditor.value = !onBrightnessEditor.value }
                else if (currentIndex == 1) { integerEditor.value = !integerEditor.value; dimmedBrightnessEditor.value = !dimmedBrightnessEditor.value }
            }
            //Deck LEDs
            else if (thirdIndex == 2) {
                if (currentIndex == 0) { integerEditor.value = !integerEditor.value; deckALEDEditor.value = !deckALEDEditor.value }
                else if (currentIndex == 1) { integerEditor.value = !integerEditor.value; deckBLEDEditor.value = !deckBLEDEditor.value }
                else if (currentIndex == 2) { integerEditor.value = !integerEditor.value; deckCLEDEditor.value = !deckCLEDEditor.value }
                else if (currentIndex == 3) { integerEditor.value = !integerEditor.value; deckDLEDEditor.value = !deckDLEDEditor.value }
            }
        }
    }
    //Map Settings
    else if (firstIndex == 3) {
        //Play Button
        if (secondIndex == 1) {
            //Play
            if (thirdIndex == 1) {
                playButton.value = currentIndex
            }
            //Shift + Play
            else if (thirdIndex == 2) {
                shiftPlayButton.value = currentIndex
            }
            //Blinker
            else if (thirdIndex == 3) {
                if (currentIndex == 0) playBlinker.value = false
                else if (currentIndex == 1) playBlinker.value = true
            }
            //Vinyl Break Settings
            else if (thirdIndex == 4) {
                if (currentIndex == 0 && !vinylBreakInBeats.value) {integerEditor.value = !integerEditor.value; vinylBreakDurationInSecondsEditor.value = !vinylBreakDurationInSecondsEditor.value }
                else if (currentIndex == 0 && vinylBreakInBeats.value) {integerEditor.value = !integerEditor.value; vinylBreakDurationInBeatsEditor.value = !vinylBreakDurationInBeatsEditor.value }
                else if (currentIndex == 1) vinylBreakInBeats.value = false
                else if (currentIndex == 2) vinylBreakInBeats.value = true
            }
        }
        //Cue Button
        else if (secondIndex == 2) {
            //Cue
            if (thirdIndex == 1) {
                cueButton.value = currentIndex
            }
            //Shift + Cue
            if (thirdIndex == 2) {
                shiftCueButton.value = currentIndex
            }
            //Blinker
            else if (thirdIndex == 3) {
                if (currentIndex == 0) cueBlinker.value = false
                else if (currentIndex == 1) cueBlinker.value = true
            }
        }
        //Sync Button
        else if (secondIndex == 3) {
            //Key Sync
            if (thirdIndex == 1) {
                if (currentIndex == 0) fuzzyKeySync.value = !fuzzyKeySync.value
                else if (currentIndex == 1) useKeyText.value = !useKeyText.value
            }
        }
        //Browse Encoder
        else if (secondIndex == 4) {
            //Shift + Browse Push
            if (thirdIndex == 1) {
                shiftBrowsePush.value = currentIndex
            }
            //Browse
            else if (thirdIndex == 2) {
                browseEncoder.value = currentIndex
            }
            //Shift + Browse
            else if (thirdIndex == 3) {
                shiftBrowseEncoder.value = currentIndex
            }
        }
        //Loop Size Encoder
        else if (secondIndex == 5) {
            //Loop Encoder
            if (thirdIndex == 1) {
                shiftPushLoopSize.value = currentIndex
            }
        }
        //Hotcue Button
        else if (secondIndex == 6) {
            //Shift + Hotcue
            if (thirdIndex == 1) {
                shiftHotcueButton.value = currentIndex
            }
        }
        //Stems Button
        else if (secondIndex == 7) {
            //Stems
            if (thirdIndex == 1) {
                stemsButton.value = currentIndex
            }
            //Shift + Stems
            else if (thirdIndex == 2) {
                shiftStemsButton.value = currentIndex
            }
        }
        //Pads
        else if (secondIndex == 8) {
            //Selector Mode
            if (thirdIndex == 1) {
                slotSelectorMode.value = currentIndex
            }
            //Hotcues Play Mode
            else if (thirdIndex == 2) {
                if (currentIndex == 0) hotcuesPlayMode.value = false
                else if (currentIndex == 1) hotcuesPlayMode.value = true
            }
            //Hotcue Colors
            else if (thirdIndex == 3) {
                hotcueColors.value = currentIndex
            }
        }
        //Faders
        else if (secondIndex == 9) {
            //Fader Start
            if (thirdIndex == 1) {
                if (currentIndex == 0) faderStart.value = false
                else if (currentIndex == 1) faderStart.value = true
            }
        }
    }
    //Display Settings
    else if (firstIndex == 4) {
        //General Settings
        if (secondIndex == 1) {
            //Theme
            if (thirdIndex == 1) {
                theme.value = currentIndex + 1
                /*
                //Original
                if (theme.value == 0) {
                    waveformColor.value = 0
                    gridMode.value = 1
                    topLeftCorner.value = 1
                    displayPhrasesWF.value = false
                    displayBarsWF.value = true
                    phaseWidget.value = 1
                    beatCounterMode.value = 2
                }
                */
                //Original Pro
                if (theme.value == 1) {
                    waveformColor.value = 0
                    gridMode.value = 1
                    topLeftCorner.value = 1
                    displayPhrasesWF.value = false
                    displayBarsWF.value = true
                    phaseWidget.value = 1
                    beatCounterMode.value = 2
                }
                //SupremeWF
                else if (theme.value == 2) {
                    waveformColor.value = 20
                    gridMode.value = 1
                    topLeftCorner.value = 2
                    displayPhrasesWF.value = true
                    displayBarsWF.value = true
                    phaseWidget.value = 2
                    beatCounterMode.value = 2
                }
            }
            //Bright Mode
            else if (thirdIndex == 2) {
                if (currentIndex == 0) brightMode.value = false
                else if (currentIndex == 1) brightMode.value = true
            }
        }
        //Browser Options
        else if (secondIndex == 2) {
            //Browser in Screens
            if (thirdIndex == 1) {
                if (currentIndex == 0) browserInScreens.value = false
                else if (currentIndex == 1) browserInScreens.value = true
            }
            //Related Screens
            if (thirdIndex == 2) {
                if (currentIndex == 0) independentScreenBrowser.value = true
                else if (currentIndex == 1) independentScreenBrowser.value = false
            }
            //Related Browsers
            else if (thirdIndex == 3) {
                if (currentIndex == 0) traktorRelatedBrowser.value = false
                else if (currentIndex == 1) traktorRelatedBrowser.value = true
            }
            //Open on Browse Touch
            else if (thirdIndex == 4) {
                if (currentIndex == 0) showBrowserOnTouch.value = false
                else if (currentIndex == 1) showBrowserOnTouch.value = true
            }
            //Browser Rows
            else if (thirdIndex == 5) {
                integerEditor.value = !integerEditor.value; browserRowsEditor.value = !browserRowsEditor.value
            }
            //Displayed Info
            else if (thirdIndex == 6) {
                if (currentIndex == 0) browserAlbum.value = !browserAlbum.value
                else if (currentIndex == 1) browserArtist.value = !browserArtist.value
                else if (currentIndex == 2) browserBPM.value = !browserBPM.value
                else if (currentIndex == 3) browserKey.value = !browserKey.value
                else if (currentIndex == 4) browserRating.value = !browserRating.value
            }
            //Previously Played Tracks
            else if (thirdIndex == 7) {
                if (currentIndex == 0) showTracksPlayedDarker.value = false
                else if (currentIndex == 1) showTracksPlayedDarker.value = true
            }
            //BPM Match Guides
            else if (thirdIndex == 8) {
                if (currentIndex == 0) highlightMatchRecommendations.value = !highlightMatchRecommendations.value
                else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; perfectTempoMatchLimitEditor.value = !perfectTempoMatchLimitEditor.value }
                else if (currentIndex == 2) {integerEditor.value = !integerEditor.value; regularTempoMatchLimitEditor.value = !regularTempoMatchLimitEditor.value }
            }
            //Key Match Guides
            else if (thirdIndex == 9) {
                if (currentIndex == 0) keyMatch2p.value = !keyMatch2p.value
                else if (currentIndex == 1) keyMatch2m.value = !keyMatch2m.value
                else if (currentIndex == 2) keyMatch5p.value = !keyMatch5p.value
                else if (currentIndex == 3) keyMatch5m.value = !keyMatch5m.value
                else if (currentIndex == 4) keyMatch6.value = !keyMatch6.value
            }
            //Colored Keys
            else if (thirdIndex == 10) {
                keyColorsInBrowser.value = currentIndex
            }
        }
        //Track/Stem Deck
        else if (secondIndex == 3) {
            //Waveform Options
            if (thirdIndex == 1) {
                if (currentIndex == 0) {integerEditor.value = !integerEditor.value; waveformOffsetEditor.value = !waveformOffsetEditor.value }
                else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; waveformColorEditor.value = !waveformColorEditor.value }
                else if (currentIndex == 2) dynamicWF.value = !dynamicWF.value
            }
            //Grid Options
            else if (thirdIndex == 2) {
                if (currentIndex == 0) {integerEditor.value = !integerEditor.value; gridModeEditor.value = !gridModeEditor.value }
                else if (currentIndex == 1) displayGridMarkersWF.value = !displayGridMarkersWF.value
                else if (currentIndex == 2) displayPhrasesWF.value = !displayPhrasesWF.value
                else if (currentIndex == 3) displayBarsWF.value = !displayBarsWF.value
            }
            //Stripe Options
            else if (thirdIndex == 3) {
                if (currentIndex == 0) displayDeckLetterStripe.value = !displayDeckLetterStripe.value
                else if (currentIndex == 1) displayDarkenerPlayed.value = !displayDarkenerPlayed.value
                else if (currentIndex == 2) displayMinuteMarkersStripe.value = !displayMinuteMarkersStripe.value
                else if (currentIndex == 3) displayGridMarkersStripe.value = !displayGridMarkersStripe.value
            }
            //Performance Panel
            else if (thirdIndex == 4) {
                panelMode.value = currentIndex
            }
            //Beat Counter Settinga
            else if (thirdIndex == 5) {
                if (currentIndex == 0) {integerEditor.value = !integerEditor.value; beatsxPhraseEditor.value = !beatsxPhraseEditor.value }
                else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; beatCounterModeEditor.value = !beatCounterModeEditor.value }
            }
            //Beat/Phase Widget
            else if (thirdIndex == 6) {
                phaseWidget.value = currentIndex
            }
            //Key Options
            else if (thirdIndex == 7) {
                if (currentIndex == 0) displayCamelotKey.value = !displayCamelotKey.value
                else if (currentIndex == 1) displayResultingKey.value = !displayResultingKey.value
                else if (currentIndex == 2) useKeyText.value = !useKeyText.value
            }
            //Supreme Settings
            else if (thirdIndex == 8) {
                if (currentIndex == 0) displayActive.value = !displayActive.value
                else if (currentIndex == 1) useDefaultLoopWidget.value = !useDefaultLoopWidget.value
            }
        }
        //Remix Deck
        else if (secondIndex == 4) {
            //Volume Fader
            if (thirdIndex == 1) {
                if (currentIndex == 0) showVolumeFaders.value = false
                else if (currentIndex == 1) showVolumeFaders.value = true
            }
            //Filter Fader
            else if (thirdIndex == 2) {
                if (currentIndex == 0) showFilterFaders.value = false
                else if (currentIndex == 1) showFilterFaders.value = true
            }
            //Slot Indicators
            else if (thirdIndex == 3) {
                if (currentIndex == 0) showSlotIndicators.value = false
                else if (currentIndex == 1) showSlotIndicators.value = true
            }
        }
    }
    //Other Settings
    else if (firstIndex == 5) {
        //Timers
        if (secondIndex == 1) {
            //Browser Timer
            if (thirdIndex == 1) {
                integerEditor.value = !integerEditor.value; browserTimerEditor.value = !browserTimerEditor.value
            }
            //Overlay Timer
            else if (thirdIndex == 2) {
                integerEditor.value = !integerEditor.value; overlayTimerEditor.value = !overlayTimerEditor.value
            }
            //HotcueType Timer
            else if (thirdIndex == 3) {
                integerEditor.value = !integerEditor.value; hotcueTypeTimerEditor.value = !hotcueTypeTimerEditor.value
            }
        }
        //Fixes
        else if (secondIndex == 2) {
            //Hotcue Triggering Fix
            if (thirdIndex == 1) {
                if (currentIndex == 0) fixHotcueTrigger.value = false
                else if (currentIndex == 1) fixHotcueTrigger.value = true
            }
        }
        //Mods
        else if (secondIndex == 3) {
            //Only focused controls
            if (thirdIndex == 1) {
                if (currentIndex == 0) onlyFocusedDeck.value = false
                else if (currentIndex == 1) onlyFocusedDeck.value = true
            }
            //Beatmatch Practice Mode
            else if (thirdIndex == 2) {
                if (currentIndex == 0) beatmatchPracticeMode.value = false
                else if (currentIndex == 1) {
                    beatmatchPracticeMode.value = true
                    deckASync.value = false
                    deckBSync.value = false
                    deckCSync.value = false
                    deckDSync.value = false
                }
            }
            //Autoenable Flux when accessing LoopRoll mode or Loop Mode
            else if (thirdIndex == 3) {
                if (currentIndex == 0) enableFluxOnLoopRoll.value = false
                else if (currentIndex == 1) enableFluxOnLoopRoll.value = true
            }
            //Autozoom when Zoom in Edit Mode
            else if (thirdIndex == 4) {
                if (currentIndex == 0) autoZoomTPwaveform.value = false
                else if (currentIndex == 1) autoZoomTPwaveform.value = true
            }
            //Shift Mode
            else if (thirdIndex == 5) {
                if (currentIndex == 0) globalShiftEnabled.value = false
                else if (currentIndex == 1) globalShiftEnabled.value = true
            }
        }
    }
    updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)
  }
}
