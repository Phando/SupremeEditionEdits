import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    Browser {
        name: "browser"
        fullScreenColor: Color.White //deckLEDColor
        prepListColor: Color.White //deckLEDColor
    }

    DeckTempo { name: "tempo"; channel: deckId }
    RemixDeck { name: "remix"; channel: deckId; size: RemixDeck.Small }
    RemixTrigger { name: "triggering"; channel: deckId; target: RemixTrigger.StepSequencer }
    SwitchTimer { name: "BrowserLeaveTimer"; resetTimeout: browserTimer.value;
        onSet: {
            if (screenView.value != ScreenView.browser && screenOverlay.value == Overlay.none && showBrowserOnTouch.value) {
                browserIsTemporary.value = true;
                screenView.value = ScreenView.browser
            }
        }
        onReset: {
            if (screenView.value == ScreenView.browser && showBrowserOnTouch.value && browserIsTemporary.value) {
                screenView.value = ScreenView.deck
            }
        }
    }

    ButtonScriptAdapter {
        name: "ViewButton"
        brightness: screenView.value != screenView.deck || (screenView.value == ScreenView.deck && (screenOverlay.value != screenOverlay.none || editMode.value == EditMode.full || (!browserInScreens.value && fullscreenBrowser.value)))
        color: Color.White //deckLEDColor
        onPress: {
            holdView_countdown.restart()
        }
        onRelease: {
            if (holdView_countdown.running) {
                if (screenView.value == ScreenView.deck) {
                    if (screenOverlay.value == Overlay.none && editMode.value != EditMode.full) {
                        if (!shift && !browserInScreens.value) fullscreenBrowser.value = !fullscreenBrowser.value
                        else if (theme.value == 1) theme.value = 2
                        else if (theme.value == 2) theme.value = 1
                    }
                    else {
                        screenOverlay.value = Overlay.none;
                        editMode.value = EditMode.disabled;
                    }
                }
                else if (screenView.value == ScreenView.browser) {
                    browserExitNode.value = true
                }
                else if (screenView.value == ScreenView.settings) {
                    preferencesBack.value = !preferencesBack.value
                }
                else if (screenView.value == ScreenView.fxSettings) {
                    screenView.value = ScreenView.deck;
                }
            }
            holdView_countdown.stop()
        }
    }
    Timer { id: holdView_countdown; interval: holdTimer.value
        onTriggered: {
            screenView.value = ScreenView.deck
            screenOverlay.value = Overlay.none
            editMode.value = EditMode.disabled
        }
    }

    property bool holdFavorite: false
    ButtonScriptAdapter {
        name: "FavoriteButton"
        brightness: holdFavorite || screenView.value == ScreenView.settings || screenView.value == ScreenView.fxSettings
        color: Color.Yellow //deckLEDColor
        onPress: {
            holdFavorite_countdown.restart()
            if (screenView.value == ScreenView.browser) holdFavorite = true
        }
        onRelease: {
            if (holdFavorite_countdown.running) {
                if (screenView.value == ScreenView.deck && !shift) screenView.value = ScreenView.settings
                else if (screenView.value == ScreenView.deck && shift) screenView.value = ScreenView.fxSettings
                else if (screenView.value == ScreenView.settings || screenView.value == ScreenView.fxSettings) screenView.value = ScreenView.deck
            }
            holdFavorite_countdown.stop()
            holdFavorite = false
        }
    }
    Timer { id: holdFavorite_countdown; interval: holdTimer.value
        onTriggered: {
            holdFavorite = true
        }
    }

    property bool holdPreview: false
    ButtonScriptAdapter {
        name: "PreviewButton"
        brightness: playPreviewPlayer.value && previewPlayerIsLoaded.value //blink when button held?
        color: Color.Cyan //deckLEDColor
        onPress: {
            holdPreview_countdown.restart()
        }
        onRelease: {
            if (holdPreview_countdown.running) {
                if ((browserIsContentList.value && browserInScreens.value) || !browserInScreens.value) loadPlayPreviewPlayer.value = !loadPlayPreviewPlayer.value
                else if (!browserInScreens.value) {
                    if (!shift) {
                        if (playPreviewPlayer.value) playPreviewPlayer.value = false
                        else loadPlayPreviewPlayer.value = !loadPlayPreviewPlayer.value
                    }
                    else if (shift) unloadPreviewPlayer.value = !unloadPreviewPlayer.value
                }
            }
            holdPreview_countdown.stop()
            holdPreview = false
        }
    }
    Timer { id: holdPreview_countdown; interval: holdTimer.value
        onTriggered: {
            holdPreview = true
        }
    }

    WiresGroup {
        enabled: active

        Wire { from: "%surface%.browse.favorite"; to: "FavoriteButton" }
        Wire { from: "%surface%.browse.view"; to: "ViewButton" }
        //Dev Stuff
        Wire { from: "%surface%.display.buttons.6"; to: "FavoriteButton" }
        Wire { from: "%surface%.back"; to: "ViewButton" }

        //Browser
        WiresGroup {
            enabled: screenView.value == ScreenView.browser

            //Navigation
            Wire { from: "%surface%.browse.encoder.push"; to: SetPropertyAdapter { path: propertiesPath + ".browserEnterNode"; value: true } enabled: screenOverlay.value == Overlay.none } //this is also for loading Track to deck
            Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: propertiesPath + ".browserScroll"; mode: RelativeMode.Stepped; step: 1 } enabled: !shift }
            Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: propertiesPath + ".browserScroll"; mode: RelativeMode.Stepped; step: browserRows.value } enabled: shift }
            //Dev Stuff
            Wire { from: "%surface%.browse.push"; to: SetPropertyAdapter { path: propertiesPath + ".browserEnterNode"; value: true } enabled: screenOverlay.value == Overlay.none } //this is also for loading Track to deck
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: propertiesPath + ".browserScroll"; mode: RelativeMode.Stepped; step: 1 } enabled: !shift }
            Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: propertiesPath + ".browserScroll"; mode: RelativeMode.Stepped; step: browserRows.value } enabled: shift }

            //Dismiss warning message while browsing
            Wire { from: "%surface%.browse.encoder.push"; to: SetPropertyAdapter { path: propertiesPath + ".overlay"; value: Overlay.none } enabled: screenOverlay.value == Overlay.browserWarnings }

            //Preview Player
            Wire { from: "%surface%.browse.preview"; to: "PreviewButton" }
            Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: seekPreviewPlayer.path; step: 0.01; mode: RelativeMode.Stepped } enabled: holdPreview && previewPlayerIsLoaded.value }
            Wire { from: "%surface%.browse.encoder.push"; to: SetPropertyAdapter { path: seekPreviewPlayer.path; value: 0 } enabled: holdPreview && previewPlayerIsLoaded.value }

            //Favorites
            Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled: holdFavorite }

            //Preparation List Button
            Wire { from: "%surface%.browse.add_to_list"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.toggle" } enabled: !shift && browserIsContentList.value }
            Wire { from: "%surface%.browse.add_to_list"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } enabled: shift }
        }

        //Deck
        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            //Screen Browser Disabled
            WiresGroup {
                enabled: !browserInScreens.value

                //Navigation
                WiresGroup {
                    enabled: !holdPreview && !holdFavorite

                    Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.selected" } }
                    Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation"; enabled: !shift }
                    Wire { from: "%surface%.browse.encoder"; to: "browser.tree_navigation"; enabled: shift }
                }

                //Preview Player
                Wire { from: "%surface%.browse.preview"; to: "PreviewButton" }
                Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: seekPreviewPlayer.path; step: 0.01; mode: RelativeMode.Stepped } enabled: holdPreview && previewPlayerIsLoaded.value }
                Wire { from: "%surface%.browse.encoder.push"; to: SetPropertyAdapter { path: seekPreviewPlayer.path; value: 0 } enabled: holdPreview && previewPlayerIsLoaded.value }

                //Favorites
                Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled: holdFavorite }

                //Preparation List Button
                Wire { from: "%surface%.browse.add_to_list"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.toggle" } enabled: !shift && browserIsContentList.value }
                Wire { from: "%surface%.browse.add_to_list"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } enabled: shift }
            }

            //Screen Browser Enabled
            WiresGroup {
                enabled: browserInScreens.value

                WiresGroup {
                    enabled: !holdMaster.value && !slotState.value //replace with !side.focusedSlotState
                    //Dev Stuff
                    Wire { from: "%surface%.browse.push"; to: ButtonScriptAdapter { onPress: { browserIsTemporary.value = false; screenView.value = ScreenView.browser } } enabled: !showBrowserOnTouch.value && screenOverlay.value == Overlay.none && !shift}

                    //Open Browser
                    Wire { from: "%surface%.browse.encoder.push"; to: ButtonScriptAdapter { onPress: { browserIsTemporary.value = false; screenView.value = ScreenView.browser } } enabled: !showBrowserOnTouch.value && screenOverlay.value == Overlay.none && !shift}
                    WiresGroup {
                        enabled: showBrowserOnTouch.value
                        Wire { from: "%surface%.browse.touch"; to: "BrowserLeaveTimer.input";  enabled: screenOverlay.value == Overlay.none }
                        Wire {
                            enabled: screenView.value  == ScreenView.browser;
                            from: Or {
                                inputs:
                                [
                                    "%surface%.browse.encoder.touch",
                                    "%surface%.browse.encoder.is_turned",
                                    "%surface%.browse.encoder.push"
                                ]
                            }
                            to: "BrowserLeaveTimer.input"
                        }
                    }

                    WiresGroup {
                        enabled: !showBrowserOnTouch.value

                        //Default Encoder Mode
                        WiresGroup {
                            enabled: screenOverlay.value == Overlay.none

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

/*
                            //BPM adjustment
                            WiresGroup {
                                enabled: ((masterId.value == (deckId-1) || isSyncEnabled.value == false) && fixBPMControl.value) || !fixBPMControl.value
                                Wire { from: "%surface%.browse.encoder"; to: "tempo.coarse"; enabled: (!shift && browseEncoder.value == 0) || (shift && shiftBrowseEncoder.value == 0) }
                                Wire { from: "%surface%.browse.encoder"; to: "tempo.fine"; enabled: (!shift && browseEncoder.value == 1) || (shift && shiftBrowseEncoder.value == 1) }
                            }
*/

                            //Zoom
                            WiresGroup {
                                enabled: editMode.value == EditMode.disabled && (deck.deckType == DeckType.Track || deck.deckType == DeckType.Stem)
                                Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: deckSettingsPath + ".waveform_zoom"; step: 1; mode: RelativeMode.Stepped } enabled: (!shift && browseEncoder.value == 2) || (shift && shiftBrowseEncoder.value == 2) }
                                Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.waveform_zoom"; step: 0.25; mode: RelativeMode.Stepped } enabled: (!shift && browseEncoder.value == 3) || (shift && shiftBrowseEncoder.value == 3) }
                            }
                        }
                    }
                }

                WiresGroup {
                    enabled: holdMaster.value
                    Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: "app.traktor.masterclock.tempo"; step: 1; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.browse.encoder.push"; to: TogglePropertyAdapter { path: "app.traktor.masterclock.mode" } }
                }
            }
        }

        //FX Settings
        WiresGroup {
            enabled: screenView.value == ScreenView.fxSettings
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: propertiesPath + ".fxSettingsNavigation"; step: 1; mode: RelativeMode.Stepped } }
            Wire { from: "%surface%.browse.encoder.push"; to: TogglePropertyAdapter { path: propertiesPath + ".fxSettingsPush" } }
        }

        //Settings
        WiresGroup {
            enabled: screenView.value == ScreenView.settings

            //Preferences Navigation
            Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: propertiesPath + ".preferencesNavigation"; step: 1; mode: RelativeMode.Stepped } }
            Wire { from: "%surface%.browse.encoder.push"; to: TogglePropertyAdapter { path: propertiesPath + ".preferencesPush" } }
            //Dev Stuff
            Wire { from: "%surface%.browse"; to: RelativePropertyAdapter { path: propertiesPath + ".preferencesNavigation"; step: 1; mode: RelativeMode.Stepped } }
            Wire { from: "%surface%.browse.push"; to: TogglePropertyAdapter { path: propertiesPath + ".preferencesPush" } }

            //Preferences Numerical Option Selectors
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.jogwheelTension"; step: 1; mode: RelativeMode.Stepped } enabled: jogwheelTensionEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.1.deckColor"; step: 1; mode: RelativeMode.Stepped } enabled: deckALEDEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.2.deckColor"; step: 1; mode: RelativeMode.Stepped } enabled: deckBLEDEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.3.deckColor"; step: 1; mode: RelativeMode.Stepped } enabled: deckCLEDEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.4.deckColor"; step: 1; mode: RelativeMode.Stepped } enabled: deckDLEDEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.led_on_brightness"; step: 1; mode: RelativeMode.Stepped } enabled: onBrightnessEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.led_dimmed_percentage"; step: 1; mode: RelativeMode.Stepped } enabled: dimmedBrightnessEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.vinylBreakDurationInBeats"; step: 1; mode: RelativeMode.Stepped } enabled: vinylBreakDurationInBeatsEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.vinylBreakDurationInSeconds"; step: 100; mode: RelativeMode.Stepped } enabled: vinylBreakDurationInSecondsEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.waveformOffset"; step: 1; mode: RelativeMode.Stepped } enabled: waveformOffsetEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.beatsxPhrase"; step: 1; mode: RelativeMode.Stepped } enabled: beatsxPhraseEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.browserRows"; step: 1; mode: RelativeMode.Stepped } enabled: browserRowsEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.waveformColor"; step: 1; mode: RelativeMode.Stepped } enabled: waveformColorEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.gridMode"; step: 1; mode: RelativeMode.Stepped } enabled: gridModeEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.beatCounterMode"; step: 1; mode: RelativeMode.Stepped } enabled: beatCounterModeEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: EncoderScriptAdapter { onIncrement: { (perfectTempoMatchLimit.value < regularTempoMatchLimit.value -1) ? (perfectTempoMatchLimit.value = perfectTempoMatchLimit.value + 1) : "" } onDecrement: { (perfectTempoMatchLimit.value > 0) ? (perfectTempoMatchLimit.value = perfectTempoMatchLimit.value - 1) : "" } } enabled: perfectTempoMatchLimitEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: EncoderScriptAdapter { onIncrement: { (regularTempoMatchLimit.value > 49) ? "" : regularTempoMatchLimit.value = regularTempoMatchLimit.value + 1 } onDecrement: { (regularTempoMatchLimit.value > perfectTempoMatchLimit.value + 1) ? (regularTempoMatchLimit.value = regularTempoMatchLimit.value - 1) : "" } } enabled: regularTempoMatchLimitEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.browserTimer"; step: 100; mode: RelativeMode.Stepped } enabled: browserTimerEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.overlayTimer"; step: 100; mode: RelativeMode.Stepped } enabled: overlayTimerEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.hotcueTypeTimer"; step: 100; mode: RelativeMode.Stepped } enabled: hotcueTypeTimerEditor.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: "mapping.settings.holdTimer"; step: 50; mode: RelativeMode.Stepped } enabled: holdTimerEditor.value }

            //Disable Editor when pressing back or closing preferences
            WiresGroup {
                enabled: integerEditor.value
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".nudgeSensivity_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".jogwheelTension_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".deckALED_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".deckBLED_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".deckCLED_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".deckDLED_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".onBrightness_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".dimmedBrightness_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".vinylBreakDurationInBeats_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".vinylBreakDurationInSeconds_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".waveformOffset_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".beatsxPhrase_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".browserRows_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".waveformColor_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".gridMode_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".beatCounterMode_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".perfectTempoMatchLimit_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".regularTempoMatchLimit_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".browserTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".overlayTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".hotcueTypeTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".holdTimer_editor"; value: false; output: false } }
                Wire { from: "%surface%.browse.favorite"; to: SetPropertyAdapter { path: propertiesPath + ".integer_editor"; value: false; output: false } }
            }
        }
    }

    WiresGroup {
        enabled: deck.remixControlled && screenView.value == ScreenView.deck

/*
        //Remix Deck
        WiresGroup {
            enabled: holdSamples.value && (hasRMXControls || hasSQCRControls)

            //Remix page scroll
            WiresGroup {
                enabled: !sequencerMode.value

                Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: deckPropertiesPath + ".remixPadsControl"; step: 1; mode: RelativeMode.Stepped } enabled: legacyRemixMode.value }
                Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.page"; step: 1; mode: RelativeMode.Stepped } enabled: !legacyRemixMode.value }
                //The following 4 lines are necessary to update the remixPadsControl property
                Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: deckPropertiesPath + ".remixPadsFocus"; value: 1; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 2 }
                Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: deckPropertiesPath + ".remixPadsFocus"; value: 2; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 1 && remixPadsControl.value != 1 }
                Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: deckPropertiesPath + ".remixPadsFocus"; value: 2; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 1 }
                Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: deckPropertiesPath + ".remixPadsFocus"; value: 1; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 2 && remixPadsControl.value != 8 }
            }

            //Sequencer beats selector (1-8 or 9-16)
            WiresGroup {
                enabled: sequencerMode.value
                Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: deckPropertiesPath + ".sequencerPage"; value: 1 } }
                Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: deckPropertiesPath + ".sequencerPage"; value: 2 } }
            }
        }
*/
        //Legacy Remix Selected Samples
        WiresGroup {
            enabled: activePadsMode.value == PadsMode.legacyRemix && holdSamples.value
            Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: deckPropertiesPath + ".remixPadsControl"; mode: RelativeMode.Stepped; step: 1 } enabled: legacyRemixMode.value }
        }

        //Select Sequencer Sample
        WiresGroup {
            enabled: activePadsMode.value == PadsMode.remix
            Wire { from: "%surface%.browse.encoder.turn"; to: "triggering.1.selected_cell"; enabled: slot1Selected.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: "triggering.2.selected_cell"; enabled: slot2Selected.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: "triggering.3.selected_cell"; enabled: slot3Selected.value }
            Wire { from: "%surface%.browse.encoder.turn"; to: "triggering.4.selected_cell"; enabled: slot4Selected.value }
        }

        //Select Remix Capture Source
        WiresGroup {
            enabled: deck.holdRec
            Wire { from: "%surface%.browse.encoder.turn"; to: "remix.capture_source" }
        }
    }
}
