import CSI 1.0
import QtQuick 2.5

import '../../../Preferences'

// Instant Effects Mode Properties 
// Static effects are routed to FX Units 1 and 2 - to be tweaked
// Dynamic effects are routed to FX Units 3 and 4 - auto pilot

Module {
	id: module
	property bool active: true
	property string surface: "path"

	property bool shift : false;
	property bool enabled : false;
	
	property int unit: bottomFXUnit.value
	property int deckId: unit == 3 ? 1 : 2

   	InstantFXs { id: effects }
	property var pads : effects.pads
	
	function isDynamic(index){
		return (
			typeof pads[index].knob0 == 'object' ||
			typeof pads[index].knob1 == 'object' ||
			typeof pads[index].knob2 == 'object' ||
			typeof pads[index].knob3 == 'object' )
	}

	function getUnit(index){
		return isDynamic(index) ? fxUnit2 : fxUnit1
	}

	function pressHandler(index){
		var fxUnit = getUnit(index)
		fxUnit.pressHandler(index)
	}

	function releaseHander(index){
		var fxUnit = getUnit(index)
		fxUnit.releaseHander(index)
	}

	function lightHandler(index){
		var fxUnit = getUnit(index)
		return fxUnit.isActive() && fxUnit.padIndex == index
	}

	// FX Units
	//-----------------------------------------------------------------------------------------------------------------------------------

	EffectUnit { id: fxUnit1; } //deck: deckId; unit: (unit-2) }
	EffectUnit { id: fxUnit2; } //deck: deckId; unit: unit }

	// PAD Setup
	//-----------------------------------------------------------------------------------------------------------------------------------

	ButtonScriptAdapter { id: padFX0; color: effects.ledColor(0); brightness: lightHandler(0); onPress: pressHandler(0); onRelease: releaseHander(0) }
	ButtonScriptAdapter { id: padFX1; color: effects.ledColor(1); brightness: lightHandler(1); onPress: pressHandler(1); onRelease: releaseHander(1) }
	ButtonScriptAdapter { id: padFX2; color: effects.ledColor(2); brightness: lightHandler(2); onPress: pressHandler(2); onRelease: releaseHander(2) }
	ButtonScriptAdapter { id: padFX3; color: effects.ledColor(3); brightness: lightHandler(3); onPress: pressHandler(3); onRelease: releaseHander(3) }
	ButtonScriptAdapter { id: padFX4; color: effects.ledColor(4); brightness: lightHandler(4); onPress: pressHandler(4); onRelease: releaseHander(4) }
	ButtonScriptAdapter { id: padFX5; color: effects.ledColor(5); brightness: lightHandler(5); onPress: pressHandler(5); onRelease: releaseHander(5) }
	ButtonScriptAdapter { id: padFX6; color: effects.ledColor(6); brightness: lightHandler(6); onPress: pressHandler(6); onRelease: releaseHander(6) }
	ButtonScriptAdapter { id: padFX7; color: effects.ledColor(7); brightness: lightHandler(7); onPress: pressHandler(7); onRelease: releaseHander(7) }

	ButtonScriptAdapter { id: padFX8; color: effects.ledColor(8); brightness: lightHandler(8); onPress: pressHandler(8); onRelease: releaseHander(8) }
	ButtonScriptAdapter { id: padFX9; color: effects.ledColor(9); brightness: lightHandler(9); onPress: pressHandler(9); onRelease: releaseHander(9) }
	ButtonScriptAdapter { id: padFX10; color: effects.ledColor(10); brightness: lightHandler(10); onPress: pressHandler(10); onRelease: releaseHander(10) }
	ButtonScriptAdapter { id: padFX11; color: effects.ledColor(11); brightness: lightHandler(11); onPress: pressHandler(11); onRelease: releaseHander(11) }
	ButtonScriptAdapter { id: padFX12; color: effects.ledColor(12); brightness: lightHandler(12); onPress: pressHandler(12); onRelease: releaseHander(12) }
	ButtonScriptAdapter { id: padFX13; color: effects.ledColor(13); brightness: lightHandler(13); onPress: pressHandler(13); onRelease: releaseHander(13) }
	ButtonScriptAdapter { id: padFX14; color: effects.ledColor(14); brightness: lightHandler(14); onPress: pressHandler(14); onRelease: releaseHander(14) }
	ButtonScriptAdapter { id: padFX15; color: effects.ledColor(15); brightness: lightHandler(15); onPress: pressHandler(15); onRelease: releaseHander(15) }
	
	// Wiring
	//-----------------------------------------------------------------------------------------------------------------------------------

	WiresGroup {
		enabled: active
		
		WiresGroup {
			enabled: !shift

			WiresGroup {
				enabled: slotPadsFX.value == 1
				// TODO : Fingure out the syntax to do all this in a loop
				Wire { from: "%surface%.pads.1"; to: padFX0 }
				Wire { from: "%surface%.pads.2"; to: padFX1 }
				Wire { from: "%surface%.pads.3"; to: padFX2 }
				Wire { from: "%surface%.pads.4"; to: padFX3 }
				Wire { from: "%surface%.pads.5"; to: padFX4 }
				Wire { from: "%surface%.pads.6"; to: padFX5 }
				Wire { from: "%surface%.pads.7"; to: padFX6 }
				Wire { from: "%surface%.pads.8"; to: padFX7 }
			}

			WiresGroup {
				enabled: slotPadsFX.value == 2
				// TODO : Fingure out the syntax to do all this in a loop
				Wire { from: "%surface%.pads.1"; to: padFX8 }
				Wire { from: "%surface%.pads.2"; to: padFX9 }
				Wire { from: "%surface%.pads.3"; to: padFX10 }
				Wire { from: "%surface%.pads.4"; to: padFX11 }
				Wire { from: "%surface%.pads.5"; to: padFX12 }
				Wire { from: "%surface%.pads.6"; to: padFX13 }
				Wire { from: "%surface%.pads.7"; to: padFX14 }
				Wire { from: "%surface%.pads.8"; to: padFX15 }
			}
		}

		WiresGroup {
			enabled: shift
			
			// TODO : Not sure what to do with the pads when shift is pressed
			// you could introduce another 16 pad effects. If the controller
			// only has 8 pads per side, effects 8 - 15 could show up here
			Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 1 } }
			Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 2 } }
		}
	}
	
	Component.onCompleted: {
		// TODO : It would be great to pass 'deck' and 'unit' to the constructor 
		// but they are not available in time
		fxUnit1.init(deckId, unit-2)
		fxUnit2.init(deckId, unit)
	}

}
