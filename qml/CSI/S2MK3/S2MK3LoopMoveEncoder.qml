import CSI 1.0

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    Loop { name: "loop"; channel: deckId }

    WiresGroup {
        enabled: active

        Wire { from: "%surface%.loop_move"; to: "loop.move"; enabled: !shift }
        Wire { from: "%surface%.loop_move"; to: "loop.one_beat_move"; enabled: shift }
    }

    Loop { name: "loop"; channel: deckId }
    Beatgrid { name: "grid"; channel: deckId }

    WiresGroup {
        enabled: active && !slotState.value //replace with !side.focusedSlotState

        WiresGroup {
            enabled: !holdGrid.value && (!holdKeyLock.value && activePadsMode.value == PadsMode.tonePlay) && (!holdSamples.value && (activePadsMode.value == PadsMode.legacyRemix || activePadsMode.value == PadsMode.remix))

            Wire { from: "%surface%.loop_move"; to: "loop.move"; enabled: !shift }
            Wire { from: "%surface%.loop_move"; to: "loop.one_beat_move"; enabled: shift }
        }

        WiresGroup {
            enabled: holdGrid.value

            Wire { from: "%surface%.loop_move"; to: "grid.offset_coarse"; enabled: !shift }
            Wire { from: "%surface%.loop_move"; to: "grid.offset_fine"; enabled: shift }
        }

        Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: deckPropertiesPath + ".tonePlayMode"; step: 1; mode: RelativeMode.Stepped } enabled: holdKeyLock && activePadsMode.value == PadsMode.tonePlay }
        Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: remixPadsControl.path; step: 1; mode: RelativeMode.Stepped } enabled: holdSamples.value && (activePadsMode.value == PadsMode.legacyRemix || activePadsMode.value == PadsMode.remix) }
    }

    WiresGroup {
        enabled: deck.footerControlled

        WiresGroup {
            enabled: slotState.value //replace with !side.focusedSlotState

            //RMX Slots Volume Control
            WiresGroup {
                enabled: deck.deckType == DeckType.Remix

                //Volume
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix_slots.1.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot1Selected.value }
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix_slots.2.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot2Selected.value }
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix_slots.3.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot3Selected.value }
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix_slots.4.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot4Selected.value }

                //Mute
                Wire { from: "%surface%.loop_move.push"; to: "remix_slots.1.muted"; enabled: slot1Selected.value }
                Wire { from: "%surface%.loop_move.push"; to: "remix_slots.2.muted"; enabled: slot2Selected.value }
                Wire { from: "%surface%.loop_move.push"; to: "remix_slots.3.muted"; enabled: slot3Selected.value }
                Wire { from: "%surface%.loop_move.push"; to: "remix_slots.4.muted"; enabled: slot4Selected.value }
            }

            //Stem Slots Volume Control
            WiresGroup {
                enabled: deck.deckType == DeckType.Stem

                //Volume
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".stems.1.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot1Selected.value }
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".stems.2.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot2Selected.value }
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".stems.3.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot3Selected.value }
                Wire { from: "%surface%.loop_move.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".stems.4.volume"; step: 0.025; mode: RelativeMode.Stepped } enabled: slot4Selected.value }

                //Mute
                Wire { from: "%surface%.loop_move.push"; to: "stems.1.muted"; enabled: slot1Selected.value }
                Wire { from: "%surface%.loop_move.push"; to: "stems.2.muted"; enabled: slot2Selected.value }
                Wire { from: "%surface%.loop_move.push"; to: "stems.3.muted"; enabled: slot3Selected.value }
                Wire { from: "%surface%.loop_move.push"; to: "stems.4.muted"; enabled: slot4Selected.value }
            }
        }
    }
}
