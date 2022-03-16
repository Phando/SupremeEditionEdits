import CSI 1.0
import QtQuick 2.12

ButtonScriptAdapter {
    id : effectButton;

	property bool enabled : false
    property int index : -1
    property var data : pads[index]

    name : String("padFX" + index)
	color : padColor()
	brightness : lightHandler()
	onPress : pressHandler(this)
	onRelease: releaseHander(this)

	Component.onCompleted : {
    }

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
    
	function padColor() {
		if (data.color == "Red") 			return Color.Red
		if (data.color == "Dark Orange") 	return Color.DarkOrange
		if (data.color == "Light Orange")	return Color.LightOrange
		if (data.color == "Warm Yellow") 	return Color.WarmYellow
		if (data.color == "Yellow") 		return Color.Yellow
		if (data.color == "Lime") 			return Color.Lime
		if (data.color == "Green") 			return Color.Green
		if (data.color == "Mint") 			return Color.Mint
		if (data.color == "Cyan") 			return Color.Cyan
		if (data.color == "Turquoise") 		return Color.Turquoise
		if (data.color == "Blue") 			return Color.Blue
		if (data.color == "Plum") 			return Color.Plum
		if (data.color == "Violet") 		return Color.Violet
		if (data.color == "Purple") 		return Color.Purple
		if (data.color == "Magenta") 		return Color.Magenta
		if (data.color == "Fuchsia") 		return Color.Fuchsia
		return Color.White
	}

}