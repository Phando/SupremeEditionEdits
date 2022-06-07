import CSI 1.0
import QtQuick 2.12

import "../../../Preferences/"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    //Pad Effects Mode Properties (Pad Effects are assigned to the bottom FX Units (3 & 4 by default))
    /*
    property int unit: bottomFXUnit && bottomFXUnit.value != 0 ? bottomFXUnit.value : getFXUnit()
    function getFXUnit() {
        switch(deckId) {
            case 1:
            case 3:
                return 3;
            case 2:
            case 4:
                return 4;
            default:
                return 3;
        }
    }
    */

    PadFXs { id: settings }
    PadFXUnit { id: padFXs; unit: padFXsUnit.value }

    property var pads : settings.pads
    property int selectedPadFX: 0

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: !shift

            Wire { from: "%surface%.pads.1"; to: PadFX { id: padFX1; bank: padFXsBank.value; index: 1 } }
            Wire { from: "%surface%.pads.2"; to: PadFX { id: padFX2; bank: padFXsBank.value; index: 2 } }
            Wire { from: "%surface%.pads.3"; to: PadFX { id: padFX3; bank: padFXsBank.value; index: 3 } }
            Wire { from: "%surface%.pads.4"; to: PadFX { id: padFX4; bank: padFXsBank.value; index: 4 } }
            Wire { from: "%surface%.pads.5"; to: PadFX { id: padFX5; bank: padFXsBank.value; index: 5 } }
            Wire { from: "%surface%.pads.6"; to: PadFX { id: padFX6; bank: padFXsBank.value; index: 6 } }
            Wire { from: "%surface%.pads.7"; to: PadFX { id: padFX7; bank: padFXsBank.value; index: 7 } }
            Wire { from: "%surface%.pads.8"; to: PadFX { id: padFX8; bank: padFXsBank.value; index: 8 } }
        }

        WiresGroup {
            enabled: shift

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 1 } }
            Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 2 } }
            Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 3 } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 4 } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 5 } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 6 } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 7 } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: propertiesPath + ".padFXsBank"; value: 8 } }
        }
    }
}
