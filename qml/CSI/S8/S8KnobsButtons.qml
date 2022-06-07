import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    property int ticks: 0 //necessary for scanning sensibility in Edit Mode
    property int sensibility: 3 //1: max, then the higher, the less sensible

    AppProperty { id: fxSingleMode; path: "app.traktor.fx." + bottomFXUnit.value + ".type" }

/*
    // BETA Testing: AutoShow FX Overlays when enabling units 1-4 from software (not using FX Assign Arrows)
    AppProperty { id: fx1On; path: "app.traktor.mixer.channels.1.fx.assign." + bottomFXUnit.value; onValueChanged:
        if (fx1On.value) {
            bottomPanel.value = true //BottomPerformanceOverlay.set()
            AppBottomPerformanceOverlay.restart()
        }
    }
*/

    //Bottom Performance Overlay
    MappingPropertyDescriptor { id: bottomPanel; path: propertiesPath + ".bottomPerformanceOverlay"; type: MappingPropertyDescriptor.Boolean; value: false }
    SwitchTimer { name: "BottomPerformanceOverlay"; resetTimeout: 1000 } //Do something to reset FX timers when you touch their fx assign buttons
/*
    Timer { name: "AppBottomPerformanceOverlay"; interval: 1000;
        onTriggered: {
            bottomPanel.value = false
        }
    } //Do something to reset FX timers when you touch their fx assign buttons
*/

    RemixDeckSlots { name: "remix_slots"; channel: deckId }
    StemDeckStreams { name: "stems"; channel: deckId }
    Beatgrid { name: "grid"; channel: deckId }

    FxUnit { name: "fx1"; channel: 1 }
    FxUnit { name: "fx2"; channel: 2 }
    FxUnit { name: "fx3"; channel: 3 }
    FxUnit { name: "fx4"; channel: 4 }

    WiresGroup {
        enabled: active

        //Browser
        WiresGroup {
            enabled: screenView.value == ScreenView.browser

            //Browser Sorting
            //Wire { from: "%surface%.knobs.1"; to: "screen.browser_sorting" }
            Wire { from: "%surface%.buttons.1"; to: TriggerPropertyAdapter { path:"app.traktor.browser.flip_sort_up_down"  } enabled: browserIsContentList.value && browserSortId.value > 0 }

            //Preview Player
            Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path: seekPreviewPlayer.path; step: 0.01; mode: RelativeMode.Stepped } }
            Wire { from: "%surface%.buttons.4"; to: DirectPropertyAdapter { path: "app.traktor.browser.preview_player.load_or_play" } enabled: !shift}
            Wire { from: "%surface%.buttons.4"; to: TriggerPropertyAdapter { path:"app.traktor.decks." + deckId + ".load.from_preview_player" } enabled: shift && previewPlayerIsLoaded.value }
        }

        //Deck
        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            //Performance Controls
            WiresGroup {
                enabled: editMode.value != EditMode.full

                //MIDI Controls
                WiresGroup {
                    enabled: footerPage.value == FooterPage.midi

                    WiresGroup {
                        //enabled: screen.side == ScreenSide.Left
                        enabled: side.activeSide == ScreenSide.Left

                        Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.1" } }
                        Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.2" } }
                        Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.3" } }
                        Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.4" } }

                        Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.1" } }
                        Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.2" } }
                        Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.3" } }
                        Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.4" } }
                    }

                    WiresGroup {
                        //enabled: screen.side == ScreenSide.Right
                        enabled: side.activeSide == ScreenSide.Right

                        Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.5" } }
                        Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.6" } }
                        Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.7" } }
                        Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.midi.buttons.8" } }

                        Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.5" } }
                        Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.6" } }
                        Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.7" } }
                        Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path: "app.traktor.midi.knobs.8" } }
                    }
                }

                //Bottom FX Unit Controls
                WiresGroup {
                    enabled: footerPage.value == FooterPage.fx

                    WiresGroup {
                        enabled: bottomFXUnit.value == 1

                        Wire { from: "%surface%.knobs.1"; to: "fx1.dry_wet" }
                        Wire { from: "%surface%.knobs.2"; to: "fx1.knob1" }
                        Wire { from: "%surface%.knobs.3"; to: "fx1.knob2" }
                        Wire { from: "%surface%.knobs.4"; to: "fx1.knob3" }

                        Wire { from: "%surface%.buttons.1"; to: "fx1.enabled"; enabled: fxSingleMode.value }
                        Wire { from: "%surface%.buttons.2"; to: "fx1.button1" }
                        Wire { from: "%surface%.buttons.3"; to: "fx1.button2" }
                        Wire { from: "%surface%.buttons.4"; to: "fx1.button3" }
                    }

                    WiresGroup {
                        enabled: bottomFXUnit.value == 2

                        Wire { from: "%surface%.knobs.1"; to: "fx2.dry_wet" }
                        Wire { from: "%surface%.knobs.2"; to: "fx2.knob1" }
                        Wire { from: "%surface%.knobs.3"; to: "fx2.knob2" }
                        Wire { from: "%surface%.knobs.4"; to: "fx2.knob3" }

                        Wire { from: "%surface%.buttons.1"; to: "fx2.enabled"; enabled: fxSingleMode.value }
                        Wire { from: "%surface%.buttons.2"; to: "fx2.button1" }
                        Wire { from: "%surface%.buttons.3"; to: "fx2.button2" }
                        Wire { from: "%surface%.buttons.4"; to: "fx2.button3" }
                    }

                    WiresGroup {
                        enabled: bottomFXUnit.value == 3

                        Wire { from: "%surface%.knobs.1"; to: "fx3.dry_wet" }
                        Wire { from: "%surface%.knobs.2"; to: "fx3.knob1" }
                        Wire { from: "%surface%.knobs.3"; to: "fx3.knob2" }
                        Wire { from: "%surface%.knobs.4"; to: "fx3.knob3" }

                        Wire { from: "%surface%.buttons.1"; to: "fx3.enabled"; enabled: fxSingleMode.value }
                        Wire { from: "%surface%.buttons.2"; to: "fx3.button1" }
                        Wire { from: "%surface%.buttons.3"; to: "fx3.button2" }
                        Wire { from: "%surface%.buttons.4"; to: "fx3.button3" }
                    }

                    WiresGroup {
                        enabled: bottomFXUnit.value == 4

                        Wire { from: "%surface%.knobs.1"; to: "fx4.dry_wet" }
                        Wire { from: "%surface%.knobs.2"; to: "fx4.knob1" }
                        Wire { from: "%surface%.knobs.3"; to: "fx4.knob2" }
                        Wire { from: "%surface%.knobs.4"; to: "fx4.knob3" }

                        Wire { from: "%surface%.buttons.1"; to: "fx4.enabled"; enabled: fxSingleMode.value }
                        Wire { from: "%surface%.buttons.2"; to: "fx4.button1" }
                        Wire { from: "%surface%.buttons.3"; to: "fx4.button2" }
                        Wire { from: "%surface%.buttons.4"; to: "fx4.button3" }
                    }
                }

                //Bottom Performance Overlay
                WiresGroup {
                    enabled: showBottomPanelOnTouch.value && footerHasContent.value

                    //Bottom Performance Overlay should pop-up when switching between pages
                    Wire {
                        enabled: footerHasContentToSwitch.value
                        from: Or {
                            inputs:
                            [
                            "%surface%.display.buttons.4",
                            "%surface%.display.buttons.8"
                            ]
                        }
                        to: "BottomPerformanceOverlay.input"
                    }

                    /*
                    //Show Bottom Info Panel when touching faders
                    Wire {
                        enabled: footerPage.value != FooterPage.fx
                        from: Or {
                            inputs:
                            [
                            "%surface%.faders.1.touch",
                            "%surface%.faders.2.touch",
                            "%surface%.faders.3.touch",
                            "%surface%.faders.4.touch"
                            ]
                        }
                        to: "BottomPerformanceOverlay.input"
                    }
                    */

                    //Bottom Performance Overlay should pop-up when touching knobs/pressing buttons
                    Wire {
                        from: Or {
                            inputs:
                            [
                            "%surface%.knobs.1.touch",
                            "%surface%.knobs.2.touch",
                            "%surface%.knobs.3.touch",
                            "%surface%.knobs.4.touch",
                            "%surface%.buttons.1",
                            "%surface%.buttons.2",
                            "%surface%.buttons.3",
                            "%surface%.buttons.4"
                            ]
                        }
                        to: "BottomPerformanceOverlay.input"
                    }

                    //Bottom Performance Overlay should pop up when assigning the FX Unit to a deck
                    WiresGroup {
                        enabled: footerPage.value == FooterPage.fx

                        Wire {
                            enabled: (bottomFXUnit.value == 1 && !globalShift.value) || (bottomFXUnit.value == 3 && globalShift.value)
                            from: Or {
                                inputs:
                                [
                                "s8.mixer.channels.1.fx.assign.1",
                                "s8.mixer.channels.2.fx.assign.1",
                                "s8.mixer.channels.3.fx.assign.1",
                                "s8.mixer.channels.4.fx.assign.1"
                                ]
                            }
                            to: "BottomPerformanceOverlay.input"
                        }
                        Wire {
                            enabled: (bottomFXUnit.value == 2 && !globalShift.value) || (bottomFXUnit.value == 4 && globalShift.value)
                            from: Or {
                                inputs:
                                [
                                "s8.mixer.channels.1.fx.assign.2",
                                "s8.mixer.channels.2.fx.assign.2",
                                "s8.mixer.channels.3.fx.assign.2",
                                "s8.mixer.channels.4.fx.assign.2"
                                ]
                            }
                            to: "BottomPerformanceOverlay.input"
                        }
                    }
                }
                Wire { from: "BottomPerformanceOverlay.output"; to: DirectPropertyAdapter{ path: bottomPanel.path } }
            }

            //Edit Mode Controls
            WiresGroup {
                enabled: editMode.value == EditMode.full

                Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: propertiesPath + ".beatgrid.zoomed_view" } }
                //Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path: propertiesPath + ".beatgrid.scan_direction"; step: 1; mode: RelativeMode.Stepped } }
                Wire { from: "%surface%.knobs.3"; to: EncoderScriptAdapter { onIncrement: { scanDirection.value = 4; ticks=ticks+1; if (ticks%sensibility == 0) {scanUpdater.value = !scanUpdater.value}} onDecrement: {scanDirection.value = -4; ticks=ticks-1; if (ticks%sensibility == 0) {scanUpdater.value = !scanUpdater.value}} } }
                Wire { from: "%surface%.knobs.4.touch"; to: "grid.tap"; enabled: !gridLock.value }
                Wire { from: "%surface%.buttons.4"; to: "grid.tap"; enabled: !gridLock.value }

                WiresGroup {
                    enabled: !zoomedEditView.value

                    Wire { from: "%surface%.knobs.1"; to: "grid.offset_fine"; enabled: shift }
                    Wire { from: "%surface%.knobs.1"; to: "grid.offset_coarse"; enabled: !shift }
                    Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 1; mode: RelativeMode.Stepped } enabled: !shift}
                    Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.05; mode: RelativeMode.Stepped } enabled: shift}
                }

                WiresGroup {
                    enabled: zoomedEditView.value

                    Wire { from: "%surface%.knobs.1"; to: "grid.offset_ultrafine"; enabled: shift }
                    Wire { from: "%surface%.knobs.1"; to: "grid.offset_fine"; enabled: !shift }
                    Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.05; mode: RelativeMode.Stepped } enabled: !shift}
                    Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.001; mode: RelativeMode.Stepped } enabled: shift}
                }
            }
        }

        //FX Settings
        WiresGroup {
            enabled: screenView.value == ScreenView.fxSettings

            Wire { from: "%surface%.buttons.1"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 5 } }
            Wire { from: "%surface%.buttons.2"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 6 } enabled: hasFXFooter.value }
            Wire { from: "%surface%.buttons.3"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 7 } enabled: hasFXFooter.value && !fxSingleMode.value }
            Wire { from: "%surface%.buttons.4"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 8 } enabled: hasFXFooter.value && !fxSingleMode.value }
        }
    }

    WiresGroup {
        enabled: deck.footerControlled

        WiresGroup {
            enabled: screenView.value == ScreenView.deck && editMode.value != EditMode.full

            //Stem Deck Controls
            WiresGroup {
                enabled: deck.deckType == DeckType.Stem

                WiresGroup {
                    enabled: footerPage.value == FooterPage.fxSend

                    Wire { from: "%surface%.knobs.1"; to: "stems.1.fx_send" }
                    Wire { from: "%surface%.knobs.2"; to: "stems.2.fx_send" }
                    Wire { from: "%surface%.knobs.3"; to: "stems.3.fx_send" }
                    Wire { from: "%surface%.knobs.4"; to: "stems.4.fx_send" }

                    Wire { from: "%surface%.buttons.1"; to: "stems.1.fx_send_on" }
                    Wire { from: "%surface%.buttons.2"; to: "stems.2.fx_send_on" }
                    Wire { from: "%surface%.buttons.3"; to: "stems.3.fx_send_on" }
                    Wire { from: "%surface%.buttons.4"; to: "stems.4.fx_send_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.filter

                    Wire { from: "%surface%.knobs.1"; to: "stems.1.filter" }
                    Wire { from: "%surface%.knobs.2"; to: "stems.2.filter" }
                    Wire { from: "%surface%.knobs.3"; to: "stems.3.filter" }
                    Wire { from: "%surface%.knobs.4"; to: "stems.4.filter" }

                    Wire { from: "%surface%.buttons.1"; to: "stems.1.filter_on" }
                    Wire { from: "%surface%.buttons.2"; to: "stems.2.filter_on" }
                    Wire { from: "%surface%.buttons.3"; to: "stems.3.filter_on" }
                    Wire { from: "%surface%.buttons.4"; to: "stems.4.filter_on" }
                }
            }

            //Remix Deck Controls
            WiresGroup {
                enabled: deck.deckType == DeckType.Remix

                WiresGroup {
                    enabled: footerPage.value == FooterPage.fxSend

                    Wire { from: "%surface%.knobs.1"; to: "remix_slots.1.fx_send" }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.2.fx_send" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.3.fx_send" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.4.fx_send" }

                    Wire { from: "%surface%.buttons.1"; to: "remix_slots.1.fx_send_on" }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.2.fx_send_on" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.3.fx_send_on" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.4.fx_send_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.filter

                    Wire { from: "%surface%.knobs.1"; to: "remix_slots.1.filter" }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.2.filter" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.3.filter" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.4.filter" }

                    Wire { from: "%surface%.buttons.1"; to: "remix_slots.1.filter_on" }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.2.filter_on" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.3.filter_on" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.4.filter_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.pitch

                    Wire { from: "%surface%.knobs.1"; to: "remix_slots.1.pitch" }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.2.pitch" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.3.pitch" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.4.pitch" }

                    Wire { from: "%surface%.buttons.1"; to: "remix_slots.1.key_lock" }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.2.key_lock" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.3.key_lock" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.4.key_lock" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.slot1

                    Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot1.value }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.1.filter" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.1.pitch" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.1.fx_send" }

                    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot1.path } }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.1.filter_on" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.1.key_lock" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.1.fx_send_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.slot2

                    Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot2.value }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.2.filter" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.2.pitch" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.2.fx_send" }

                    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot2.path } }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.2.filter_on" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.2.key_lock" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.2.fx_send_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.slot3

                    Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot3.value }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.3.filter" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.3.pitch" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.3.fx_send" }

                    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot3.path } }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.3.filter_on" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.3.key_lock" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.3.fx_send_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.slot4

                    Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot4.value }
                    Wire { from: "%surface%.knobs.2"; to: "remix_slots.4.filter" }
                    Wire { from: "%surface%.knobs.3"; to: "remix_slots.4.pitch" }
                    Wire { from: "%surface%.knobs.4"; to: "remix_slots.4.fx_send" }

                    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot4.path } }
                    Wire { from: "%surface%.buttons.2"; to: "remix_slots.4.filter_on" }
                    Wire { from: "%surface%.buttons.3"; to: "remix_slots.4.key_lock" }
                    Wire { from: "%surface%.buttons.4"; to: "remix_slots.4.fx_send_on" }
                }

                WiresGroup {
                    enabled: footerPage.value == FooterPage.slots

                    WiresGroup {
                        enabled: slot1Selected.value

                        //Selected sample
                        Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot1.value }
                        Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot1.path } }

                        //Filter
                        Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.filter_on" } }

                        //Key
                        Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.1.rows." + (activeCell_slot1.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.key_lock" } }

                        //FX
                        Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.fx_send"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.fx_send_on" } }
                    }

                    WiresGroup {
                        enabled: slot2Selected.value

                        //Selected sample
                        Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot2.value }
                        Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot2.path } }

                        //Filter
                        Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.filter_on" } }

                        //Key
                        Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.2.rows." + (activeCell_slot2.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.key_lock" } }

                        //FX
                        Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.fx_send"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.fx_send_on" } }
                    }

                    WiresGroup {
                        enabled: slot3Selected.value

                        //Selected sample
                        Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot3.value }
                        Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot3.path } }

                        //Filter
                        Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.filter_on" } }

                        //Key
                        Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.3.rows." + (activeCell_slot3.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.key_lock" } }

                        //FX
                        Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.fx_send"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.fx_send_on" } }
                    }


                    WiresGroup {
                        enabled: slot4Selected.value

                        //Selected sample
                        Wire { from: "%surface%.knobs.1"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.selected_cell"; scaleFactor: 0.6 } enabled: !sequencerSampleLockSlot4.value }
                        Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: sequencerSampleLockSlot4.path } }

                        //Filter
                        Wire { from: "%surface%.knobs.2"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.filter_on" } }

                        //Key
                        Wire { from: "%surface%.knobs.3"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.4.rows." + (activeCell_slot4.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.key_lock" } }

                        //FX
                        Wire { from: "%surface%.knobs.4"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.fx_send"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.fx_send_on" } }
                    }
                }
            }
        }
    }
}
