import CSI 1.0
import QtQuick 2.5

import "../../../Preferences/"

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

   	InstantFXs { id: preferences; name: "preferences"; }
	property var pads : preferences.pads

	EffectUnit { id: iFXUnit1; }
	EffectUnit { id: iFXUnit2; }

	Component.onCompleted: {
		iFXUnit1.init(deckId, unit-2)
		iFXUnit2.init(deckId, unit)
	}
	
	function isDynamic(index){
		return (
			typeof pads[index].knob0 == 'object' ||
			typeof pads[index].knob1 == 'object' ||
			typeof pads[index].knob2 == 'object' ||
			typeof pads[index].knob3 == 'object' )
	}

	function getUnit(index){
		return isDynamic(index) ? iFXUnit2 : iFXUnit1
	}

	function pressHandler(index){
		var fxUnit = getUnit(index)
		fxUnit.pressHandler(index)
	}

	function releaseHander(index){
		var fxUnit = getUnit(index)
		fxUnit.releaseHander(index)
	}
	
	function colorHandler(index){
		return colorToLED(pads[index].led)
	}

	function lightHandler(index){
		var fxUnit = getUnit(index)
		return fxUnit.isActive() && fxUnit.padIndex == index
		//return fxUnit.padIndex == index
	}

	// PAD Setup
	//-----------------------------------------------------------------------------------------------------------------------------------
	
	// TODO : Fingure out the syntax to do all this in a loop
	ButtonScriptAdapter { name: "PadFX0"; color: colorHandler(0); brightness: lightHandler(0); onPress: pressHandler(0); onRelease: releaseHander(0) }
	ButtonScriptAdapter { name: "PadFX1"; color: colorHandler(1); brightness: lightHandler(1); onPress: pressHandler(1); onRelease: releaseHander(1) }
	ButtonScriptAdapter { name: "PadFX2"; color: colorHandler(2); brightness: lightHandler(2); onPress: pressHandler(2); onRelease: releaseHander(2) }
	ButtonScriptAdapter { name: "PadFX3"; color: colorHandler(3); brightness: lightHandler(3); onPress: pressHandler(3); onRelease: releaseHander(3) }
	ButtonScriptAdapter { name: "PadFX4"; color: colorHandler(4); brightness: lightHandler(4); onPress: pressHandler(4); onRelease: releaseHander(4) }
	ButtonScriptAdapter { name: "PadFX5"; color: colorHandler(5); brightness: lightHandler(5); onPress: pressHandler(5); onRelease: releaseHander(5) }
	ButtonScriptAdapter { name: "PadFX6"; color: colorHandler(6); brightness: lightHandler(6); onPress: pressHandler(6); onRelease: releaseHander(6) }
	ButtonScriptAdapter { name: "PadFX7"; color: colorHandler(7); brightness: lightHandler(7); onPress: pressHandler(7); onRelease: releaseHander(7) }

	ButtonScriptAdapter { name: "PadFX8"; color: colorHandler(8); brightness: lightHandler(8); onPress: pressHandler(8); onRelease: releaseHander(8) }
	ButtonScriptAdapter { name: "PadFX9"; color: colorHandler(9); brightness: lightHandler(9); onPress: pressHandler(9); onRelease: releaseHander(9) }
	ButtonScriptAdapter { name: "PadFX10"; color: colorHandler(10); brightness: lightHandler(10); onPress: pressHandler(10); onRelease: releaseHander(10) }
	ButtonScriptAdapter { name: "PadFX11"; color: colorHandler(11); brightness: lightHandler(11); onPress: pressHandler(11); onRelease: releaseHander(11) }
	ButtonScriptAdapter { name: "PadFX12"; color: colorHandler(12); brightness: lightHandler(12); onPress: pressHandler(12); onRelease: releaseHander(12) }
	ButtonScriptAdapter { name: "PadFX13"; color: colorHandler(13); brightness: lightHandler(13); onPress: pressHandler(13); onRelease: releaseHander(13) }
	ButtonScriptAdapter { name: "PadFX14"; color: colorHandler(14); brightness: lightHandler(14); onPress: pressHandler(14); onRelease: releaseHander(14) }
	ButtonScriptAdapter { name: "PadFX15"; color: colorHandler(15); brightness: lightHandler(15); onPress: pressHandler(15); onRelease: releaseHander(15) }
	
	WiresGroup {
		enabled: active
		
		WiresGroup {
			enabled: !shift

			//if(slotPadsFX.value == 1){}

			WiresGroup {
				enabled: slotPadsFX.value == 1
				// TODO : Fingure out the syntax to do all this in a loop
				Wire { from: "%surface%.pads.1"; to: "PadFX0" }
				Wire { from: "%surface%.pads.2"; to: "PadFX1" }
				Wire { from: "%surface%.pads.3"; to: "PadFX2" }
				Wire { from: "%surface%.pads.4"; to: "PadFX3" }
				Wire { from: "%surface%.pads.5"; to: "PadFX4" }
				Wire { from: "%surface%.pads.6"; to: "PadFX5" }
				Wire { from: "%surface%.pads.7"; to: "PadFX6" }
				Wire { from: "%surface%.pads.8"; to: "PadFX7" }
			}

			WiresGroup {
				enabled: slotPadsFX.value == 2
				// TODO : Fingure out the syntax to do all this in a loop
				Wire { from: "%surface%.pads.1"; to: "PadFX8" }
				Wire { from: "%surface%.pads.2"; to: "PadFX9" }
				Wire { from: "%surface%.pads.3"; to: "PadFX10" }
				Wire { from: "%surface%.pads.4"; to: "PadFX11" }
				Wire { from: "%surface%.pads.5"; to: "PadFX12" }
				Wire { from: "%surface%.pads.6"; to: "PadFX13" }
				Wire { from: "%surface%.pads.7"; to: "PadFX14" }
				Wire { from: "%surface%.pads.8"; to: "PadFX15" }
			}
		}

		WiresGroup {
			enabled: shift
			
			// TODO : Not sure what to do with the pads when shift is pressed
			// you could introduce another 16 pad effects. If the controller
			// only has 8 pads per side, effects 8 - 15 could show up here

			//Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 1 } }
			//Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 2 } }
			
			// WiresGroup {
			// 	enabled: slotPadsFX.value == 1
			// 	Wire { from: "%surface%.pads.1"; to: "PadFX16" }
			// 	Wire { from: "%surface%.pads.2"; to: "PadFX17" }
			// 	Wire { from: "%surface%.pads.3"; to: "PadFX18" }
			// 	Wire { from: "%surface%.pads.4"; to: "PadFX19" }
			// 	Wire { from: "%surface%.pads.5"; to: "PadFX20" }
			// 	Wire { from: "%surface%.pads.6"; to: "PadFX21" }
			// 	Wire { from: "%surface%.pads.7"; to: "PadFX22" }
			// 	Wire { from: "%surface%.pads.8"; to: "PadFX23" }
			// }

			// WiresGroup {
			// 	enabled: slotPadsFX.value == 2
			// 	Wire { from: "%surface%.pads.1"; to: "PadFX24" }
			// 	Wire { from: "%surface%.pads.2"; to: "PadFX25" }
			// 	Wire { from: "%surface%.pads.3"; to: "PadFX26" }
			// 	Wire { from: "%surface%.pads.4"; to: "PadFX27" }
			// 	Wire { from: "%surface%.pads.5"; to: "PadFX28" }
			// 	Wire { from: "%surface%.pads.6"; to: "PadFX29" }
			// 	Wire { from: "%surface%.pads.7"; to: "PadFX30" }
			// 	Wire { from: "%surface%.pads.8"; to: "PadFX31" }
			// }
		}
	}
	
	function colorToLED(iFXColor) {
		if (iFXColor == "colors.color01Bright") return Color.Red
		else if (iFXColor == "colors.color02Bright") return Color.DarkOrange
		else if (iFXColor == "colors.color03Bright") return Color.LightOrange
		else if (iFXColor == "colors.color04Bright") return Color.WarmYellow
		else if (iFXColor == "colors.color05Bright") return Color.Yellow
		else if (iFXColor == "colors.color06Bright") return Color.Lime
		else if (iFXColor == "colors.color07Bright") return Color.Green
		else if (iFXColor == "colors.color08Bright") return Color.Mint
		else if (iFXColor == "colors.color09Bright") return Color.Cyan
		else if (iFXColor == "colors.color10Bright") return Color.Turquoise
		else if (iFXColor == "colors.color11Bright") return Color.Blue
		else if (iFXColor == "colors.color12Bright") return Color.Plum
		else if (iFXColor == "colors.color13Bright") return Color.Violet
		else if (iFXColor == "colors.color14Bright") return Color.Purple
		else if (iFXColor == "colors.color15Bright") return Color.Magenta
		else if (iFXColor == "colors.color16Bright") return Color.Fuchsia
		else return Color.White
	}
}
