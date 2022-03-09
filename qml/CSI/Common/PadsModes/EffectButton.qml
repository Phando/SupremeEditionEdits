import CSI 1.0
import QtQuick 2.5

import "../../../Preferences"

//Pad FX 1
/*
property bool iFX1running: false
ButtonScriptAdapter {
    name: "PadFX1"
    brightness: iFXOn.value && light == 1
    color: colorToLED(preferences.iFX1Color)
    onPress: {
        holdPadFX1_countdown.restart()
        if (light != 1) { //padFX wasn't enabled when pressed
            iFXOnFocusedDeck.value = 1
            iFXUnitMode.value = FxType.Single
            iFX.value = preferences.iFX1Effect
            iFXOn.value = 1
            iFXDryWet.value = preferences.iFX1DryWet
            iFXK1.value = preferences.iFX1Knob1
            iFXK2.value = preferences.iFX1Knob2
            iFXK3.value = preferences.iFX1Knob3
            iFXB1.value = preferences.iFX1Button1
            iFXB2.value = preferences.iFX1Button2
            iFXB3.value = preferences.iFX1Button3
            light = 1
            iFX1running = false
        }
        else { //padFX was enabled when pressed
            iFX1running = true
        }
    }
    onRelease: {
        if (holdPadFX1_countdown.running) {	//action triggered when pressed
            if (iFX1running) {
                iFXOnFocusedDeck.value = 0
                iFXOn.value = 0
                iFXB1.value = 0
                iFXB2.value = 0
                iFXB3.value = 0
                light = 0
            }
        }
        else { //action when button held & released
            iFXOnFocusedDeck.value=0
            iFXOn.value = 0
            iFXB1.value = 0
            iFXB2.value = 0
            iFXB3.value = 0
            light = 0
        }
        holdPadFX1_countdown.stop()
        holdPadFX1 = false
    }
}
Timer { id: holdPadFX1_countdown; interval: holdTimer.value }
*/

ButtonScriptAdapter {
	//property float active
    property int index;
    property var dataprovider;

    function isDynamic(index){
		return (
			typeof data.knob0 == 'object' ||
			typeof data.knob1 == 'object' ||
			typeof data.knob2 == 'object' ||
			typeof data.knob3 == 'object' )
	}
	
	function lightHandler(){
		console.log("Light")
		return index == 1
		//var fxUnit = getUnit(index)
		//fxUnit.pressHandler(index)
	}

	function pressHandler(){
		console.log("Press1")
		//active = 1.0
		//var fxUnit = getUnit(index)
		//fxUnit.pressHandler(index)
	}

	function releaseHander(){
		console.log("Release")
		//active = 0.0
		//var fxUnit = getUnit(index)
		//fxUnit.pressHandler(index)
	}
    
	function ledColor() {
    	let colorName = dataprovider.color
		if (colorName == "Red") return Color.Red
		else if (colorName == "Dark Orange") return Color.DarkOrange
		else if (colorName == "Light Orange") return Color.LightOrange
		else if (colorName == "Warm Yellow") return Color.WarmYellow
		else if (colorName == "Yellow") return Color.Yellow
		else if (colorName == "Lime") return Color.Lime
		else if (colorName == "Green") return Color.Green
		else if (colorName == "Mint") return Color.Mint
		else if (colorName == "Cyan") return Color.Cyan
		else if (colorName == "Turquoise") return Color.Turquoise
		else if (colorName == "Blue") return Color.Blue
		else if (colorName == "Plum") return Color.Plum
		else if (colorName == "Violet") return Color.Violet
		else if (colorName == "Purple") return Color.Purple
		else if (colorName == "Magenta") return Color.Magenta
		else if (colorName == "Fuchsia") return Color.Fuchsia
		else return Color.White
	}

    Component.onCompleted: {
        // const json = JSON.stringify(data);
        // console.log("Data", json)
        // console.log(colorName)
		
        //this.color = ledColor(dataprovider.color)
		//console.log(this.color, dataprovider.color)
		console.log(path)
    }

	color: ledColor()
	//brightness: active
	onPress : pressHandler()
	onRelease: releaseHander()
}