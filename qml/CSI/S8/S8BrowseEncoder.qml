import CSI 1.0

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    property bool isTraktorS8: surface.split(".")[0] === "s8"

    DeckTempo { name: "tempo"; channel: deckId }
    Loop { name: "loop"; channel: deckId }
    KeyControl { name: "key_control"; channel: deckId }
    QuantizeControl { name: "quantize_control"; channel: deckId }
    SwitchTimer { name: "BrowserBackTimer"; setTimeout: 500 }

    property string selectedCuePath: "app.traktor.decks." + deckId + ".track.cue"
    MappingPropertyDescriptor { path: selectedHotcue.path; type: MappingPropertyDescriptor.Integer
        onValueChanged: {
            if (value != 0) { selectedCuePath = "app.traktor.decks." + deckId + ".track.cue.hotcues." + value }
            else { selectedCuePath = "app.traktor.decks." + deckId + ".track.cue" }
        }
    }
    AppProperty { id: selectedHotcueType; path: selectedCuePath + ".type" }
    AppProperty { id: hotcueActive; path: selectedCuePath +  ".active" }

    //Warning message while browsing
    AppProperty { id: deckLoadingWarning; path: "app.traktor.informer.deck_loading_warnings." + focusedDeckId + ".active";
        onValueChanged:
            if (screenView.value == ScreenView.browser && deckLoadingWarning.value) {
                screenOverlay.value = Overlay.browserWarnings
            }
            else if (screenView.value == ScreenView.browser && !deckLoadingWarning.value) {
                screenOverlay.value = Overlay.none
            }
    }

    //Necessary due to the Relative Property not reading correctly the step BPM/Tempo values
    AppProperty { id: bpm; path: "app.traktor.decks." + deckId + ".tempo.adjust_bpm" }
    AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.absolute" }

    AppProperty { id: mixerFX; path: "app.traktor.mixer.channels." + deckId + ".fx.select" }
    AppProperty { id: mixerFXA; path: "app.traktor.mixer.channels.1.fx.select" }
    AppProperty { id: mixerFXB; path: "app.traktor.mixer.channels.2.fx.select" }
    AppProperty { id: mixerFXC; path: "app.traktor.mixer.channels.3.fx.select" }
    AppProperty { id: mixerFXD; path: "app.traktor.mixer.channels.4.fx.select" }

    WiresGroup {
        enabled: active

        //Browser
        WiresGroup {
            enabled: screenView.value == ScreenView.browser

            //Navigation
            /*
            Wire { from: "%surface%.browse.push"; to: "screen.open_browser_node"; enabled: screenOverlay.value == Overlay.none } //this is also for loading Track to deck
            Wire { from: "%surface%.back"; to: "screen.exit_browser_node" }
            Wire { from: "%surface%.browse.turn"; to: "screen.scroll_browser_row"; enabled: !shift }
            Wire { from: "%surface%.browse.turn"; to: "screen.scroll_browser_page"; enabled: shift }
            */

            //Browser on touch
            Wire {
                enabled: showBrowserOnTouch.value
                from: Or {
                    inputs:
                    [
                        "%surface%.browse.touch",
                        "%surface%.encoder.touch",
                        "%surface%.back",
                        "%surface%.display.buttons.2",
                        "%surface%.display.buttons.3",
                        "%surface%.display.buttons.6",
                        "%surface%.display.buttons.7",
                        "%surface%.knobs.1.touch",
                        "%surface%.knobs.4.touch",
                        "%surface%.buttons.1",
                        "%surface%.buttons.4",
                        "%surface%.deck"
                    ]
                }
                to: HoldPropertyAdapter { path: browserIsTemporary.path; value: true }
            }

            //Dismiss warning message while browsing
            Wire { from: "%surface%.browse.push"; to: SetPropertyAdapter { path: screenOverlay.path; value: Overlay.none } enabled: screenOverlay.value == Overlay.browserWarnings }

            //Exit Browser holding Back
            Wire { from: "%surface%.back"; to: "BrowserBackTimer.input" }
            Wire { from: "BrowserBackTimer.output"; to: SetPropertyAdapter { path: screenView.path; value: ScreenView.deck } }
        }
        Wire { from: "%surface%.browse.touch"; to: HoldPropertyAdapter { path: browserIsTemporary.path; value: true } enabled: screenOverlay.value == Overlay.none && showBrowserOnTouch.value } //Can't be inside of screenView.value == ScreenView.deck because, otherwise, if you only hold the encoder, it won't keep the browser openned.

        //Deck
        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            //Open Browser
            Wire { from: "%surface%.browse.push"; to: SetPropertyAdapter { path: screenView.path; value: ScreenView.browser } enabled: !showBrowserOnTouch.value && screenOverlay.value == Overlay.none && !shift && !holdFXSelect.value}

            //Default Browser Encoder Mode
            WiresGroup {
                enabled: screenOverlay.value == Overlay.none && !showBrowserOnTouch.value

                WiresGroup {
                    enabled: !holdFXSelect.value || isTraktorS8

                    //Shift + Browse Push
                    WiresGroup {
                        enabled: shift

                        //Duplicate Decks
                        WiresGroup {
                            enabled: shiftBrowsePush.value == 1

                            //Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck." + leftFocusedDeckId.value } enabled: deckId == rightFocusedDeckId.value }
                            //Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck." + rightFocusedDeckId.value } enabled: deckId == leftFocusedDeckId.value }

                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.1" } enabled: deckId == rightFocusedDeckId.value && leftFocusedDeckId.value == 1 }
                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.2" } enabled: deckId == rightFocusedDeckId.value && leftFocusedDeckId.value == 2 }
                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.3" } enabled: deckId == rightFocusedDeckId.value && leftFocusedDeckId.value == 3 }
                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.4" } enabled: deckId == rightFocusedDeckId.value && leftFocusedDeckId.value == 4 }

                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.1" } enabled: deckId == leftFocusedDeckId.value && rightFocusedDeckId.value == 1 }
                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.2" } enabled: deckId == leftFocusedDeckId.value && rightFocusedDeckId.value == 2 }
                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.3" } enabled: deckId == leftFocusedDeckId.value && rightFocusedDeckId.value == 3 }
                            Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.4" } enabled: deckId == leftFocusedDeckId.value && rightFocusedDeckId.value == 4 }
                        }

                        //Load Previous/Next Track
                        Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.next" } enabled: shiftBrowsePush.value == 2 }
                        Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.previous" } enabled: shiftBrowsePush.value == 3 }
                    }

                    //BPM & Tempo adjustment (without needing to open the BPM Overlay)
                    WiresGroup {
                        enabled: ((masterId.value == (deckId-1) || isSyncEnabled.value == false) && fixBPMControl.value) || !fixBPMControl.value
                        Wire { from: "%surface%.back";   to: "tempo.reset"; enabled: browseEncoder.value == 0 || browseEncoder.value == 1 }
                        Wire { from: "%surface%.browse"; to: EncoderScriptAdapter { onIncrement: bpm.value = bpm.value + stepBpm.value; onDecrement: bpm.value = bpm.value - stepBpm.value } enabled: !shift && browseEncoder.value == 0 }
                        Wire { from: "%surface%.browse"; to: EncoderScriptAdapter { onIncrement: bpm.value = bpm.value + stepShiftBpm.value; onDecrement: bpm.value = bpm.value - stepShiftBpm.value } enabled: shift && shiftBrowseEncoder.value == 0 }
                        Wire { from: "%surface%.browse"; to: EncoderScriptAdapter { onIncrement: tempo.value = tempo.value + stepTempo.value; onDecrement: tempo.value = tempo.value - stepTempo.value } enabled: !shift && browseEncoder.value == 1 }
                        Wire { from: "%surface%.browse"; to: EncoderScriptAdapter { onIncrement: tempo.value = tempo.value + stepShiftTempo.value; onDecrement: tempo.value = tempo.value - stepShiftTempo.value } enabled: shift && shiftBrowseEncoder.value == 1 }
/*
                        //Not working no idea why, the step .value isn't considered, it reads the default one
                        Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust_bpm"; step: stepBpm.value; mode: RelativeMode.Stepped } enabled: !shift && browseEncoder.value == 0 }
                        Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust_bpm"; step: stepShiftBpm.value; mode: RelativeMode.Stepped } enabled: shift && shiftBrowseEncoder.value == 0 }
                        Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.absolute"; step: stepTempo.value; mode: RelativeMode.Stepped } enabled: !shift && browseEncoder.value == 1 }
                        Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.absolute"; step: stepShiftTempo.value; mode: RelativeMode.Stepped } enabled: shift && shiftBrowseEncoder.value == 1 }
*/
/*
                        Wire { from: "%surface%.back";   to: "tempo.reset"; enabled: browseEncoder.value == 0 || browseEncoder.value == 1 }
                        Wire { from: "%surface%.browse"; to: "tempo.coarse"; enabled: (!shift && browseEncoder.value == 0) || (shift && shiftBrowseEncoder.value == 0) }
                        Wire { from: "%surface%.browse"; to: "tempo.fine"; enabled: (!shift && browseEncoder.value == 1) || (shift && shiftBrowseEncoder.value == 1) }
*/
                    }

                    //Zoom
                    WiresGroup {
                        enabled: editMode.value == EditMode.disabled && (deck.deckType == DeckType.Track || deck.deckType == DeckType.Stem)
                        Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: controllerZoom.path; step: 1; mode: RelativeMode.Stepped } enabled: (!shift && browseEncoder.value == 2) || (shift && shiftBrowseEncoder.value == 2) }
                        Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.waveform_zoom"; step: 0.25; mode: RelativeMode.Stepped } enabled: (!shift && browseEncoder.value == 3) || (shift && shiftBrowseEncoder.value == 3) }
                    }

                    //Move
                    WiresGroup {
                        enabled: editMode.value == EditMode.disabled
                        Wire { from: "%surface%.browse"; to: "loop.move"; enabled: (!shift && browseEncoder.value == 4) || (shift && shiftBrowseEncoder.value == 4) }
                        Wire { from: "%surface%.browse"; to: "loop.one_beat_move"; enabled: (!shift && browseEncoder.value == 5) || (shift && shiftBrowseEncoder.value == 5) }
                    }
                }

                //MixerFX
                WiresGroup {
                    enabled: !isTraktorS8
                    Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust"; step: 0.025; mode: RelativeMode.Stepped } enabled: holdFXSelect.value || ((!shift && browseEncoder.value == 6) || (shift && shiftBrowseEncoder.value == 6)) }
                    Wire { from: "%surface%.browse.push"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.on" } enabled: holdFXSelect.value || (shift && shiftBrowsePush.value == 4) }
                    Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust"; value: 0.5 } enabled: holdFXSelect.value }
                }
            }

            //BPM/Tempo Overlay Controls
            WiresGroup {
                enabled: screenOverlay.value == Overlay.bpm
                Wire { from: "%surface%.browse.push"; to: TogglePropertyAdapter { path: "app.traktor.masterclock.mode" } }

                WiresGroup {
                    enabled: (((masterId.value+1) == deckId || isSyncEnabled.value == false) && fixBPMControl.value) || !fixBPMControl.value
                        Wire { from: "%surface%.browse"; to: EncoderScriptAdapter { onIncrement: bpm.value = bpm.value + stepBpm.value; onDecrement: bpm.value = bpm.value - stepBpm.value } enabled: !shift }
                        Wire { from: "%surface%.browse"; to: EncoderScriptAdapter { onIncrement: bpm.value = bpm.value + stepShiftBpm.value; onDecrement: bpm.value = bpm.value - stepShiftBpm.value } enabled: shift }
                        //Wire { from: "%surface%.browse"; to: "tempo.coarse"; enabled: !shift }
                        //Wire { from: "%surface%.browse"; to: "tempo.fine"; enabled: shift }
                        Wire { from: "%surface%.back"; to: "tempo.reset" }
                }
            }

            //Key Overlay
            WiresGroup {
                enabled: screenOverlay.value == Overlay.key
                Wire { from: "%surface%.browse.push"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled_preserve_pitch" } }
                Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; step: 1/12; mode: RelativeMode.Stepped } enabled: !shift }
                Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; step: 0.01/12; mode: RelativeMode.Stepped } enabled: shift }
                //Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0 } } --> to push instead of hold back to reset
                Wire { from: "%surface%.back"; to: "key_control.reset" }
            }

            //Quantize Overlay
            WiresGroup {
                enabled: screenOverlay.value == Overlay.quantize
                Wire { from: "%surface%.browse"; to: "quantize_control" }
            }

            //Swing Overlay
            WiresGroup {
                enabled: screenOverlay.value == Overlay.swing
                Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.sequencer.swing"; step: 0.01; mode: RelativeMode.Stepped } }
            }

            //Hotcue Type Selector Overlay
            WiresGroup {
                enabled: screenOverlay.value == Overlay.hotcueType

                //Wire { from: "%surface%.browse.turn"; to: EncoderScriptAdapter { onIncrement: { selectedHotcueType.value ==5 ? selectedHotcueType.value = selectedHotcueType.value - 5 : selectedHotcueType.value = selectedHotcueType.value + 1 } onDecrement: { selectedHotcueType.value ==0 ? selectedHotcueType.value = selectedHotcueType.value + 5 : selectedHotcueType.value = selectedHotcueType.value -1 } } }
                //Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + selectedHotcue.value + ".type"; mode: RelativeMode.Stepped; step: 1 } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: selectedCuePath + ".type"; value: 0; output: false } }
                Wire { from: "%surface%.back"; to: ButtonScriptAdapter { brightness: selectedHotcueType.value != 0 } }

/*
                //General Deck CueType
                Wire { from: "%surface%.browse.turn"; to: EncoderScriptAdapter { onIncrement: { cueType.value ==5 ? cueType.value = cueType.value - 5 : cueType.value = cueType.value + 1 } onDecrement: { cueType.value ==0 ? cueType.value = cueType.value + 5 : selectedHotcueType.value = selectedHotcueType.value -1 } } }
                //Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.type"; mode: RelativeMode.Stepped; step: 1 } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.type"; value: 0; output: false } }
                Wire { from: "%surface%.back"; to: ButtonScriptAdapter { brightness: selectedHotcueType.value != 0 } }
*/
            }

            //MixerFX Overlay
            WiresGroup {
                enabled: screenOverlay.value == Overlay.mixerfx
                Wire { from: "%surface%.browse.turn"; to: EncoderScriptAdapter { onIncrement: { mixerFX.value == 4 ? mixerFX.value = mixerFX.value - 4 : mixerFX.value = mixerFX.value + 1 } onDecrement: { mixerFX.value == 0 ? mixerFX.value = mixerFX.value + 4 : mixerFX.value = mixerFX.value - 1 } } }
                Wire { from: "%surface%.browse.push"; to: ButtonScriptAdapter { onPress: { mixerFXA.value = mixerFX.value; mixerFXB.value = mixerFX.value; mixerFXC.value = mixerFX.value; mixerFXD.value = mixerFX.value } } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.select"; value: 0; output: false } }
                Wire { from: "%surface%.back"; to: ButtonScriptAdapter { brightness: mixerFX.value != 0 } }
            }
        }

        //FX Settings
        WiresGroup {
            enabled: screenView.value == ScreenView.fxSettings

            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: fxSettingsNavigation.path; step: 1; mode: RelativeMode.Stepped } }
            Wire { from: "%surface%.browse.push"; to: TogglePropertyAdapter { path: fxSettingsPush.path } }
        }

        //Settings
        WiresGroup {
            enabled: screenView.value == ScreenView.settings

            //Preferences Navigation
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: preferencesNavigation.path; step: 1; mode: RelativeMode.Stepped } }
            Wire { from: "%surface%.browse.push"; to: TogglePropertyAdapter { path: preferencesPush.path } }
            Wire { from: "%surface%.back"; to: TogglePropertyAdapter { path: preferencesBack.path; output: false } }
            Wire { from: "%surface%.back"; to: ButtonScriptAdapter { brightness: backBright.value } }

            //Preferences Numerical Option Selectors
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: bendSensitivity.path; step: 1; mode: RelativeMode.Stepped } enabled: nudgeSensivityEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: scratchSensitivity.path; step: 1; mode: RelativeMode.Stepped } enabled: scratchSensivityEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: onBrightness.path; step: 1; mode: RelativeMode.Stepped } enabled: onBrightnessEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: dimmedBrightness.path; step: 1; mode: RelativeMode.Stepped } enabled: dimmedBrightnessEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: vinylBreakDurationInBeats.path; step: 1; mode: RelativeMode.Stepped } enabled: vinylBreakDurationInBeatsEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: vinylBreakDurationInSeconds.path; step: 100; mode: RelativeMode.Stepped } enabled: vinylBreakDurationInSecondsEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: waveformOffset.path; mode: RelativeMode.Stepped } enabled: waveformOffsetEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: beatsxPhrase.path; mode: RelativeMode.Stepped } enabled: beatsxPhraseEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: browserRows.path; mode: RelativeMode.Stepped } enabled: browserRowsEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: waveformColor.path; mode: RelativeMode.Stepped } enabled: waveformColorEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: gridMode.path; mode: RelativeMode.Stepped } enabled: gridModeEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: beatCounterMode.path; mode: RelativeMode.Stepped } enabled: beatCounterModeEditor.value }
            Wire { from: "%surface%.browse.turn"; to: EncoderScriptAdapter { onIncrement: { (perfectTempoMatchLimit.value < regularTempoMatchLimit.value -1) ? (perfectTempoMatchLimit.value = perfectTempoMatchLimit.value + 1) : "" } onDecrement: { (perfectTempoMatchLimit.value > 0) ? (perfectTempoMatchLimit.value = perfectTempoMatchLimit.value - 1) : "" } } enabled: perfectTempoMatchLimitEditor.value }
            Wire { from: "%surface%.browse.turn"; to: EncoderScriptAdapter { onIncrement: { (regularTempoMatchLimit.value > 49) ? "" : regularTempoMatchLimit.value = regularTempoMatchLimit.value + 1 } onDecrement: { (regularTempoMatchLimit.value > perfectTempoMatchLimit.value + 1) ? (regularTempoMatchLimit.value = regularTempoMatchLimit.value - 1) : "" } } enabled: regularTempoMatchLimitEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: browserTimer.path; step:100; mode: RelativeMode.Stepped } enabled: browserTimerEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: overlayTimer.path; step:100; mode: RelativeMode.Stepped } enabled: overlayTimerEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: mixerFXTimer.path; step:100; mode: RelativeMode.Stepped } enabled: mixerFXTimerEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: hotcueTypeTimer.path; step:100; mode: RelativeMode.Stepped } enabled: hotcueTypeTimerEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: sideButtonsTimer.path; step:100; mode: RelativeMode.Stepped } enabled: sideButtonsTimerEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: holdTimer.path; step:50; mode: RelativeMode.Stepped } enabled: holdTimerEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: stepBpm.path; step:0.01; mode: RelativeMode.Stepped } enabled: stepBpmEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: stepShiftBpm.path; step:0.01; mode: RelativeMode.Stepped } enabled: stepShiftBpmEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: stepTempo.path; step:0.0005; mode: RelativeMode.Stepped } enabled: stepTempoEditor.value }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: stepShiftTempo.path; step:0.0005; mode: RelativeMode.Stepped } enabled: stepShiftTempoEditor.value }

            //Disable Editor when pressing back or closing preferences
            WiresGroup {
                enabled: integerEditor.value
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".nudgeSensivity_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".scratchSensivity_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".onBrightness_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".dimmedBrightness_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".vinylBreakDurationInBeats_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".vinylBreakDurationInSeconds_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".waveformOffset_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".beatsxPhrase_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".browserRows_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".waveformColor_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".gridMode_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".beatCounterMode_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".perfectTempoMatchLimit_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".regularTempoMatchLimit_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".browserTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".overlayTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".mixerFXTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".hotcueTypeTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".sideButtonsTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".holdTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".stepBpm_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".stepShiftBpm_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".stepTempo_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".stepShiftTempo_editor"; value: false; output: false } }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: propertiesPath + ".integer_editor"; value: false; output: false } }

                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".nudgeSensivity_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".scratchSensivity_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".onBrightness_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".dimmedBrightness_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".vinylBreakDurationInBeats_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".vinylBreakDurationInSeconds_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".waveformOffset_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".beatsxPhrase_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".browserRows_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".waveformColor_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".gridMode_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".beatCounterMode_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".perfectTempoMatchLimit_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".regularTempoMatchLimit_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".browserTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".overlayTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".mixerFXTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".hotcueTypeTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".sideButtonsTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".holdTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".stepBpm_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".stepShiftBpm_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".stepTempo_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".stepShiftTempo_editor"; value: false; output: false } }
                Wire { from: "%surface%.back"; to: SetPropertyAdapter { path: propertiesPath + ".integer_editor"; value: false; output: false } }
            }
        }
    }
}
