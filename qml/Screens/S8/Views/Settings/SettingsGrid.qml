import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: settingsGrid

    readonly property bool isTraktorS5: screen.flavor == ScreenFlavor.S5
    readonly property bool isTraktorS8: screen.flavor == ScreenFlavor.S8
    readonly property bool isTraktorD2: screen.flavor == ScreenFlavor.D2

//------------------------------------------------------------------------------------------------------------------
// EDITABLE SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //Traktor settings
    MappingProperty { id: bendSensitivity; path: "mapping.settings.touchstrip_bend_sensitivity"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: scratchSensitivity; path: "mapping.settings.touchstrip_scratch_sensitivity"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    MappingProperty { id: onBrightness; path: "mapping.settings.led_on_brightness"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: dimmedBrightness; path: "mapping.settings.led_dimmed_percentage"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    //Mapping settings
    MappingProperty { id: vinylBreakDurationInBeats; path: "mapping.settings.vinylBreakDurationInBeats"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: vinylBreakDurationInSeconds; path: "mapping.settings.vinylBreakDurationInSeconds"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    MappingProperty { id: stepBpm; path: "mapping.settings.stepBpm"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: stepShiftBpm; path: "mapping.settings.stepShiftBpm"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: stepTempo; path: "mapping.settings.stepTempo"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: stepShiftTempo; path: "mapping.settings.stepShiftTempo"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    MappingProperty { id: browserTimer; path: "mapping.settings.browserTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: overlayTimer; path: "mapping.settings.overlayTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: mixerFXTimer; path: "mapping.settings.mixerFXTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: hotcueTypeTimer; path: "mapping.settings.hotcueTypeTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: sideButtonsTimer; path: "mapping.settings.sideButtonsTimer"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    //Display settings
    MappingProperty { id: browserRows; path: "mapping.settings.browserRows"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: beatCounterMode; path: "mapping.settings.beatCounterMode"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    MappingProperty { id: waveformColor; path: "mapping.settings.waveformColor"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: waveformOffset; path: "mapping.settings.waveformOffset"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: gridMode; path: "mapping.settings.gridMode"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

    MappingProperty { id: perfectTempoMatchLimit; path: "mapping.settings.perfectTempoMatchLimit"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }
    MappingProperty { id: regularTempoMatchLimit; path: "mapping.settings.regularTempoMatchLimit"; onValueChanged: {updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)} }

//------------------------------------------------------------------------------------------------------------------
// EDITOR STATE PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //Integer Editor State Properties
    MappingProperty { id: integerEditor; path: propertiesPath + ".integer_editor" }

    //Traktor settings
    MappingProperty { id: nudgeSensivityEditor; path: propertiesPath + ".nudgeSensivity_editor" }
    MappingProperty { id: scratchSensivityEditor; path: propertiesPath + ".scratchSensivity_editor" }
    MappingProperty { id: onBrightnessEditor; path: propertiesPath + ".onBrightness_editor" }
    MappingProperty { id: dimmedBrightnessEditor; path: propertiesPath + ".dimmedBrightness_editor" }

    //Mapping settings
    MappingProperty { id: vinylBreakDurationInBeatsEditor; path: propertiesPath + ".vinylBreakDurationInBeats_editor" }
    MappingProperty { id: vinylBreakDurationInSecondsEditor; path: propertiesPath + ".vinylBreakDurationInSeconds_editor" }

    MappingProperty { id: stepBpmEditor; path: propertiesPath + ".stepBpm_editor" }
    MappingProperty { id: stepShiftBpmEditor; path: propertiesPath + ".stepShiftBpm_editor" }
    MappingProperty { id: stepTempoEditor; path: propertiesPath + ".stepTempo_editor" }
    MappingProperty { id: stepShiftTempoEditor; path: propertiesPath + ".stepShiftTempo_editor" }

    MappingProperty { id: browserTimerEditor; path: propertiesPath + ".browserTimer_editor" }
    MappingProperty { id: overlayTimerEditor; path: propertiesPath + ".overlayTimer_editor" }
    MappingProperty { id: mixerFXTimerEditor; path: propertiesPath + ".mixerFXTimer_editor" }
    MappingProperty { id: hotcueTypeTimerEditor; path: propertiesPath + ".hotcueTypeTimer_editor" }
    MappingProperty { id: sideButtonsTimerEditor; path: propertiesPath + ".sideButtonsTimer_editor" }

    //Display settings
    MappingProperty { id: browserRowsEditor; path: propertiesPath + ".browserRows_editor" }
    MappingProperty { id: beatsxPhraseEditor; path: propertiesPath + ".beatsxPhrase_editor" }
    MappingProperty { id: beatCounterModeEditor; path: propertiesPath + ".beatCounterMode_editor" }

    MappingProperty { id: waveformColorEditor; path: propertiesPath + ".waveformColor_editor" }
    MappingProperty { id: waveformOffsetEditor; path: propertiesPath + ".waveformOffset_editor" }
    MappingProperty { id: gridModeEditor; path: propertiesPath + ".gridMode_editor" }

    MappingProperty { id: perfectTempoMatchLimitEditor; path: propertiesPath + ".perfectTempoMatchLimit_editor" }
    MappingProperty { id: regularTempoMatchLimitEditor; path: propertiesPath + ".regularTempoMatchLimit_editor" }

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //Traktor settings
    AppProperty { id: traktorWFColor; path: "app.traktor.settings.waveform.color" }
    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }
    //AppProperty { id: syncMode; path: "app.traktor.settings.transport.syncMode" }
    //<Entry Name="Transport.SyncMode" Type="1" Value="0"></Entry>
    //AppProperty { id: syncMode; path: "app.traktor.transport.syncMode" }
    //AppProperty { id: syncMode; path: "app.traktor.transport.sync_mode" }
    //AppProperty { id: syncMode; path: "app.traktor.settings.transport.sync_mode" }

    //Other Properties
    AppProperty { id: deckASync; path: "app.traktor.decks.1.sync.enabled" }
    AppProperty { id: deckBSync; path: "app.traktor.decks.2.sync.enabled" }
    AppProperty { id: deckCSync; path: "app.traktor.decks.3.sync.enabled" }
    AppProperty { id: deckDSync; path: "app.traktor.decks.4.sync.enabled" }

//------------------------------------------------------------------------------------------------------------------
// GRID
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

            columns: (dataNames.length%4 != 0 && dataNames.length <= 6) ? 3 : 4
            rowSpacing: 5
            columnSpacing: 10

            Repeater{
                model: dataNames.length

                Rectangle {
                    width: (settingsGrid.width-grid.columnSpacing*(grid.columns+1)) / grid.columns
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
                        text: (thirdIndex > 0) ? updateSettings(firstIndex, secondIndex, thirdIndex, 1, index) : ""
                        color: (thirdIndex > 0) && updateSettings(firstIndex, secondIndex, thirdIndex, 2 ,index) ? colors.cyan : colors.colorFontFxHeader
                    }
                }
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS NAVIGATION
//------------------------------------------------------------------------------------------------------------------

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

        //Controller Settings
        else if (firstIndex == 2) {
            //Touch Controls
            if (secondIndex == 1) {
                //Open on Browse Touch
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Disabled", "Enabled"]
                        highlightText = [!showBrowserOnTouch.value, showBrowserOnTouch.value]
                        descriptionText = ["Browser will open when the encoder is pushed", "Browser will open (and auto-close) when the encoder is touched"]
                    }
                }
                //Open Top FX Panel on Touch
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Disabled", "Enabled"]
                        highlightText = [!showTopPanelOnTouch.value, showTopPanelOnTouch.value]
                        descriptionText = ["Top FX Overlay will NOT appear when the knobs are touched", "Top FX Overlay will appear when the knobs are touched"]
                    }
                }
                //Open Bottom Panel on Touch
                if (thirdIndex == 3 && !isTraktorS5) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Disabled", "Enabled"]
                        highlightText = [!showBottomPanelOnTouch.value, showBottomPanelOnTouch.value]
                        descriptionText = ["Bottom Performance Overlay will NOT become larger when the bottom knobs are touched", "Bottom Performance Overlay will become larger when the bottom knobs are touched"]
                    }
                }
            }
            //Touchstrip Settings
            else if (secondIndex == 2) {
                //Bend/Nudge
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Sensitivity: " + bendSensitivity.value, "Invert" ]
                        highlightText = [ nudgeSensivityEditor.value, bendDirection.value]
                        descriptionText = ["", ""]
                    }
                }
                //Scratch
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Sensitivity: " + scratchSensitivity.value, "Invert" ]
                        highlightText = [ scratchSensivityEditor.value, scratchDirection.value]
                        descriptionText = ["", ""]
                    }
                }
                //Touchstrip Mode
                else if (thirdIndex == 3) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Nudge", "Scratch"]
                        highlightText = [!scratchWithTouchstrip.value, scratchWithTouchstrip.value]
                        descriptionText = ["The touchstrip will have a nudge behaviour", "The touchstrip will have a scratch behaviour"]
                    }
                }
            }
            //LED Settings
            else if (secondIndex == 3) {
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
            }
            //MIDI Controls
            else if (secondIndex == 4 && !isTraktorS5) {
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Disabled", "Enabled"]
                        highlightText = [!useMIDIControls.value, useMIDIControls.value]
                        descriptionText = ["Disable MIDI controls", "Enable MIDI controls (you must select the bottom MIDI performance overlay)"]
                    }
                }
            }
            //Stem Controls
            else if (secondIndex == 4 && isTraktorS5) {
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
                //Reset on load
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Keep parameters", "Reset parameters"]
                        highlightText = [!stemResetOnLoad.value, stemResetOnLoad.value]
                        descriptionText = ["Keep previous Stem parameters when loading a new Stem", "Reset the Filter, Volume & FX Send when loading a new Stem"]
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
                        dataNames = ["TimeCode", "Vinyl Break", "KeyLock", "KeyLock"]
                        highlightText = [shiftPlayButton.value == 0, shiftPlayButton.value == 1, shiftPlayButton.value == 2, shiftPlayButton.value == 3]
                        descriptionText = ["TimeCode", "Instant Play + Vinyl Break pause effect", "KeyLock (with key Reset when enabled)", "KeyLock (without Key Reset when enabled)"]
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
                        if (isTraktorD2) {
                            dataNames = ["Disabled", "Instant Doubles", "Load next", "Load previous", "MixerFX On/Off"]
                            highlightText = [shiftBrowsePush.value == 0, shiftBrowsePush.value == 1, shiftBrowsePush.value == 2, shiftBrowsePush.value == 3, shiftBrowsePush.value == 4]
                            descriptionText = ["Disabled", "Duplicate the opposite deck (only works on the S5/S8/S4MK3)", "Load next track", "Load previous track", "Toggle on/off the MixerFX"]
                        }
                        else {
                            dataNames = ["Disabled", "Instant Doubles", "Load next", "Load previous"]
                            highlightText = [shiftBrowsePush.value == 0, shiftBrowsePush.value == 1, shiftBrowsePush.value == 2, shiftBrowsePush.value == 3]
                            descriptionText = ["Disabled", "Duplicate the opposite deck (only works on the S5/S8/S4MK3)", "Load next track", "Load previous track"]
                        }
                    }
                }
                //Browse
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        if (isTraktorD2) {
                            dataNames = ["BPM: " + stepBpm.value.toFixed(2), "Tempo: " + (stepTempo.value*100).toFixed(2) + "%", "Zoom", "Traktor Zoom", "Move", "Move 1 beat", "MixerFX Adjust" ]
                            highlightText = [browseEncoder.value == 0, browseEncoder.value == 1, browseEncoder.value == 2, browseEncoder.value == 3, browseEncoder.value == 4, browseEncoder.value == 5, browseEncoder.value == 6]
                            descriptionText = ["Adjust the BPM", "Adjust the Tempo", "Zoom for the controller's Waveform", "Zoom for Traktor's Waveform", "Move the Loop Size", "Move 1 beat", "Adjust the MixerFX dry/wet"]
                        }
                        else {
                            dataNames = ["BPM: " + stepBpm.value.toFixed(2), "Tempo: " + (stepTempo.value*100).toFixed(2) + "%", "Zoom", "Traktor Zoom", "Move", "Move 1 beat" ]
                            highlightText = [browseEncoder.value == 0, browseEncoder.value == 1, browseEncoder.value == 2, browseEncoder.value == 3, browseEncoder.value == 4, browseEncoder.value == 5]
                            descriptionText = ["Adjust the BPM", "Adjust the Tempo", "Zoom for the controller's Waveform", "Zoom for Traktor's Waveform", "Move the Loop Size", "Move 1 beat"]
                        }
                    }
                }
                //Shift + Browse
                else if (thirdIndex == 3) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        if (isTraktorD2) {
                            dataNames = ["BPM: " + stepShiftBpm.value.toFixed(2), "Tempo: " + (stepShiftTempo.value*100).toFixed(2)+ "%", "Zoom", "Traktor Zoom", "Move", "Move 1 beat", "MixerFX Adjust" ]
                            highlightText = [shiftBrowseEncoder.value == 0, shiftBrowseEncoder.value == 1, shiftBrowseEncoder.value == 2, shiftBrowseEncoder.value == 3, shiftBrowseEncoder.value == 4, shiftBrowseEncoder.value == 5, shiftBrowseEncoder.value == 6]
                            descriptionText = ["Adjust the BPM", "Adjust the Tempo", "Zoom for the controller's Waveform", "Zoom for Traktor's Waveform", "Move the Loop Size", "Move 1 beat", "Adjust the MixerFX dry/wet"]
                        }
                        else {
                            dataNames = ["BPM: " + stepShiftBpm.value.toFixed(2), "Tempo: " + (stepShiftTempo.value*100).toFixed(2)+ "%", "Zoom", "Traktor Zoom", "Move", "Move 1 beat" ]
                            highlightText = [shiftBrowseEncoder.value == 0, shiftBrowseEncoder.value == 1, shiftBrowseEncoder.value == 2, shiftBrowseEncoder.value == 3, shiftBrowseEncoder.value == 4, shiftBrowseEncoder.value == 5]
                            descriptionText = ["Adjust the BPM", "Adjust the Tempo", "Zoom for the controller's Waveform", "Zoom for Traktor's Waveform", "Move the Loop Size", "Move 1 beat"]
                        }
                    }
                }
                //BPM Step
                else if (thirdIndex == 4) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["BPM: " + stepBpm.value.toFixed(2), "Shift: " + stepShiftBpm.value.toFixed(2) ]
                        highlightText = [stepBpmEditor.value, stepShiftBpmEditor.value]
                        descriptionText = ["Customize the BPM step when turning the Browse encoder", "Customize the BPM step when turning the Browse encoder (Shifted)" ]
                    }
                }
                //Tempo Step
                else if (thirdIndex == 5) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Tempo: " + (stepTempo.value*100).toFixed(2) + "%", "Shift: " + (stepShiftTempo.value*100).toFixed(2) + "%"]
                        highlightText = [stepTempoEditor.value, stepShiftTempoEditor.value]
                        descriptionText = ["Customize the Tempo step when turning the Browse encoder", "Customize the Tempo step when turning the Browse encoder (Shifted)" ]
                    }
                }
            }
            //FX Select Button (S8/D2 Only)
            else if (secondIndex == 5 && !isTraktorS5) {
                //FX Select
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["FX Select", "Mixer FX"]
                        highlightText = [fxSelectButton.value == 0, fxSelectButton.value == 1]
                        descriptionText = ["FX Select Button will open the FX Select Menu", "FX Select Button will open the MixerFX Overlay"]
                    }
                }
                //Shift + FX Select
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["FX Select", "Mixer FX"]
                        highlightText = [shiftFxSelectButton.value == 0, shiftFxSelectButton.value == 1]
                        descriptionText = ["Shift + FX Select Button will open the FX Select Menu", "Shift + FX Select Button will open the MixerFX Overlay"]
                    }
                }
            }
            //Loop Encoder (S5 Only)
            else if (secondIndex == 5 && isTraktorS5) {
                //Loop Encoder
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Sorting", "Preview Player"]
                        highlightText = [loopEncoderInBrowser.value == 0, loopEncoderInBrowser.value == 1]
                        descriptionText = ["The Loop Encoder will control the Browser's sorting", "The Loop Encoder will control the Browser's Preview Player"]
                    }
                }
                //Shift + Loop Encoder
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Sorting", "Preview Player"]
                        highlightText = [shiftLoopEncoderInBrowser.value == 0, shiftLoopEncoderInBrowser.value == 1]
                        descriptionText = ["Shift + Loop Encoder will control the Browser's sorting", "Shift + Loop Encoder will control the Browser's Preview Player"]
                    }
                }
            }
            //Loop Button (S8/D2 Only)
            else if (secondIndex == 6 && !isTraktorS5) {
                //Loop
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Default Mode", "Advanced Mode", "Loop Roll"]
                        highlightText = [loopButton.value == 0, loopButton.value == 1, loopButton.value == 2]
                        descriptionText = ["Default S8/D2 Loop Mode (Top 4 pads: Loop Roll, Bottom 4 pads: BeatJumps)", "6 BeatJumps + Loop In/Out controls", "Full 8-pad Loop Roll"]
                    }
                }
                //Shift + Loop
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Default Mode", "Advanced Mode", "Loop Roll"]
                        highlightText = [shiftLoopButton.value == 0, shiftLoopButton.value == 1, shiftLoopButton.value == 2]
                        descriptionText = ["Default S8/D2 Loop Mode (Top 4 pads: Loop Roll, Bottom 4 pads: BeatJumps)", "6 BeatJumps + Loop In/Out controls", "Full 8-pad Loop Roll"]
                    }
                }
            }
            //Hotcue Button (S5 Only)
            else if (secondIndex == 6 && isTraktorS5) {
                //Shift + Hotcue
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["S8/D2 Default Mode", "Advanced Mode", "Loop Roll", "Tone Play Mode"]
                        highlightText = [shiftHotcueButton.value == 0, shiftHotcueButton.value == 1, shiftHotcueButton.value == 2, shiftHotcueButton.value == 3]
                        descriptionText = ["Default S8/D2 Loop Mode (Top 4 pads: Loop Roll, Bottom 4 pads: BeatJumps)", "6 BeatJumps + Loop In/Out controls", "Full 8-pad Loop Roll", "Tone Play pads"]
                    }
                }
            }
            //Freeze Button
            else if (secondIndex == 7) {
                //Freeze
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Freeze Mode", "Pad FX Mode"]
                        highlightText = [freezeButton.value == 0, freezeButton.value == 1, freezeButton.value == 2]
                        descriptionText = ["Freeze Mode (8 slices)", "Up to 64 fully customizable single Pad Effects"]
                    }
                }
                //Shift + Freeze
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Freeze Mode", "Pad FX Mode"]
                        highlightText = [shiftFreezeButton.value == 0, shiftFreezeButton.value == 1]
                        descriptionText = ["Freeze Mode (8 slices)", "Up to 64 fully customizable single Pad Effects"]
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
            else if (secondIndex == 9 && !isTraktorD2) {
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
            //D2 Deck Buttons
            else if (secondIndex == 9 && isTraktorD2) {
                //D2 Deck
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Active Deck", "Top FX Unit", "Top FX Assigned Decks"]
                        highlightText = [d2buttons.value == 0, d2buttons.value == 1, d2buttons.value == 2]
                        descriptionText = ["Selects the active Deck (and DeckAssignment)", "Selects the Top FX Unit", "Assigns the Top FX Unit to decks A/B/C/D"]
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
                        dataNames = ["Traktor", "Supreme", "Supreme Pro", "Prime", "CDJ-2000NXS2", "CDJ-3000"]
                        highlightText = [theme.value == 1, theme.value == 2, theme.value == 3, theme.value == 4, theme.value == 5, theme.value == 6]
                        descriptionText = ["Theme based on the Traktor PRO deck", "Theme based on Traktor PRO and Prime decks", "Redesigned Supreme theme with Parallel Waveforms", "Theme which recreates Denon SC5000/SC6000 Prime decks", "Theme which recreates Pioneer CDJ-2000NXS2 decks", "Theme which recreates Pioneer CDJ-3000 decks"]
                    }
                }
                //Panels
                else if (thirdIndex == 2) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Top on touch", "Bottom on touch", "Bottom hide", "On FX Assign"]
                        highlightText = [showTopPanelOnTouch.value, showBottomPanelOnTouch.value, hideBottomPanel.value, showAssignedFXOverlays.value ]
                        descriptionText = ["Top FX Overlay will appear when the knobs/buttons are touched", "Bottom Performance Overlay will become larger when the bottom knobs are touched", "Bottom panel will appear large and then hide when the knobs/buttons are touched", "FX panels will become large when the top/bottom FX Units are assigned to a channel"]
                    }
                }
                //Bright Mode
                else if (thirdIndex == 3) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Disabled" , "Enabled"]
                        highlightText = [!brightMode.value, brightMode.value]
                        descriptionText = ["For club/dimm ambient sets", "(BETA) For daylight sets"]
                    }
                }
                //Top Left Corner
                else if (thirdIndex == 4) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Empty", "Album", "Deck Letter", "Deck Index"]
                        highlightText = [topLeftCorner.value == 0, topLeftCorner.value == 1, topLeftCorner.value == 2, topLeftCorner.value == 3]
                        descriptionText = ["The deck's top left corner will be empty", "The deck's top left corner will display the Album Cover", "The deck's top left corner will display the Deck Letter", "The deck's top left corner will display the Deck Index"]
                    }
                }
            }
            //Browser Options
            else if (secondIndex == 2) {
                //Related Screens
                if (thirdIndex == 1) {
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
                else if (thirdIndex == 2) {
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
                else if (thirdIndex == 3) {
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
                else if (thirdIndex == 4) {
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
                else if (thirdIndex == 5) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Album", "Artist", "BPM", "Key", "Rating"]
                        highlightText = [browserAlbum.value, browserArtist.value, browserBPM.value, browserKey.value, browserRating.value]
                        descriptionText = ["", "", "", "", "", ""]
                    }
                }
                //Previously Played Tracks
                else if (thirdIndex == 6) {
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
                else if (thirdIndex == 7) {
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
                else if (thirdIndex == 8) {
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
                else if (thirdIndex == 9) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["All Keys", "Matching", "Matching", "None"]
                        highlightText = [keyColorsInBrowser.value == 0, keyColorsInBrowser.value == 1, keyColorsInBrowser.value == 2, keyColorsInBrowser.value == 3]
                        descriptionText = ["All keys will be displayed in their corresponding color", "Matching (& adjacent) keys in their corresponding color", "Keys displayed in the 'energy guide' colors", "No keys will be colored in the controller's browser"]
                    }
                }
                //Bottom Info
                else if (thirdIndex == 10) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Empty", "Track count", "Time", "Deck Keys"]
                        highlightText = [browserFooterInfo.value == 0, browserFooterInfo.value == 1, browserFooterInfo.value == 2, browserFooterInfo.value == 3]
                        descriptionText = ["Nothing will be displayed at the bottom center of the browser", "Display the total number of tracks for the selected playlist/folder", "Display the local time in hh:mm:ss format", "Display the keys of the 4 decks at the bottom of the Browser"]
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
                        dataNames = ["Offset: " + waveformOffset.value, "Color: " + waveformColorNames[waveformColor.value], "Dynamic WF", "LoopSize"]
                        highlightText = [waveformOffsetEditor.value, waveformColorEditor.value, dynamicWF.value, showLoopSizeOverlay.value]
                        descriptionText = ["Select the offset position of the Waveform", "Select the colours of the Waveform", "The 3 EQ bands will be displayed depending of the 3 EQ values", "Show/Hide the LoopSize overlay over the Waveform on touch"]
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
                        dataNames = ["Empty", "Phase Meter", "Beat Counter", "Waveform"]
                        highlightText = [phaseWidget.value == 0, phaseWidget.value == 1, phaseWidget.value == 2, phaseWidget.value == 3]
                        descriptionText = ["Nothing will be displayed where the phase meter would have to", "Traktor PRO's phase meter will be displayed", "A beat counter will be displayed", "The master waveform will be displayed"]
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
                //Supreme Settings
                else if (thirdIndex == 8) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Display Active", "Default Loop Widget"]
                        highlightText = [displayActive.value, useDefaultLoopWidget.value]
                        descriptionText = [""]
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
                //MixerFX Timer
                else if (thirdIndex == 3) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = [mixerFXTimer.value/1000 + (mixerFXTimer.value/1000 != 1 ? " seconds" : " second")]
                        highlightText = [mixerFXTimerEditor.value]
                        descriptionText = ["Customize how long it takes to auto-close the MixerFX overlay"]
                    }
                }
                //HotcueType Timer
                else if (thirdIndex == 4) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = [hotcueTypeTimer.value/1000 + (hotcueTypeTimer.value/1000 != 1 ? " seconds" : " second")]
                        highlightText = [hotcueTypeTimerEditor.value]
                        descriptionText = ["Customize how long it takes to auto-close the Hotcue Type selector overlay"]
                    }
                }
                //Side Buttons Timer
                else if (thirdIndex == 5) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = [sideButtonsTimer.value/1000 + (sideButtonsTimer.value/1000 != 1 ? " seconds" : " second")]
                        highlightText = [sideButtonsTimerEditor.value]
                        descriptionText = ["Customize how long it takes to auto-close side overlays"]
                    }
                }
            }
            //Fixes
            else if (secondIndex == 2) {
                //BPM Controls Fix
                if (thirdIndex == 1) {
                    if (info == 1) return dataNames[index]
                    else if (info == 2) return highlightText[index]
                    else if (info == 3) return descriptionText[index]
                    else {
                        dataNames = ["Disabled", "Enabled"]
                        highlightText = [!fixBPMControl.value, fixBPMControl.value]
                        descriptionText = ["It doesn't prevent synched deck's which aren't the Master to change the Master's BPM", "It prevents synched deck's which aren't the Master to change the Master's BPM"]
                    }
                }
                //Hotcue Triggering Fix
                else if (thirdIndex == 2) {
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
                else if (thirdIndex == 5 && !isTraktorD2) {
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

        //Controller Settings
        else if (firstIndex == 2) {
            //Touch Controls
            if (secondIndex == 1) {
                //Open on Browse Touch
                if (thirdIndex == 1) {
                    if (currentIndex == 0) showBrowserOnTouch.value = false
                    else if (currentIndex == 1) showBrowserOnTouch.value = true
                }
                //Open Top FX Panel on Touch
                else if (thirdIndex == 2) {
                    if (currentIndex == 0) showTopPanelOnTouch.value = false
                    else if (currentIndex == 1) showTopPanelOnTouch.value = true
                }
                //Open Bottom Panel on Touch
                if (thirdIndex == 3 && !isTraktorS5) {
                    if (currentIndex == 0) showBottomPanelOnTouch.value = false
                    else if (currentIndex == 1) showBottomPanelOnTouch.value = true
                }
            }
            //Touchstrip Settings
            else if (secondIndex == 2) {
                //Bend/Nudge
                if (thirdIndex == 1) {
                    if (currentIndex == 0) {integerEditor.value = !integerEditor.value; nudgeSensivityEditor.value = !nudgeSensivityEditor.value }
                    else if (currentIndex == 1) bendDirection.value = !bendDirection.value
                }
                //Scratch
                else if (thirdIndex == 2) {
                    if (currentIndex == 0) {integerEditor.value = !integerEditor.value; scratchSensivityEditor.value = !scratchSensivityEditor.value }
                    else if (currentIndex == 1) scratchDirection.value = !scratchDirection.value
                }
                //Touchstrip Mode
                else if (thirdIndex == 3) {
                    if (currentIndex == 0) scratchWithTouchstrip.value = false
                    else if (currentIndex == 1) scratchWithTouchstrip.value = true
                }
            }
            //LED Settings
            else if (secondIndex == 3) {
                //Brightness
                if (thirdIndex == 1) {
                    if (currentIndex == 0) { integerEditor.value = !integerEditor.value; onBrightnessEditor.value = !onBrightnessEditor.value }
                    else if (currentIndex == 1) { integerEditor.value = !integerEditor.value; dimmedBrightnessEditor.value = !dimmedBrightnessEditor.value }
                }
            }
            //MIDI Controls
            else if (secondIndex == 4 && !isTraktorS5) {
                if (thirdIndex == 1) {
                    if (currentIndex == 0) useMIDIControls.value = false
                    else if (currentIndex == 1) useMIDIControls.value = true
                }
            }
            //Stem Controls
            else if (secondIndex == 4 && isTraktorS5) {
                //Selector Mode
                if (thirdIndex == 1) {
                    slotSelectorMode.value = currentIndex
                }
                //Reset controls on  Load
                else if (thirdIndex == 2) {
                    if (currentIndex == 0) stemResetOnLoad.value = false
                    else if (currentIndex == 1) stemResetOnLoad.value = true
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
                //BPM Step
                else if (thirdIndex == 4) {
                    if (currentIndex == 0) {integerEditor.value = !integerEditor.value; stepBpmEditor.value = !stepBpmEditor.value }
                    else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; stepShiftBpmEditor.value = !stepShiftBpmEditor.value }
                }
                //Tempo Step
                else if (thirdIndex == 5) {
                    if (currentIndex == 0) {integerEditor.value = !integerEditor.value; stepTempoEditor.value = !stepTempoEditor.value }
                    else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; stepShiftTempoEditor.value = !stepShiftTempoEditor.value }
                }
            }
            //FX Select Button (S8/D2 Only)
            else if (secondIndex == 5 && !isTraktorS5) {
                //FX Select
                if (thirdIndex == 1) {
                    fxSelectButton.value = currentIndex
                }
                //Shift + FX Select
                else if (thirdIndex == 2) {
                    shiftFxSelectButton.value = currentIndex
                }
            }
            //Loop Encoder (S5 Only)
            else if (secondIndex == 5 && isTraktorS5) {
                //Loop Encoder
                if (thirdIndex == 1) {
                    loopEncoderInBrowser.value = currentIndex
                }
                //Shift + Loop Encoder
                else if (thirdIndex == 2) {
                    shiftLoopEncoderInBrowser.value = currentIndex
                }
            }
            //Loop Button (S8/D2 Only)
            else if (secondIndex == 6 && !isTraktorS5) {
                //Loop
                if (thirdIndex == 1) {
                    loopButton.value = currentIndex
                }
                //Shift + Loop
                else if (thirdIndex == 2) {
                    shiftLoopButton.value = currentIndex
                }
            }
            //Hotcue Button (S5 Only)
            else if (secondIndex == 6 && isTraktorS5) {
                //Shift + Hotcue
                if (thirdIndex == 1) {
                    shiftHotcueButton.value = currentIndex
                }
            }
            //Freeze Button
            else if (secondIndex == 7) {
                //Freeze
                if (thirdIndex == 1) {
                    freezeButton.value = currentIndex
                }
                //Shift + Freeze
                else if (thirdIndex == 2) {
                    shiftFreezeButton.value = currentIndex
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
            else if (secondIndex == 9 && !isTraktorD2) {
                //Fader Start
                if (thirdIndex == 1) {
                    if (currentIndex == 0) faderStart.value = false
                    else if (currentIndex == 1) faderStart.value = true
                }
            }
            //D2 Buttons
            else if (secondIndex == 9 && isTraktorD2) {
                //Selector Mode
                if (thirdIndex == 1) {
                    d2buttons.value = currentIndex
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
                    //Traktor
                    if (theme.value == 1) {
                        waveformColor.value = 0
                        gridMode.value = 1
                        topLeftCorner.value = 1
                        displayPhrasesWF.value = false
                        displayBarsWF.value = true
                        phaseWidget.value = 1
                        beatCounterMode.value = 2
                        hotcueColors.value = 0
                        showLoopSizeOverlay.value = true
                    }
                    //Supreme
                    else if (theme.value == 2) {
                        waveformColor.value = 20
                        gridMode.value = 1
                        topLeftCorner.value = 2
                        displayPhrasesWF.value = true
                        displayBarsWF.value = true
                        phaseWidget.value = 2
                        beatCounterMode.value = 2
                        hotcueColors.value = 0
                        showLoopSizeOverlay.value = false
                    }
                    //Supreme 2.0
                    else if (theme.value == 3) {
                        waveformColor.value = 20
                        gridMode.value = 2
                        topLeftCorner.value = 2
                        displayPhrasesWF.value = true
                        displayBarsWF.value = true
                        phaseWidget.value = 3
                        beatCounterMode.value = 2
                        hotcueColors.value = 0
                        showLoopSizeOverlay.value = false
                    }
                    //Prime
                    else if (theme.value == 4) {
                        waveformColor.value = 17
                        gridMode.value = 2
                        topLeftCorner.value = 3
                        displayPhrasesWF.value = false
                        displayBarsWF.value = true
                        phaseWidget.value = 2
                        beatCounterMode.value = 0
                        hotcueColors.value = 0
                        showLoopSizeOverlay.value = false
                    }
                    //CDJ-2000NXS2
                    else if (theme.value == 5) {
                        waveformColor.value = 0
                        gridMode.value = 2
                        displayPhrasesWF.value = false
                        displayBarsWF.value = true
                        phaseWidget.value = 2
                        beatCounterMode.value = 2
                        hotcueColors.value = 1
                        showLoopSizeOverlay.value = false
                    }
                    //CDJ-3000
                    else if (theme.value == 6) {
                        waveformColor.value = 19
                        gridMode.value = 2
                        topLeftCorner.value = 1
                        displayPhrasesWF.value = false
                        displayBarsWF.value = true
                        phaseWidget.value = 3
                        beatCounterMode.value = 1
                        hotcueColors.value = 1
                        showLoopSizeOverlay.value = false
                    }
                }
                //Panels
                else if (thirdIndex == 2) {
                    if (currentIndex == 0) showTopPanelOnTouch.value = !showTopPanelOnTouch.value
                    else if (currentIndex == 1) showBottomPanelOnTouch.value = !showBottomPanelOnTouch.value
                    else if (currentIndex == 2) hideBottomPanel.value = !hideBottomPanel.value
                    else if (currentIndex == 3) showAssignedFXOverlays.value = !showAssignedFXOverlays.value
                }
                //Bright Mode
                else if (thirdIndex == 3) {
                    if (currentIndex == 0) brightMode.value = false
                    else if (currentIndex == 1) brightMode.value = true
                }
                //Top Left Corner
                else if (thirdIndex == 4) {
                    topLeftCorner.value = currentIndex
                }
            }
            //Browser Options
            else if (secondIndex == 2) {
                //Related Screens
                if (thirdIndex == 1) {
                    if (currentIndex == 0) independentScreenBrowser.value = true
                    else if (currentIndex == 1) independentScreenBrowser.value = false
                }
                //Related Browsers
                else if (thirdIndex == 2) {
                    if (currentIndex == 0) traktorRelatedBrowser.value = false
                    else if (currentIndex == 1) traktorRelatedBrowser.value = true
                }
                //Open on Browse Touch
                else if (thirdIndex == 3) {
                    if (currentIndex == 0) showBrowserOnTouch.value = false
                    else if (currentIndex == 1) showBrowserOnTouch.value = true
                }
                //Browser Rows
                else if (thirdIndex == 4) {
                    integerEditor.value = !integerEditor.value; browserRowsEditor.value = !browserRowsEditor.value
                }
                //Displayed Info
                else if (thirdIndex == 5) {
                    if (currentIndex == 0) browserAlbum.value = !browserAlbum.value
                    else if (currentIndex == 1) browserArtist.value = !browserArtist.value
                    else if (currentIndex == 2) browserBPM.value = !browserBPM.value
                    else if (currentIndex == 3) browserKey.value = !browserKey.value
                    else if (currentIndex == 4) browserRating.value = !browserRating.value
                }
                //Previously Played Tracks
                else if (thirdIndex == 6) {
                    if (currentIndex == 0) showTracksPlayedDarker.value = false
                    else if (currentIndex == 1) showTracksPlayedDarker.value = true
                }
                //BPM Match Guides
                else if (thirdIndex == 7) {
                    if (currentIndex == 0) highlightMatchRecommendations.value = !highlightMatchRecommendations.value
                    else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; perfectTempoMatchLimitEditor.value = !perfectTempoMatchLimitEditor.value }
                    else if (currentIndex == 2) {integerEditor.value = !integerEditor.value; regularTempoMatchLimitEditor.value = !regularTempoMatchLimitEditor.value }
                }
                //Key Match Guides
                else if (thirdIndex == 8) {
                    if (currentIndex == 0) keyMatch2p.value = !keyMatch2p.value
                    else if (currentIndex == 1) keyMatch2m.value = !keyMatch2m.value
                    else if (currentIndex == 2) keyMatch5p.value = !keyMatch5p.value
                    else if (currentIndex == 3) keyMatch5m.value = !keyMatch5m.value
                    else if (currentIndex == 4) keyMatch6.value = !keyMatch6.value
                }
                //Colored Keys
                else if (thirdIndex == 9) {
                    keyColorsInBrowser.value = currentIndex
                }
                //Bottom Info
                else if (thirdIndex == 10) {
                    browserFooterInfo.value = currentIndex
                }
            }
            //Track/Stem Deck
            else if (secondIndex == 3) {
                //Waveform Options
                if (thirdIndex == 1) {
                    if (currentIndex == 0) {integerEditor.value = !integerEditor.value; waveformOffsetEditor.value = !waveformOffsetEditor.value }
                    else if (currentIndex == 1) {integerEditor.value = !integerEditor.value; waveformColorEditor.value = !waveformColorEditor.value }
                    else if (currentIndex == 2) dynamicWF.value = !dynamicWF.value
                    else if (currentIndex == 3) showLoopSizeOverlay.value = !showLoopSizeOverlay.value
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
                //MixerFX Timer
                else if (thirdIndex == 3) {
                    integerEditor.value = !integerEditor.value; mixerFXTimerEditor.value = !mixerFXTimerEditor.value
                }
                //HotcueType Timer
                else if (thirdIndex == 4) {
                    integerEditor.value = !integerEditor.value; hotcueTypeTimerEditor.value = !hotcueTypeTimerEditor.value
                }
                //Side Buttons Timer
                else if (thirdIndex == 5) {
                    integerEditor.value = !integerEditor.value; sideButtonsTimerEditor.value = !sideButtonsTimerEditor.value
                }
            }
            //Fixes
            else if (secondIndex == 2) {
                //BPM Controls Fix
                if (thirdIndex == 1) {
                    if (currentIndex == 0) fixBPMControl.value = false
                    else if (currentIndex == 1) fixBPMControl.value = true
                }
                //Hotcue Triggering Fix
                else if (thirdIndex == 2) {
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
                else if (thirdIndex == 5 && !isTraktorD2) {
                    if (currentIndex == 0) globalShiftEnabled.value = false
                    else if (currentIndex == 1) globalShiftEnabled.value = true
                }
            }
        }
        updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)
    }
}
