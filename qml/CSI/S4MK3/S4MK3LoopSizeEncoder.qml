import CSI 1.0

import "../../Defines"
import "../../Helpers/KeySync.js" as KeySync

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
    AppProperty { id: masterKey; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.resulting.precise" }

    AppProperty { id: keyLock; path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" }
    AppProperty { id: keyAdjust; path: "app.traktor.decks." + deckId + ".track.key.adjust" }
    AppProperty { id: resultingKey; path: "app.traktor.decks." + deckId + ".track.key.resulting.precise" }

    AppProperty { id: isGridLocked; path: "app.traktor.decks." + deckId + ".track.grid.lock_bpm" }
    AppProperty { id: halfBPM; path: "app.traktor.decks." + deckId + ".track.grid.half_bpm" }
    AppProperty { id: doubleBPM; path: "app.traktor.decks." + deckId + ".track.grid.double_bpm" }

    Loop { name: "loop"; channel: deckId }
    KeyControl { name: "key_control"; channel: deckId }
    Beatgrid { name: "grid"; channel: deckId }

    MappingPropertyDescriptor { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size"; type: MappingPropertyDescriptor.Boolean; value: false }

    WiresGroup {
        enabled: active && !deck.focusedSlotstate //replace with !side.focusedSlotState

        WiresGroup {
            enabled: editMode.value == EditMode.disabled

            Wire { from: "%surface%.loop_size"; to: "loop.autoloop"; enabled: !shift }
            Wire {
                enabled: !shift
                from: Or {
                    inputs:
                    [
                        "%surface%.loop_size.touch",
                        "%surface%.loop_size.is_turned"
                    ]
                }
                to: HoldPropertyAdapter { path: showLoopSize.path }
            }
            WiresGroup {
                enabled: shift

                Wire { from: "%surface%.loop_size"; to: "key_control.coarse" }
                Wire { from: "%surface%.loop_size.push"; to: "key_control.reset"; enabled: shiftPushLoopSize.value == 0 }
                Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled_preserve_pitch" } enabled: shiftPushLoopSize.value == 1 }
                Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" } enabled: shiftPushLoopSize.value == 2 }
                Wire { from: "%surface%.loop_size.push"; to: ButtonScriptAdapter {
                        onPress: {
                            if (keyLock.value) {
                                if (KeySync.isSynchronized(resultingKeyIndex, resultingMasterKeyIndex, fuzzyKeySync.value)) keyAdjust.value = 0
                                else keyAdjust.value = keyAdjust.value + KeySync.sync(resultingKeyIndex, resultingMasterKeyIndex, fuzzyKeySync.value) + keyTextOffset
                            }
                            else {
                                // keyLocked.value = true
                                keyAdjust.value = KeySync.sync(resultingKeyIndex, resultingMasterKeyIndex, fuzzyKeySync.value) + keyTextOffset
                            }
                        }
                    }
                    enabled: shiftPushLoopSize.value == 3 && hasTrackProperties && masterId.value != -1 && (masterDeckType.value == DeckType.Track || masterDeckType.value == DeckType.Stem)
                }
            }
        }

/*
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
            //AppProperty { id: selectedHotcueType; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + selectedHotcue.value + ".type" }
            Wire { from: "%surface%.browse.turn"; to: EncoderScriptAdapter { onIncrement: { selectedHotcueType.value ==5 ? selectedHotcueType.value = selectedHotcueType.value - 5 : selectedHotcueType.value = selectedHotcueType.value + 1 } onDecrement: { selectedHotcueType.value ==0 ? selectedHotcueType.value = hotcue1Type.value + 5 : selectedHotcueType.value = selectedHotcueType.value -1 } } }
            Wire { from: "%surface%.back"; to: ButtonScriptAdapter { onPress: { selectedHotcueType.value = 0 } } }
            //Wire { from: "%surface%.back"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + selectedHotcue.value + ".type"; value: 3 } enabled: screenOverlay.value == Overlay.hotcueType }
        }
*/

        WiresGroup {
            enabled: editMode.value == EditMode.full && !isGridLocked.value

            Wire { from: "%surface%.loop_size.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.reset_bpm" } enabled: !shift }
            Wire { from: "%surface%.loop_size.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.set_autogrid" } enabled: shift }
            Wire { from: "%surface%.loop_size.turn"; to: EncoderScriptAdapter { onIncrement: doubleBPM.value = true; onDecrement: halfBPM.value = true } }

            WiresGroup {
                enabled: !zoomedEditView.value
                Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 1; mode: RelativeMode.Stepped } enabled: !shift}
                Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.05; mode: RelativeMode.Stepped } enabled: shift}
            }

            WiresGroup {
                enabled: zoomedEditView.value
                Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.05; mode: RelativeMode.Stepped } enabled: !shift}
                Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.001; mode: RelativeMode.Stepped } enabled: shift}
            }
        }
    }

    WiresGroup {
        enabled: deck.footerControlled

        WiresGroup {
            enabled: screenView.value == ScreenView.Deck && slotState.value //replace with !side.focusedSlotState

            //Remix Parameters
            WiresGroup {
                enabled: deckType == DeckType.Remix && deck.remixControlled

                WiresGroup {
                    enabled: slot1Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.1.filter_on" } }
                }

                WiresGroup {
                    enabled: slot2Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.2.filter_on" } }
                }

                WiresGroup {
                    enabled: slot3Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.3.filter_on" } }
                }

                WiresGroup {
                    enabled: slot4Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".remix_slots.4.filter_on" } }
                }
            }

            //Stem Parameters
            WiresGroup {
                enabled: deckType == DeckType.Stem && deck.footerControlled

                WiresGroup {
                    enabled: slot1Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.1.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.1.filter_on" } enabled: !shift }
                    WiresGroup {
                        enabled: shift
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.1.filter" }
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.1.filter_on" }
                    }
                }

                WiresGroup {
                    enabled: slot2Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.2.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.2.filter_on" } enabled: !shift }
                    WiresGroup {
                        enabled: shift
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.2.filter" }
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.2.filter_on" }
                    }
                }

                WiresGroup {
                    enabled: slot3Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.3.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.3.filter_on" } enabled: !shift }
                    WiresGroup {
                        enabled: shift
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.3.filter" }
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.3.filter_on" }
                    }
                }

                WiresGroup {
                    enabled: slot4Selected.value
                    Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.4.filter_value"; step: 0.025; mode: RelativeMode.Stepped } }
                    Wire { from: "%surface%.loop_size.push"; to: TogglePropertyAdapter { path:"app.traktor.decks." + deckId + ".stems.4.filter_on" } enabled: !shift }
                    WiresGroup {
                        enabled: shift
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.4.filter" }
                        Wire { from: "%surface%.loop_size.push"; to: "reset_stems.4.filter_on" }
                    }
                }
            }
        }
    }
}
