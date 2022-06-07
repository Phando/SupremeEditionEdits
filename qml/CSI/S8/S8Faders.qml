import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    RemixDeckSlots { name: "remix_slots"; channel: deckId }
    StemDeckStreams { name: "stems"; channel: deckId }

    SoftTakeoverIndicator {
        name: "fader1"
        surfaceObject: surface + ".faders.1"
        propertiesPath: side.propertiesPath + ".softtakeover.faders.1"
    }
    SoftTakeoverIndicator {
        name: "fader2"
        surfaceObject: surface + ".faders.2"
        propertiesPath: side.propertiesPath + ".softtakeover.faders.2"
    }
    SoftTakeoverIndicator {
        name: "fader3"
        surfaceObject: surface + ".faders.3"
        propertiesPath: side.propertiesPath + ".softtakeover.faders.3"
    }
    SoftTakeoverIndicator {
        name: "fader4"
        surfaceObject: surface + ".faders.4"
        propertiesPath: side.propertiesPath + ".softtakeover.faders.4"
    }

    MappingPropertyDescriptor { id: softtakeoverFaders; path: propertiesPath + ".softtakeover.show_faders"; type: MappingPropertyDescriptor.Boolean; value: false }
    SwitchTimer { name: "softtakeover_faders_timer"; resetTimeout: 300 }

    WiresGroup {
        enabled: active

        //Stem Deck Controls
        WiresGroup {
            enabled: deck.deckType == DeckType.Stem

            Wire { from: "fader1.softtakeover.output"; to: "stems.1.volume" }
            Wire { from: "fader2.softtakeover.output"; to: "stems.2.volume" }
            Wire { from: "fader3.softtakeover.output"; to: "stems.3.volume" }
            Wire { from: "fader4.softtakeover.output"; to: "stems.4.volume" }
        }

        //Remix Deck Controls
        WiresGroup {
            enabled: deck.deckType == DeckType.Remix

            Wire { from: "fader1.softtakeover.output"; to: "remix_slots.1.volume" }
            Wire { from: "fader2.softtakeover.output"; to: "remix_slots.2.volume" }
            Wire { from: "fader3.softtakeover.output"; to: "remix_slots.3.volume" }
            Wire { from: "fader4.softtakeover.output"; to: "remix_slots.4.volume" }

            Wire { from: "%surface%.shift"; to: "remix_slots.1.compensate_gain" }
            Wire { from: "%surface%.shift"; to: "remix_slots.2.compensate_gain" }
            Wire { from: "%surface%.shift"; to: "remix_slots.3.compensate_gain" }
            Wire { from: "%surface%.shift"; to: "remix_slots.4.compensate_gain" }
        }

        //MIDI Controls
        WiresGroup {
            enabled: useMIDIControls.value && ((deck.deckType != DeckType.Stem && deck.deckType != DeckType.Remix) || footerPage.value == FooterPage.midi) //AJF: So that MIDI Faders are enabled whenever possible --> when the the footerDeck() is a Remix Deck or a Stem Deck, only enabled when the performance controls are in midi. Otherwise, they should be enabled.

            WiresGroup {
                //enabled: screen.side == ScreenSide.Left
                enabled: side.activeSide == ScreenSide.Left

                Wire { from: "%surface%.faders.1"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.1" } }
                Wire { from: "%surface%.faders.2"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.2" } }
                Wire { from: "%surface%.faders.3"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.3" } }
                Wire { from: "%surface%.faders.4"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.4" } }
            }

            WiresGroup {
                //enabled: screen.side == ScreenSide.Right
                enabled: side.activeSide == ScreenSide.Right

                Wire { from: "%surface%.faders.1"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.5" } }
                Wire { from: "%surface%.faders.2"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.6" } }
                Wire { from: "%surface%.faders.3"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.7" } }
                Wire { from: "%surface%.faders.4"; to: DirectPropertyAdapter { path: "app.traktor.midi.faders.8" } }
            }
        }

        //SoftTakeOver Faders Overlay
        Wire {
            from: Or {
                inputs:
                [
                    "fader1.indicate",
                    "fader2.indicate",
                    "fader3.indicate",
                    "fader4.indicate"
                ]
            }
            to: "softtakeover_faders_timer.input"
        }
        Wire { from: "softtakeover_faders_timer.output"; to: DirectPropertyAdapter { path: softtakeoverFaders.path; output: false } enabled: screenView.value == ScreenView.deck && editMode.value == EditMode.disabled }
    }

}
