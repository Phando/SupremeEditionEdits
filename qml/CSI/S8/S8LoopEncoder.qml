import CSI 1.0

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    RemixDeck { name: "remix"; channel: deckId; size: RemixDeck.Small }
    RemixDeckStepSequencer { name: "remix_sequencer"; channel: deckId; size: RemixDeck.Small }
    FreezeSlicer { name: "freeze_slicer"; channel: deckId; numberOfSlices: 8 }

    Loop { name: "loop";  channel: deckId; numberOfLeds: 4; color: LED.legacy(deckId) }
    Blinker { name: "loop_encoder_blinker"; ledCount: 4; autorun: true; color: LED.legacy(deckId) }
    Blinker { name: "loop_encoder_sequencer_blinker"; ledCount: 4; color: LED.legacy(deckId); defaultBrightness: dimmed; blinkBrightness: bright }

    MappingPropertyDescriptor { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size"; type: MappingPropertyDescriptor.Boolean; value: false }

    WiresGroup {
        enabled: active

        //Browser
        WiresGroup {
            enabled: screenView.value == ScreenView.browser

            Wire { from: "%surface%.encoder.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.favorites.select"; step: 1; mode: RelativeMode.Stepped } }
        }

        //Deck
        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            //Default State --> Loop Mode
            WiresGroup {
                enabled: !holdFreeze.value && !sequencerMode.value && !holdRemix.value && !holdDeck.value && !loopInAdjust.value && !loopOutAdjust.value

                Wire { from: "%surface%.encoder"; to: "loop.autoloop"; enabled: !shift }
                Wire { from: "%surface%.encoder"; to: "loop.move"; enabled: shift }
                Wire { from: "loop.active"; to: "%surface%.encoder.leds" }

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
                //Wire { from: "%surface%.encoder.touch"; to: ButtonScriptAdapter  { onPress: { exitFreeze = false; } } }
                Wire { from: "%surface%.encoder.leds";  to: "loop_encoder_blinker" }
                Wire { from: "%surface%.encoder.turn"; to: "freeze_slicer.slice_size"; enabled: !isInActiveLoop.value }
                //Wire { from: "%surface%.encoder.turn"; to: "loop.autoloop"; enabled: isInActiveLoop.value }
            }

            //Sequencer State --> Pattern Length
            WiresGroup {
                enabled: sequencerMode.value
                Wire { from: "%surface%.encoder.turn"; to: "remix_sequencer.selected_slot_pattern_length"; enabled: !shift }
                Wire { from: "%surface%.encoder.turn"; to: "remix_sequencer.all_slots_pattern_length"; enabled: shift }
                Wire { from: "%surface%.encoder.push"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.sequencer.on" } }
                Wire { from: "loop_encoder_sequencer_blinker"; to: "%surface%.encoder.leds" }
                Wire { from: "loop_encoder_sequencer_blinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: sequencerOn.value } }
            }
        }
    }

    WiresGroup {
        enabled: deck.remixControlled

        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            //Remix State --> Remix Deck Capture Source
            WiresGroup {
                enabled: holdRemix.value //state only enabled if remix is controlled
                Wire {
                    from: Or {
                        inputs:
                        [
                            "%surface%.encoder.touch",
                            "%surface%.encoder.is_turned"
                        ]
                    }
                    to: HoldPropertyAdapter { path: screenOverlay.path; value: Overlay.capture }
                }
                Wire { from: "%surface%.encoder.turn"; to: "remix.capture_source" }
                Wire { from: "loop_encoder_blinker"; to: "%surface%.encoder.leds" }
            }
        }
    }
}
