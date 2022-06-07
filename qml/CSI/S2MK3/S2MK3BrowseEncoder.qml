import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    //Necessary due to the Relative Property not reading correctly the step BPM/Tempo values
    AppProperty { id: bpm; path: "app.traktor.decks." + deckId + ".tempo.adjust_bpm" }
    AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.absolute" }

    Browser { name: "browser" }
    DeckTempo { name: "tempo"; channel: deckId }
    RemixDeck { name: "remix"; channel: deckId; size: RemixDeck.Small }
    RemixTrigger { name: "triggering"; channel: deckId; target: RemixTrigger.StepSequencer }

    AppProperty { id: fullscreenBrowser; path:"app.traktor.browser.full_screen";
        onValueChanged: {
            if (!fullscreenBrowser.value) permanentBrowser = false
        }
    }

    MappingPropertyDescriptor { id: encoderInteraction; path: deckPropertiesPath + ".browser.interaction"; type: MappingPropertyDescriptor.Boolean; value: false;
        onValueChanged: {
            if (autocloseBrowser.value) browserLeaveTimer.restart()
        }
    }
    Timer { id: browserLeaveTimer; interval: browserTimer.value;
        onTriggered: {
            if (autocloseBrowser.value && fullscreenBrowser.value) {
                if (encoderInteraction.value) browserLeaveTimer.restart()
                else fullscreenBrowser.value = false
            }
        }
    }

    property bool gridTriggers: false //to make the LED bright when pressed
    property bool permanentBrowser: false
    property bool holdView: false
    ButtonScriptAdapter {
        name: "ViewButton"
        brightness: fullscreenBrowser.value || holdView
        onPress: {
            holdView_countdown.restart()
        }
        onRelease: {
            if (holdView_countdown.running) {
                if (!shift) {
                    if (fullscreenBrowser.value) {
                        fullscreenBrowser.value = false
                    }
                    else {
                        fullscreenBrowser.value = true
                        if (showBrowserOnTouch.value) permanentBrowser = true
                        else if (autocloseBrowser.value) browserLeaveTimer.restart()
                    }
                }
                if (shift) {
                    navigateFavoritesOnShiftSetting.value = !navigateFavoritesOnShiftSetting.value
                    //change DAW vs track style for stem decks?
                }
            }
            holdView_countdown.stop()
            holdView = false
        }
    }
    Timer { id: holdView_countdown; interval: holdTimer.value
        onTriggered: {
            holdView = true
        }
    }

    WiresGroup {
        enabled: active

        Wire { from: "%surface%.browse.mode"; to: "ViewButton" }

        WiresGroup {
            enabled: !browserOnFullScreenOnly.value

            //Browser on touch
            Wire { from: "%surface%.browse.encoder.touch"; to: SetPropertyAdapter { path: fullscreenBrowser.path; value: true } enabled: showBrowserOnTouch.value && !fullscreenBrowser.value }

            //Autoclose Browser
            Wire {
                enabled: autocloseBrowser.value && !permanentBrowser
                from: Or {
                    inputs:
                    [
                        "%surface%.browse.encoder.touch",
                        "%surface%.browse.encoder.is_turned",
                        "%surface%.browse.encoder.push",
                    ]
                }
                to: HoldPropertyAdapter { path: encoderInteraction.path; value: true }
            }

            //Navigation
            WiresGroup {
                enabled: !holdView

                Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.selected" } }
                Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation"; enabled: !shift }
                Wire { from: "%surface%.browse.encoder"; to: "browser.tree_navigation"; enabled: shift && !navigateFavoritesOnShiftSetting.value}
            }

            //Favorites
            Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled: holdView || (shift && navigateFavoritesOnShiftSetting.value) }

            //Preparation List Button (named "back" on the S2 MK3)
            //Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.toggle" } enabled: !shift && browserIsContentList.value }
            //Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } enabled: shift }
            Wire { from: "%surface%.browse.back"; to: "browser.add_remove_from_prep_list"; enabled: !shift }
            Wire { from: "%surface%.browse.back"; to: "browser.jump_to_prep_list"; enabled: shift }

        }

        WiresGroup {
            enabled: browserOnFullScreenOnly.value

            //Autoclose Browser
            Wire {
                enabled: autocloseBrowser.value && !permanentBrowser && !slotState.value
                from: Or {
                    inputs:
                    [
                        "%surface%.browse.encoder.touch",
                        "%surface%.browse.encoder.is_turned",
                        "%surface%.browse.encoder.push",
                    ]
                }
                to: HoldPropertyAdapter { path: encoderInteraction.path; value: true }
            }

            //Browser
            WiresGroup {
                enabled: fullscreenBrowser.value

                //Navigation
                WiresGroup {
                    enabled: !holdView

                    Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.selected" } }
                    Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation"; enabled: !shift }
                    Wire { from: "%surface%.browse.encoder"; to: "browser.tree_navigation"; enabled: shift && !navigateFavoritesOnShiftSetting.value}
                }

                //Favorites
                Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled: holdView || (shift && navigateFavoritesOnShiftSetting.value) }

                //Preparation List Button (named "back" on the S2 MK3)
                //Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.toggle" } enabled: !shift && browserIsContentList.value }
                //Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } enabled: shift }
                Wire { from: "%surface%.browse.back"; to: "browser.add_remove_from_prep_list"; enabled: !shift }
                Wire { from: "%surface%.browse.back"; to: "browser.jump_to_prep_list"; enabled: shift }

            }

            //Deck
            WiresGroup {
                enabled: !fullscreenBrowser.value && !slotState.value //replace with !side.focusedSlotState

                //Browser on touch
                Wire { from: "%surface%.browse.encoder.touch"; to: SetPropertyAdapter { path: fullscreenBrowser.path; value: true } enabled: showBrowserOnTouch.value && !shift }
                //Wire { from: "%surface%.browse.push"; to: SetPropertyAdapter { path: fullscreenBrowser.path; value: true } enabled: !showBrowserOnTouch.value && !shift }

                WiresGroup {
                    enabled: !showBrowserOnTouch.value || shift

                    //Browse Push
                    WiresGroup {

                        //Navigation
                        Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.selected" } enabled: !shift && browsePush.value == 0 }
                        Wire { from: "%surface%.browse.encoder.push"; to: "browser.tree_navigation"; enabled: shift && shiftBrowsePush.value == 0 && !navigateFavoritesOnShiftSetting.value}

                        //Duplicate Decks
                        WiresGroup {
                            enabled: (!shift && browsePush.value == 1) || (shift && shiftBrowsePush.value == 1)

                            Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.2" } enabled: deckId == 1 }
                            Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.duplicate_deck.1" } enabled: deckId == 2 }
                        }

                        //Load Previous/Next Track
                        Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.next" } enabled: (!shift && browsePush.value == 2) || (shift && shiftBrowsePush.value == 2) }
                        Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".load.previous" } enabled: (!shift && browsePush.value == 3) || (shift && shiftBrowsePush.value == 3) }

                        //BPM/Tempo Reset
                        Wire { from: "%surface%.browse.encoder.push"; to: "tempo.reset"; enabled: (!shift && browsePush.value == 4) || (shift && shiftBrowsePush.value == 4) }

                        //Preview Player
                        Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.browser.preview_player.load_or_play" } enabled: (!shift && browsePush.value == 5) || (shift && shiftBrowsePush.value == 5) }
                        Wire { from: "%surface%.browse.encoder.push"; to: TogglePropertyAdapter { path: "app.traktor.browser.preview_player.play" } enabled: (!shift && browsePush.value == 6) || (shift && shiftBrowsePush.value == 6) }
                    }

                    //Browse Turn
                    WiresGroup {

                        //BPM & Tempo adjustment (without needing to open the BPM Overlay)
                        WiresGroup {
                            enabled: ((masterId.value == (deckId-1) || isSyncEnabled.value == false) && fixBPMControl.value) || !fixBPMControl.value
                            //Wire { from: "%surface%.back";   to: "tempo.reset"; enabled: browseEncoder.value == 0 || browseEncoder.value == 1 }
                            Wire { from: "%surface%.browse.encoder"; to: EncoderScriptAdapter { onIncrement: bpm.value = bpm.value + stepBpm.value; onDecrement: bpm.value = bpm.value - stepBpm.value } enabled: !shift && browseEncoder.value == 0 }
                            Wire { from: "%surface%.browse.encoder"; to: EncoderScriptAdapter { onIncrement: bpm.value = bpm.value + stepShiftBpm.value; onDecrement: bpm.value = bpm.value - stepShiftBpm.value } enabled: shift && shiftBrowseEncoder.value == 0 }
                            Wire { from: "%surface%.browse.encoder"; to: EncoderScriptAdapter { onIncrement: tempo.value = tempo.value + stepTempo.value; onDecrement: tempo.value = tempo.value - stepTempo.value } enabled: !shift && browseEncoder.value == 1 }
                            Wire { from: "%surface%.browse.encoder"; to: EncoderScriptAdapter { onIncrement: tempo.value = tempo.value + stepShiftTempo.value; onDecrement: tempo.value = tempo.value - stepShiftTempo.value } enabled: shift && shiftBrowseEncoder.value == 1 }
                        }

                        //Zoom
                        Wire { from: "%surface%.browse.encoder"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.waveform_zoom"; step: 0.25; mode: RelativeMode.Stepped } enabled: hasTrackProperties && ((!shift && browseEncoder.value == 2) || (shift && shiftBrowseEncoder.value == 2)) }

                        //Navigation
                        Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation"; enabled: !shift && browseEncoder.value == 3 }
                        Wire { from: "%surface%.browse.encoder"; to: "browser.tree_navigation"; enabled: shift && shiftBrowseEncoder.value == 3 && !navigateFavoritesOnShiftSetting.value}
                        Wire { from: "%surface%.browse.encoder"; to: "browser.favorites_navigation"; enabled: shift && shiftBrowseEncoder.value == 3 && navigateFavoritesOnShiftSetting.value }
                    }
                }
            }

            //Set/Delete Grid
            WiresGroup {
                enabled: !gridLock.value

                WiresGroup {
                    enabled: !holdGrid.value

                    Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.gridmarker.set"; output: false } enabled: !shift }
                    Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.gridmarker.delete"; output: false } enabled: shift }
                    Wire { from: "%surface%.browse.back"; to: ButtonScriptAdapter { brightness: gridTriggers; onPress: { gridTriggers = true } onRelease: gridTriggers = false } }
                }
                Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.set_autogrid" } enabled: holdGrid.value }
                //Wire { from: "%surface%.browse.back"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.reset_bpm" } enabled: !shift || !editZoomControls }
            }
        }
    }

    WiresGroup {
        enabled: deck.remixControlled && !fullscreenBrowser.value

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
            //Wire { from: "%surface%.browse.encoder.turn"; to: RelativePropertyAdapter { path: deckPropertiesPath + ".remixPadsControl"; mode: RelativeMode.Stepped; step: 1 } enabled: legacyRemixMode.value }
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
            enabled: holdSamples.value && !slotState.value
            Wire { from: "%surface%.browse.encoder.turn"; to: "remix.capture_source" }
        }
    }
}
