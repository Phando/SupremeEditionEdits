import CSI 1.0

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    Loop { name: "loop"; channel: deckId }
    KeyControl { name: "key_control"; channel: deckId }
    Beatgrid { name: "grid"; channel: deckId }

    WiresGroup {
        enabled: active && !slotState.value //replace with !side.focusedSlotState

        WiresGroup {
            enabled: !holdGrid.value && !holdKeyLock

            Wire { from: "%surface%.loop_size"; to: "loop.autoloop"; enabled: !shift }
            Wire { from: "%surface%.loop_size"; to: "loop.move"; enabled: shift }
        }

        WiresGroup {
            enabled: holdKeyLock

            Wire { from: "%surface%.loop_size.turn"; to: "key_control.coarse" }
            Wire { from: "%surface%.loop_size.push"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0 } }
        }

        WiresGroup {
            enabled: holdGrid.value && !gridLock.value

            Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 1; mode: RelativeMode.Stepped } enabled: !shift}
            Wire { from: "%surface%.loop_size.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm"; step: 0.05; mode: RelativeMode.Stepped } enabled: shift}
            Wire { from: "%surface%.loop_size.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.reset_bpm" } enabled: !shift }
            //Wire { from: "%surface%.loop_size.turn"; to: EncoderScriptAdapter { onIncrement: doubleBPM.value = true; onDecrement: halfBPM.value = true } }
        }
    }

    WiresGroup {
        enabled: deck.footerControlled

        WiresGroup {
            enabled: slotState.value //replace with !side.focusedSlotState

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

