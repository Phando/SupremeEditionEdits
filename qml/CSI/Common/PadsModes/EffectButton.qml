import CSI 1.0
import QtQuick 2.12

ButtonScriptAdapter {
    id : effectButton;

	property bool enabled : false
    property int index : -1
    property var data : pads[index]

    name : String("padFX" + index)
	color : ledColor()
	brightness : lightHandler()
	onPress : pressHandler(this)
	onRelease: releaseHander(this)

    function getKnob0Value(knob){
		return _getKnobValue(data.knob0)
    }

    function getKnob1Value(knob){
		return _getKnobValue(data.knob1)
    }

    function getKnob2Value(knob){
		return _getKnobValue(data.knob2)
    }

    function getKnob3Value(knob){
		return _getKnobValue(data.knob3)
    }

	function _getKnobValue(knob){
		return _isKnobDynamic(knob) ? knob.value : knob
	}

    function isGroup(){
		if(typeof data == 'undefined'){
			return false
		}
		return ( data.effect2 > 0 ||  data.effect3 > 0 )
	}

    function isDynamic(){
		return (
			isKnob0Dynamic() ||
			isKnob1Dynamic() ||
			isKnob2Dynamic() ||
			isKnob3Dynamic() )
	}

    function isKnob0Dynamic(){
        return _isKnobDynamic(data.knob0)
    }

    function isKnob1Dynamic(){
        return _isKnobDynamic(data.knob1)
    }

    function isKnob2Dynamic(){
        return _isKnobDynamic(data.knob2)
    }

    function isKnob3Dynamic(){
        return _isKnobDynamic(data.knob3)
    }

    function _isKnobDynamic(knob){
		return typeof knob == 'object'
	}

	function lightHandler(){
        return enabled;
	}
    
	function ledColor() {
        let colorName = data.color
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

    Component.onCompleted : {
    }
}