import CSI 1.0

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    AppProperty { id: browserSortId; path: "app.traktor.browser.sort_id" }

    AppProperty { id: activeCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.active_cell_row" }
    AppProperty { id: activeCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.active_cell_row" }
    AppProperty { id: activeCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.active_cell_row" }
    AppProperty { id: activeCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.active_cell_row" }

    RemixDeck { name: "remix"; channel: deckId; size: RemixDeck.Small }
    RemixDeckStepSequencer { name: "remix_sequencer"; channel: deckId; size: RemixDeck.Small }
    Beatgrid { name: "grid"; channel: deckId }

    Loop { name: "loop"; channel: deckId; numberOfLeds: 1; color: LED.legacy(deckId) }
    Blinker { name: "loop_encoder_blinker"; autorun: true; color: LED.legacy(deckId) }
    Blinker { name: "loop_encoder_sequencer_blinker"; color: LED.legacy(deckId); defaultBrightness: dimmed; blinkBrightness: bright }

    AppProperty { id: favoritesSelect; path: "app.traktor.browser.favorites.select" }
    AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".running" }
    AppProperty { id: sequencerOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.on" }
    AppProperty { id: sequencerRecOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on";
        onValueChanged: {
            if (sequencerRecOn.value) {
                sequencerOn.value = true
            }
        }
    }

    MappingPropertyDescriptor { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size"; type: MappingPropertyDescriptor.Boolean; value: false }

    WiresGroup {
        enabled: active

        //Browser
        WiresGroup {
            enabled: screenView.value == ScreenView.browser && browserIsContentList.value

            Wire { from: "%surface%.encoder.push"; to: TriggerPropertyAdapter  { path:"app.traktor.browser.flip_sort_up_down" } enabled: ((!shift && loopEncoderInBrowser.value == 0) || (shift && shiftLoopEncoderInBrowser.value) == 0) && (browserSortId.value > 0) }
            Wire { from: "%surface%.encoder"; to: RelativePropertyAdapter { path: seekPreviewPlayer.path; step: 0.01; mode: RelativeMode.Stepped } enabled: (!shift && loopEncoderInBrowser.value == 1) || (shift && shiftLoopEncoderInBrowser.value == 1) }
            Wire { from: "%surface%.encoder.push"; to: TriggerPropertyAdapter   { path: "app.traktor.browser.preview_player.load_or_play" } enabled: (!shift && loopEncoderInBrowser.value == 1) || (shift && shiftLoopEncoderInBrowser.value == 1) }
        }

        //Deck
        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            WiresGroup {
                enabled: editMode.value != EditMode.full && !slotState.value

                //Default State --> Loop Mode
                WiresGroup {
                    enabled: !holdFreeze.value && !sequencerMode.value && !holdRemix.value && !holdDeck.value && !loopInAdjust.value && !loopOutAdjust.value

                    Wire { from: "%surface%.encoder"; to: "loop.autoloop"; enabled: !shift }
                    Wire { from: "%surface%.encoder"; to: "loop.move"; enabled: shift }
                    Wire { from: "loop.active"; to: "%surface%.loop.led" }

                    Wire {
                        enabled: !shift
                        from: Or {
                            inputs:
                            [
                                "%surface%.encoder.touch",
                                "%surface%.encoder.is_turned"
                            ]
                        }
                        to: HoldPropertyAdapter { path: showLoopSize.path }
                    }
                }

                //Loop In/Out Adjust with the Loop Encoder
                WiresGroup {
                    enabled: !holdFreeze.value && !sequencerMode.value && !holdRemix.value && !holdDeck.value
/*
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos"; step: 10000; mode: RelativeMode.Stepped } enabled: loopInAdjust.value }
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.length"; step: 10000; mode: RelativeMode.Stepped } enabled: loopInAdjust.value } //necessary to keep the Loop Out on the same position
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.active.length"; step: 10000; mode: RelativeMode.Stepped } enabled: loopOutAdjust.value }
*/
                }

                //Deck State --> DeckType Selector
                WiresGroup {
                    enabled: holdDeck.value && !isPlaying.value

                    /* STILL HAVE TO CREATE OVERLAY FOR THE DECK TYPE
                    Wire {
                        from: Or {
                            inputs:
                            [
                                "%surface%.encoder.touch",
                                "%surface%.encoder.is_turned"
                            ]
                        }
                        to: HoldPropertyAdapter { path: screenOverlay.path; value: Overlay.deck }
                    }
                    */
                    Wire { from: "%surface%.encoder.turn"; to: EncoderScriptAdapter { onIncrement: { deck.deckType == 3 ? deck.deckType = 0 : deck.deckType = deck.deckType + 1 } onDecrement: { deck.deckType == 0 ? deck.deckType = 3 : deck.deckType = deck.deckType - 1 } } }
                    Wire { from: "%surface%.encoder.leds";  to: "loop_encoder_blinker" }
                }

                //Freeze State --> Freeze Slicer Size
                WiresGroup {
                    enabled: holdFreeze.value //state only enabled if deck is active

                    Wire {
                        from: Or {
                            inputs:
                            [
                                "%surface%.encoder.touch",
                                "%surface%.encoder.is_turned"
                            ]
                        }
                        to: HoldPropertyAdapter { path: screenOverlay.path; value: Overlay.slice }
                    }

                    //Wire { from: "%surface%.encoder.touch"; to: ButtonScriptAdapter { onPress: { exitFreeze = false } } }
                    Wire { from: "%surface%.loop.led";  to: "loop_encoder_blinker" }
                    Wire { from: "%surface%.encoder.turn"; to: "freeze_slicer.slice_size"; enabled: !isInActiveLoop.value }
                    //Wire { from: "%surface%.encoder.turn"; to: "loop.autoloop"; enabled: isInActiveLoop.value }
                }

                //Sequencer State --> Pattern Length
                WiresGroup {
                    enabled: sequencerMode.value
                    Wire { from: "%surface%.encoder.turn"; to: "remix_sequencer.selected_slot_pattern_length"; enabled: !shift } //FIX TO EDIT SLOTS 2-4 ("app.traktor.decks.X.remix.players.Y.sequencer.pattern_length")
                    Wire { from: "%surface%.encoder.turn"; to: "remix_sequencer.all_slots_pattern_length"; enabled: shift }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.sequencer.on" } }
                    Wire { from: "loop_encoder_sequencer_blinker"; to: "%surface%.loop.led" }
                    Wire { from: "loop_encoder_sequencer_blinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: sequencerOn.value } }
                }
            }

            //Edit Mode (S5 Only)
            WiresGroup {
                enabled: editMode.value == EditMode.full

                Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: propertiesPath + ".encoderScanMode" } }
                Wire { from: "%surface%.encoder.turn"; to: EncoderScriptAdapter { onIncrement: {scanDirection.value = 4; scanUpdater.value = !scanUpdater.value} onDecrement: {scanDirection.value = -4; scanUpdater.value = !scanUpdater.value} } enabled: encoderScanMode.value }

                WiresGroup {
                    enabled: !zoomedEditView.value && !encoderScanMode.value
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_coarse"; enabled: !shift }
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_fine"; enabled: shift }
                }
                WiresGroup {
                    enabled: zoomedEditView.value && !encoderScanMode.value
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_fine"; enabled: !shift }
                    Wire { from: "%surface%.encoder.turn"; to: "grid.offset_ultrafine"; enabled: shift }
                }
            }
        }
    }

    WiresGroup {
        enabled: deck.footerControlled

        WiresGroup {
            enabled: deck.deckType == DeckType.Remix

            //Remix State --> Remix Deck Capture Source
            WiresGroup {
                enabled: holdRemix.value //state only enabled if remix is controlled
                Wire {
                    from: Or {
                        inputs:
                        [
                            //"%surface%.encoder.touch", disabled so that we can use the encoder to Toggle the Rec Mode too
                            "%surface%.encoder.is_turned"
                        ]
                    }
                    to: HoldPropertyAdapter { path: screenOverlay.path; value: Overlay.capture }
                }
                Wire { from: "%surface%.encoder.turn"; to: "remix.capture_source" }
                Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on" } } //enabled: activePadsMode.value == PadsMode.remix }
                Wire { from: "loop_encoder_blinker"; to: "%surface%.loop.led" }
            }

            //Remix Parameters
            WiresGroup {
                enabled: slotState.value && screenOverlay.value == Overlay.none

                WiresGroup {
                    enabled: slot1Selected.value

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 1 && !sequencerSampleLockSlot1.value }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot1" } enabled: performanceEncoderControls.value == 1 }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 2 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.filter_on" } enabled: performanceEncoderControls.value == 2 }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.1.rows." + (activeCell_slot1.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 3 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.key_lock" } enabled: performanceEncoderControls.value == 3 }

                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 4 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.1.fx_send_on" } enabled: performanceEncoderControls.value == 4 }
                }

                WiresGroup {
                    enabled: slot2Selected.value

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 1 && !sequencerSampleLockSlot2.value }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot2" } enabled: performanceEncoderControls.value == 1 }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 2 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.filter_on" } enabled: performanceEncoderControls.value == 2 }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.2.rows." + (activeCell_slot2.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 3 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.key_lock" } enabled: performanceEncoderControls.value == 3 }


                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 4 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.2.fx_send_on" } enabled: performanceEncoderControls.value == 4 }
                }

                WiresGroup {
                    enabled: slot3Selected.value

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 1 && !sequencerSampleLockSlot3.value }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot3" } enabled: performanceEncoderControls.value == 1 }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 2 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.filter_on" } enabled: performanceEncoderControls.value == 2 }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.3.rows." + (activeCell_slot3.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 3 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.key_lock" } enabled: performanceEncoderControls.value == 3 }

                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 4 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.3.fx_send_on" } enabled: performanceEncoderControls.value == 4 }
                }

                WiresGroup {
                    enabled: slot4Selected.value

                    //Selected sample
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.selected_cell"; step: 1; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 1 && !sequencerSampleLockSlot4.value }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".sequencerSampleLockSlot4" } enabled: performanceEncoderControls.value == 1 }

                    //Filter
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 2 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.filter_on" } enabled: performanceEncoderControls.value == 2 }

                    //Key
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.cell.columns.4.rows." + (activeCell_slot4.value+1) + ".pitch"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 3 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.key_lock" } enabled: performanceEncoderControls.value == 3 }

                    //FX
                    Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.fx_send"; step: 0.025; mode: RelativeMode.Stepped } enabled: performanceEncoderControls.value == 4 }
                    Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix.players.4.fx_send_on" } enabled: performanceEncoderControls.value == 4 }
                }
            }
        }

        WiresGroup {
            enabled: deck.deckType == DeckType.Stem

            //Stem Parameters
            WiresGroup {
                enabled: slotState.value && screenOverlay.value == Overlay.none

                WiresGroup {
                    enabled: slot1Selected.value

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.1.filter_on" } enabled: !shift }
                        WiresGroup {
                            enabled: shift
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.1.filter" }
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.1.filter_on" }
                        }
                    }
                }

                WiresGroup {
                    enabled: slot2Selected.value

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.2.filter_on" } enabled: !shift }
                        WiresGroup {
                            enabled: shift
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.2.filter" }
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.2.filter_on" }
                        }
                    }
                }

                WiresGroup {
                    enabled: slot3Selected.value

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.3.filter_on" } enabled: !shift }
                        WiresGroup {
                            enabled: shift
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.3.filter" }
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.3.filter_on" }
                        }
                    }
                }

                WiresGroup {
                    enabled: slot4Selected.value

                    //Filter
                    WiresGroup {
                        //enabled: performanceEncoderControls.value == 2

                        Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                        Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.4.filter_on" } enabled: !shift }
                        WiresGroup {
                            enabled: shift
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.4.filter" }
                            Wire { from: "%surface%.encoder.push"; to: "reset_stems.4.filter_on" }
                        }
                    }
                }
            }
        }
    }
}
