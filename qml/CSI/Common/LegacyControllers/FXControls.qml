import CSI 1.0
import QtQuick 2.12

import "../../../Defines"
import "../"

Module {
    id: module
    property bool active: true
    property string surface: "path"
    property int unit: 1
    property string focusedPanel: "top"

    //INFO: This boolean will disable the first of the 4 FX buttons when the FX unit is a Group FX (like this, it will not be orange)
    property bool enableSingleFXButton: fxSingleMode.value ? fxSingleMode.value : false //INFO: like this or else it will show an error saying "Unable to assign [undefined] to bool"

    AppProperty { id: fxSingleMode; path: "app.traktor.fx." + unit + ".type" }

    FxUnit { name: "fx1"; channel: 1 }
    FxUnit { name: "fx2"; channel: 2 }
    FxUnit { name: "fx3"; channel: 3 }
    FxUnit { name: "fx4"; channel: 4 }

    SoftTakeoverIndicator {
        name: "knob1"
        surfaceObject: surface + ".fx.knobs.1"
        propertiesPath: side.propertiesPath + ".softtakeover.knobs.1";
    }
    SoftTakeoverIndicator {
        name: "knob2"
        surfaceObject: surface + ".fx.knobs.2"
        propertiesPath: side.propertiesPath + ".softtakeover.knobs.2";
    }
    SoftTakeoverIndicator {
        name: "knob3"
        surfaceObject: surface + ".fx.knobs.3"
        propertiesPath: side.propertiesPath + ".softtakeover.knobs.3";
    }
    SoftTakeoverIndicator {
        name: "knob4"
        surfaceObject: surface + ".fx.knobs.4"
        propertiesPath: side.propertiesPath + ".softtakeover.knobs.4";
    }

    MappingPropertyDescriptor { id: softtakeoverKnobs; path: propertiesPath + ".softtakeover.show_knobs"; type: MappingPropertyDescriptor.Boolean; value: false }
    SwitchTimer { name: "softtakeover_knobs_timer"; resetTimeout: 300 }

    MappingPropertyDescriptor { id: topPanel; path: propertiesPath + ".topFXOverlay"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: bottomPanel; path: propertiesPath + ".bottomPerformanceOverlay"; type: MappingPropertyDescriptor.Boolean; value: false }
    SwitchTimer { name: "fxOverlay"; resetTimeout: 1000 } //Do something to reset FX timers when you touch their fx assign buttons

    WiresGroup {
        enabled: active

        //FX Settings - Tab Selector
        WiresGroup {
            enabled: screenView.value == ScreenView.fxSettings

            WiresGroup {
                enabled: focusedPanel == "top" && (!shift || bottomFXUnit.value != 0)

                Wire { from: "%surface%.fx.buttons.1"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 1 } }
                Wire { from: "%surface%.fx.buttons.2"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 2 } }
                Wire { from: "%surface%.fx.buttons.3"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 3 } enabled: !fxSingleMode.value }
                Wire { from: "%surface%.fx.buttons.4"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 4 } enabled: !fxSingleMode.value }
            }

            WiresGroup {
                enabled: focusedPanel == "bottom" || (shift && bottomFXUnit.value == 0 && focusedPanel == "top")

                Wire { from: "%surface%.fx.buttons.1"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 5 } }
                Wire { from: "%surface%.fx.buttons.2"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 6 } enabled: bottomFXUnit.value != 0 }
                Wire { from: "%surface%.fx.buttons.3"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 7 } enabled: bottomFXUnit.value != 0 && !fxSingleMode.value }
                Wire { from: "%surface%.fx.buttons.4"; to: SetPropertyAdapter { path: fxSettingsTab.path; value: 8 } enabled: bottomFXUnit.value != 0 && !fxSingleMode.value }
            }
        }

        //FX Unit Controls
        WiresGroup {
            enabled: screenView.value == ScreenView.deck // || screenView.value == ScreenView.browser //We don't want to control the FX Units when the view isn't the deck view, since you won't have feedback of what you are doing, right?

            WiresGroup {
                enabled: unit == 1
                Wire { from: "knob1.softtakeover.output"; to: "fx1.dry_wet" }
                Wire { from: "knob2.softtakeover.output"; to: "fx1.knob1" }
                Wire { from: "knob3.softtakeover.output"; to: "fx1.knob2" }
                Wire { from: "knob4.softtakeover.output"; to: "fx1.knob3" }
                Wire { from: "%surface%.fx.buttons.1"; to: "fx1.enabled"; enabled: enableSingleFXButton }
                Wire { from: "%surface%.fx.buttons.2"; to: "fx1.button1" }
                Wire { from: "%surface%.fx.buttons.3"; to: "fx1.button2" }
                Wire { from: "%surface%.fx.buttons.4"; to: "fx1.button3" }
            }
            WiresGroup {
                enabled: unit == 2
                Wire { from: "knob1.softtakeover.output"; to: "fx2.dry_wet" }
                Wire { from: "knob2.softtakeover.output"; to: "fx2.knob1" }
                Wire { from: "knob3.softtakeover.output"; to: "fx2.knob2" }
                Wire { from: "knob4.softtakeover.output"; to: "fx2.knob3" }
                Wire { from: "%surface%.fx.buttons.1"; to: "fx2.enabled"; enabled: enableSingleFXButton }
                Wire { from: "%surface%.fx.buttons.2"; to: "fx2.button1" }
                Wire { from: "%surface%.fx.buttons.3"; to: "fx2.button2" }
                Wire { from: "%surface%.fx.buttons.4"; to: "fx2.button3" }
            }
            WiresGroup {
                enabled: unit == 3
                Wire { from: "knob1.softtakeover.output"; to: "fx3.dry_wet" }
                Wire { from: "knob2.softtakeover.output"; to: "fx3.knob1" }
                Wire { from: "knob3.softtakeover.output"; to: "fx3.knob2" }
                Wire { from: "knob4.softtakeover.output"; to: "fx3.knob3" }
                Wire { from: "%surface%.fx.buttons.1"; to: "fx3.enabled"; enabled: enableSingleFXButton }
                Wire { from: "%surface%.fx.buttons.2"; to: "fx3.button1" }
                Wire { from: "%surface%.fx.buttons.3"; to: "fx3.button2" }
                Wire { from: "%surface%.fx.buttons.4"; to: "fx3.button3" }
            }
            WiresGroup {
                enabled: unit == 4
                Wire { from: "knob1.softtakeover.output"; to: "fx4.dry_wet" }
                Wire { from: "knob2.softtakeover.output"; to: "fx4.knob1" }
                Wire { from: "knob3.softtakeover.output"; to: "fx4.knob2" }
                Wire { from: "knob4.softtakeover.output"; to: "fx4.knob3" }
                Wire { from: "%surface%.fx.buttons.1"; to: "fx4.enabled"; enabled: enableSingleFXButton }
                Wire { from: "%surface%.fx.buttons.2"; to: "fx4.button1" }
                Wire { from: "%surface%.fx.buttons.3"; to: "fx4.button2" }
                Wire { from: "%surface%.fx.buttons.4"; to: "fx4.button3" }
            }
        }

        //SoftTakeOver Knobs Overlay
        Wire {
            from: Or {
                inputs:
                [
                  "knob1.indicate",
                  "knob2.indicate",
                  "knob3.indicate",
                  "knob4.indicate"
                ]
            }
            to: "softtakeover_knobs_timer.input"
        }
        Wire { from: "softtakeover_knobs_timer.output"; to: DirectPropertyAdapter { path: softtakeoverKnobs.path; output: false } enabled: screenView.value == ScreenView.deck }

        //FX Overlay
        WiresGroup {
            enabled: showTopPanelOnTouch.value

            //FX Overlay should pop up when touching the knobs/pressing the buttons
            Wire {
                from: Or {
                inputs:
                    [
                    "%surface%.fx.knobs.1.touch",
                    "%surface%.fx.knobs.2.touch",
                    "%surface%.fx.knobs.3.touch",
                    "%surface%.fx.knobs.4.touch",
                    "%surface%.fx.buttons.1",
                    "%surface%.fx.buttons.2",
                    "%surface%.fx.buttons.3",
                    "%surface%.fx.buttons.4"
                    ]
                }
                to: "fxOverlay.input"
            }
            Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: topPanel.path } enabled: focusedPanel == "top" }
            Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: bottomPanel.path } enabled: focusedPanel == "bottom" && footerPage.value == FooterPage.fx }
        }
    }
}
