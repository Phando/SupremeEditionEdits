import CSI 1.0
import QtQuick 2.5

import "../../../Preferences"

// Instant Effects Mode Note
// Static effects are routed to FX Units 1 and 2 - to be tweaked
// Dynamic effects are routed to FX Units 3 and 4 - auto pilot


Module {
	id: module
    property int light: 0.0
	property bool active: true
	property string surface: "path"

	property bool shift : false;
	property bool enabled : false;
	
    property int deckId;
    property int unit : deckId % 2 == 0 ? 2 : 1;

   	InstantFXs { id: effects }
	property var pads : effects.pads
	
    function display(object, label = "Display:"){
        const json = JSON.stringify(object);
        console.log(label, json)
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

	function isDynamic(index){
		return (
			typeof pads[index].knob0 == 'object' ||
			typeof pads[index].knob1 == 'object' ||
			typeof pads[index].knob2 == 'object' ||
			typeof pads[index].knob3 == 'object' )
	}

    //-----------------------------------------------------------------------------------------------------------------------------------

	function getUnit(index){
		return isDynamic(index) ? fxUnit2 : fxUnit1
	}

    //-----------------------------------------------------------------------------------------------------------------------------------
    
	function pressHandler(index){
		var fxUnit = getUnit(index)
		fxUnit.pressHandler(index)
        light = 1.0
	}

    //-----------------------------------------------------------------------------------------------------------------------------------

	function releaseHander(index){
		var fxUnit = getUnit(index)
		fxUnit.releaseHander(index)
        light = 0.0
	}

    //-----------------------------------------------------------------------------------------------------------------------------------
	function lightHandler(index){
		var fxUnit = getUnit(index)
        if(fxUnit.padIndex == -1) return false
        return fxUnit.isActive() && fxUnit.padIndex == index
	}

    // LED Colors for Pads
    //
    // This function could be removed with addiitonal changes to Screens/Shared/Widgets/PerformancePanel.qml
	//-----------------------------------------------------------------------------------------------------------------------------------

    function ledColor(index) {
    	let color = pads[index].color
		if (color == "Red") return Color.Red
		else if (color == "Dark Orange") return Color.DarkOrange
		else if (color == "Light Orange") return Color.LightOrange
		else if (color == "Warm Yellow") return Color.WarmYellow
		else if (color == "Yellow") return Color.Yellow
		else if (color == "Lime") return Color.Lime
		else if (color == "Green") return Color.Green
		else if (color == "Mint") return Color.Mint
		else if (color == "Cyan") return Color.Cyan
		else if (color == "Turquoise") return Color.Turquoise
		else if (color == "Blue") return Color.Blue
		else if (color == "Plum") return Color.Plum
		else if (color == "Violet") return Color.Violet
		else if (color == "Purple") return Color.Purple
		else if (color == "Magenta") return Color.Magenta
		else if (color == "Fuchsia") return Color.Fuchsia
		else return Color.White
	}

    // FX Units
	//-----------------------------------------------------------------------------------------------------------------------------------

	EffectUnit { id: fxUnit1; deck: deckId; unit: 0 } 
	EffectUnit { id: fxUnit2; deck: deckId; unit: 2 }

	// PAD Setup
	//-----------------------------------------------------------------------------------------------------------------------------------

	EffectButton { id: padFX0; dataprovider: pads[0]; brightness: active }//color: ledColor(0); brightness: lightHandler(0); onPress: pressHandler(0); onRelease: releaseHander(0) }
	ButtonScriptAdapter { id: padFX1; color: ledColor(1); brightness: lightHandler(1); onPress: pressHandler(1); onRelease: releaseHander(1) }
	ButtonScriptAdapter { id: padFX2; color: ledColor(2); brightness: lightHandler(2); onPress: pressHandler(2); onRelease: releaseHander(2) }
	ButtonScriptAdapter { id: padFX3; color: ledColor(3); brightness: lightHandler(3); onPress: pressHandler(3); onRelease: releaseHander(3) }
	ButtonScriptAdapter { id: padFX4; color: ledColor(4); brightness: lightHandler(4); onPress: pressHandler(4); onRelease: releaseHander(4) }
	ButtonScriptAdapter { id: padFX5; color: ledColor(5); brightness: lightHandler(5); onPress: pressHandler(5); onRelease: releaseHander(5) }
	ButtonScriptAdapter { id: padFX6; color: ledColor(6); brightness: lightHandler(6); onPress: pressHandler(6); onRelease: releaseHander(6) }
	ButtonScriptAdapter { id: padFX7; color: ledColor(7); brightness: lightHandler(7); onPress: pressHandler(7); onRelease: releaseHander(7) }

	ButtonScriptAdapter { id: padFX8; color: ledColor(8); brightness: lightHandler(8); onPress: pressHandler(8); onRelease: releaseHander(8) }
	ButtonScriptAdapter { id: padFX9; color: ledColor(9); brightness: lightHandler(9); onPress: pressHandler(9); onRelease: releaseHander(9) }
	ButtonScriptAdapter { id: padFX10; color: ledColor(10); brightness: lightHandler(10); onPress: pressHandler(10); onRelease: releaseHander(10) }
	ButtonScriptAdapter { id: padFX11; color: ledColor(11); brightness: lightHandler(11); onPress: pressHandler(11); onRelease: releaseHander(11) }
	ButtonScriptAdapter { id: padFX12; color: ledColor(12); brightness: lightHandler(12); onPress: pressHandler(12); onRelease: releaseHander(12) }
	ButtonScriptAdapter { id: padFX13; color: ledColor(13); brightness: lightHandler(13); onPress: pressHandler(13); onRelease: releaseHander(13) }
	ButtonScriptAdapter { id: padFX14; color: ledColor(14); brightness: lightHandler(14); onPress: pressHandler(14); onRelease: releaseHander(14) }
	ButtonScriptAdapter { id: padFX15; color: ledColor(15); brightness: lightHandler(15); onPress: pressHandler(15); onRelease: releaseHander(15) }

	// Wiring
	//-----------------------------------------------------------------------------------------------------------------------------------

    WiresGroup {
    enabled: active

        WiresGroup {
            enabled: !shift

            WiresGroup {
                enabled: slotPadsFX.value == 1
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

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 1 } }
            Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 2 } }
            // Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 3 } }
            // Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 4 } }
            // Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 5 } }
            // Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 6 } }
            // Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 7 } }
            // Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: propertiesPath + ".slotPadsFX"; value: 8 } }
        }
    }

	Component.onCompleted: {
        // fxUnit1.init(deck, 0)
        // fxUnit2.init(deck, 2)
    }
}