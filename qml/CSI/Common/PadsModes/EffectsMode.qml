import CSI 1.0
import QtQuick 2.12

import "../../../Preferences"

// Instant Effects Mode Note
// Static effects are routed to FX Units 1 and 2 - to be tweaked
// Dynamic effects are routed to FX Units 3 and 4 - auto pilot

Module {
	id: module
    
	property bool active: true
	property string surface: "path"

	property bool shift : false;
    property int deckId : 0;
    
   	InstantFXs { id: effects }
	property var pads : effects.pads
	
    // FX Units
	//-----------------------------------------------------------------------------------------------------------------------------------

	EffectUnit { id: fxUnit1; unit: 0 } 
	EffectUnit { id: fxUnit2; unit: 2 }

	// PAD Setup
	//-----------------------------------------------------------------------------------------------------------------------------------

	EffectButton { id: padFX0; index: 0; }
	EffectButton { id: padFX1; index: 1; }
	EffectButton { id: padFX2; index: 2; }
	EffectButton { id: padFX3; index: 3; }
	EffectButton { id: padFX4; index: 4; }
	EffectButton { id: padFX5; index: 5; }
	EffectButton { id: padFX6; index: 6; }
	EffectButton { id: padFX7; index: 7; }

	EffectButton { id: padFX8;  index: 8; }
	EffectButton { id: padFX9;  index: 9; }
	EffectButton { id: padFX10; index: 10; }
	EffectButton { id: padFX11; index: 11; }
	EffectButton { id: padFX12; index: 12; }
	EffectButton { id: padFX13; index: 13; }
	EffectButton { id: padFX14; index: 14; }
	EffectButton { id: padFX15; index: 15; }

	// Wiring
	//-----------------------------------------------------------------------------------------------------------------------------------

    WiresGroup {
    enabled: active

        WiresGroup {
            enabled: !shift

            WiresGroup {
                enabled: slotPadsFX.value == 1
                Wire { from: "%surface%.pads.1"; to: "padFX0" }
                Wire { from: "%surface%.pads.2"; to: "padFX1" }
                Wire { from: "%surface%.pads.3"; to: "padFX2" }
                Wire { from: "%surface%.pads.4"; to: "padFX3" }
                Wire { from: "%surface%.pads.5"; to: "padFX4" }
                Wire { from: "%surface%.pads.6"; to: "padFX5" }
                Wire { from: "%surface%.pads.7"; to: "padFX6" }
                Wire { from: "%surface%.pads.8"; to: "padFX7" }
            }

            WiresGroup {
                enabled: slotPadsFX.value == 2
                Wire { from: "%surface%.pads.1"; to: "padFX8" }
                Wire { from: "%surface%.pads.2"; to: "padFX9" }
                Wire { from: "%surface%.pads.3"; to: "padFX10" }
                Wire { from: "%surface%.pads.4"; to: "padFX11" }
                Wire { from: "%surface%.pads.5"; to: "padFX12" }
                Wire { from: "%surface%.pads.6"; to: "padFX13" }
                Wire { from: "%surface%.pads.7"; to: "padFX14" }
                Wire { from: "%surface%.pads.8"; to: "padFX15" }
            }
        }

        WiresGroup {
            enabled: shift

            // Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 1 } }
            // Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 2 } }
            // Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 3 } }
            // Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 4 } }
            // Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 5 } }
            // Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 6 } }
            // Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 7 } }
            // Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 8 } }
        }
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

	function pressHandler(pad){
		var fxUnit = pad.isDynamic() ? fxUnit2 : fxUnit1
		fxUnit.pressHandler(pad)
	}

    //-----------------------------------------------------------------------------------------------------------------------------------

	function releaseHander(pad) {
		var fxUnit = pad.isDynamic() ? fxUnit2 : fxUnit1
		fxUnit.releaseHander(pad)
    }
}