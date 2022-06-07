import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: module
    property string surface: "path"

    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

    //Select active Deck
    WiresGroup {
        enabled: holdDeck.value || (d2buttons.value == 0 && !holdFXSelect.value)
        //TO DO: improve the selected deck feedback by making the selected deck blink while holding Deck

        WiresGroup {
            enabled: !shift || !d2buttonsShifted.value

            Wire { from: "surface.fx.assign.1"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.AC; output: false } }
            Wire { from: "surface.fx.assign.2"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.BD; output: false } }
            Wire { from: "surface.fx.assign.3"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.AC; output: false } }
            Wire { from: "surface.fx.assign.4"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.BD; output: false } }

            Wire { from: "surface.fx.assign.1"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: true; output: false } }
            Wire { from: "surface.fx.assign.2"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: true; output: false } }
            Wire { from: "surface.fx.assign.3"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: false; output: false } }
            Wire { from: "surface.fx.assign.4"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: false; output: false } }

            Wire { from: "surface.fx.assign.1"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.AC && topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.AC ? 0.15 : 0) } }
            Wire { from: "surface.fx.assign.2"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.BD && topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.BD ? 0.15 : 0) } }
            Wire { from: "surface.fx.assign.3"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.AC && !topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.AC ? 0.15 : 0) } }
            Wire { from: "surface.fx.assign.4"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.BD && !topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.BD ? 0.15 : 0) } }
        }

        WiresGroup {
            enabled: shift && d2buttonsShifted.value

            Wire { from: "surface.fx.assign.1"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.AB; output: false } }
            Wire { from: "surface.fx.assign.2"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.AB; output: false } }
            Wire { from: "surface.fx.assign.3"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.CD; output: false } }
            Wire { from: "surface.fx.assign.4"; to:  SetPropertyAdapter { path: decks.path; value: DecksAssignment.CD; output: false } }

            Wire { from: "surface.fx.assign.1"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: true; output: false } }
            Wire { from: "surface.fx.assign.2"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: false; output: false } }
            Wire { from: "surface.fx.assign.3"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: true; output: false } }
            Wire { from: "surface.fx.assign.4"; to:  SetPropertyAdapter { path: topDeckFocused.path; value: false; output: false } }

            Wire { from: "surface.fx.assign.1"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.AB && topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.AB ? 0.15 : 0) } }
            Wire { from: "surface.fx.assign.2"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.AB && !topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.AB ? 0.15 : 0) } }
            Wire { from: "surface.fx.assign.3"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.CD && topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.CD ? 0.15 : 0) } }
            Wire { from: "surface.fx.assign.4"; to:  ButtonScriptAdapter { brightness: (decks.value == DecksAssignment.CD && !topDeckFocused.value) ? 1 : (decks.value == DecksAssignment.CD ? 0.15 : 0) } }
        }
    }

    //Select Top FX Unit
    WiresGroup {
        enabled: holdFXSelect.value || (d2buttons.value == 1 && !holdDeck.value)
        //TO DO: improve the selected feedback by making unselected FX Units blink while holding the FX Select button

        Wire { from: "surface.fx.assign.1"; to:  SetPropertyAdapter { path: topFXUnit.path; value: 1 } }
        Wire { from: "surface.fx.assign.2"; to:  SetPropertyAdapter { path: topFXUnit.path; value: 2 } }
        Wire { from: "surface.fx.assign.3"; to:  SetPropertyAdapter { path: topFXUnit.path; value: 3 } enabled: fxMode.value == FxMode.FourFxUnits }
        Wire { from: "surface.fx.assign.4"; to:  SetPropertyAdapter { path: topFXUnit.path; value: 4 } enabled: fxMode.value == FxMode.FourFxUnits }
    }

    //FXs Overlays
    MappingPropertyDescriptor { id: showFX1; path: "mapping.state.showFX1"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX2; path: "mapping.state.showFX2"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX3; path: "mapping.state.showFX3"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showFX4; path: "mapping.state.showFX4"; type: MappingPropertyDescriptor.Boolean; value: false }
    SwitchTimer { name: "fxOverlay"; resetTimeout: 1000 }
    //TO-DO: Do something to do the below behaviour, but through the AppProperties, so that if it's assigned from the software/other hadware, it also shows up.

    //Assigned decks to Top FX Unit
    WiresGroup {
        enabled: d2buttons.value == 2 && !holdDeck.value && !holdFXSelect.value

        //FX Overlay should pop up when assigning the FX Unit to a deck
        Wire {
            from: Or {
                inputs:
                [
                "surface.fx.assign.1",
                "surface.fx.assign.2",
                "surface.fx.assign.3",
                "surface.fx.assign.4"
                ]
            }
            to: "fxOverlay.input"
        }

        WiresGroup {
            enabled: (topFXUnit.value == 1 && !shift) || (bottomFXUnit.value == 1 && shift)
            Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.1" } }
            Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.1" } }
            Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.1" } }
            Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.1" } }
            Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: showFX1.path } enabled: showAssignedFXOverlays.value }
        }
        WiresGroup {
            enabled: (topFXUnit.value == 2 && !shift) || (bottomFXUnit.value == 2 && shift)
            Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.2" } }
            Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.2" } }
            Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.2" } }
            Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.2" } }
            Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: showFX2.path } enabled: showAssignedFXOverlays.value }
        }
        WiresGroup {
            enabled: (topFXUnit.value == 3 && !shift) || (bottomFXUnit.value == 3 && shift)
            Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.3" } }
            Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.3" } }
            Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.3" } }
            Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.3" } }
            Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: showFX3.path } enabled: showAssignedFXOverlays.value }
        }
        WiresGroup {
            enabled: (topFXUnit.value == 4 && !shift) || (bottomFXUnit.value == 4 && shift)
            Wire { from: "surface.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.4" } }
            Wire { from: "surface.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.4" } }
            Wire { from: "surface.fx.assign.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.4" } }
            Wire { from: "surface.fx.assign.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.4" } }
            Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: showFX4.path } enabled: showAssignedFXOverlays.value }
        }
    }
}