import CSI 1.0
import QtQuick 2.12

Module {
	//id: module
	id: effectUnit
	
	property int frameRate: 30
	property int frameInc: 100 * frameRate
    property int frameTime: 1000 / frameRate // ~= 33

	property int deck: 0
    property int unit: 0
	
    property var pad : null;
	property var lastPad : null;
	
	Timer { id: pressTimer; interval: holdTimer.value; repeat: false }
	Timer { id: holdPadFX_tick; interval: frameTime; repeat: true; onTriggered: onTick() }
	
	AppProperty { id: focusedDeck; }
	AppProperty { id: unitMode; }
	AppProperty { id: knob0; } 
	AppProperty { id: knob1; } 
	AppProperty { id: knob2; } 
	AppProperty { id: knob3; }
	AppProperty { id: effect1; } 
	AppProperty { id: effect2; } 
	AppProperty { id: effect3; } 
	AppProperty { id: button0; }
	AppProperty { id: button1; }
	AppProperty { id: button2; }
	AppProperty { id: button3; }

	Component.onCompleted: {
		unit += deck % 2 == 0 ? 2 : 1
		
		focusedDeck.path = "app.traktor.mixer.channels." + deck + ".fx.assign." + unit
		unitMode.path = "app.traktor.fx." + unit + ".type"

		button0.path = "app.traktor.fx." + unit + ".enabled"
		button1.path = "app.traktor.fx." + unit + ".buttons.1"
		button2.path = "app.traktor.fx." + unit + ".buttons.2"
		button3.path = "app.traktor.fx." + unit + ".buttons.3"

		effect1.path = "app.traktor.fx." + unit + ".select.1"
		effect2.path = "app.traktor.fx." + unit + ".select.2"
		effect3.path = "app.traktor.fx." + unit + ".select.3"

		knob0.path = "app.traktor.fx." + unit + ".dry_wet"
		knob1.path = "app.traktor.fx." + unit + ".knobs.1"
		knob2.path = "app.traktor.fx." + unit + ".knobs.2"
		knob3.path = "app.traktor.fx." + unit + ".knobs.3"	
	}

	function isDynamic(){
		return unit >= 3
	}

    function isActive(){
		if(pad.isGroup()){
			return (button1.value || button2.value || button3.value)
		}
		return button0.value
	}

	function enable(){
		if(pad != lastPad || isDynamic()){
			knob0.value = pad.getKnob0Value()
			knob1.value = pad.getKnob1Value()
			knob2.value = pad.getKnob2Value()
			knob3.value = pad.getKnob3Value()
		}

		button0.value = true
		button1.value = pad.isKnob1Dynamic() ? true : pad.data.button1
		button2.value = pad.isKnob2Dynamic() ? true : pad.data.button2
		button3.value = pad.isKnob3Dynamic() ? true : pad.data.button3
		lastPad = pad
	}

	function disable(){
		holdPadFX_tick.stop()
		pad.enabled = false

		button0.value = false
		button1.value = false
		button2.value = false
		button3.value = false
	}

	function pressHandler(target){
		// Determine the pad state
		if (pad != target) {
			if ( pad != null ){
				pad.enabled = false
				lastPad = pad
			}

			pad = target
			pad.enabled = true

			focusedDeck.value = deck
			unitMode.value = pad.isGroup() ? FxType.Group : FxType.Single
			effect1.value = pad.data.effect1
			effect2.value = pad.data.effect2
			effect3.value = pad.data.effect3
		}
		else {
			pad.enabled = !pad.enabled
		}
		
		// NOTE : This if statement makes the Dynamic effects press+hold only
		if(!isDynamic())
			pressTimer.restart()
		
		holdPadFX_tick.restart()
	}

	function releaseHander(index){
		// Toggle Click
		if (pressTimer.running){
			if(!pad.enabled){
				disable()
			}
			return
		}
		
		// Hold Release
		disable()
	}

	function getDelta(value, payload){
		// If the knob is not dynamic do not increment the value
		if (!pad._isKnobDynamic(payload)) {
			return payload
		}

		value += payload.delta/frameInc
		
		if(value >= payload.max){
			value = payload.max
		} else if(value <= payload.min){
			value = payload.min
		}

		return value
	}

	function onTick(){
		if(pad == null) return;
		
		// Initialize the effects levels
		if(pad.enabled && !isActive()){
			enable()
		}		

		if(isDynamic()){
			knob0.value = getDelta(knob0.value, pad.data.knob0)
			knob1.value = getDelta(knob1.value, pad.data.knob1)
			knob2.value = getDelta(knob2.value, pad.data.knob2)
			knob3.value = getDelta(knob3.value, pad.data.knob3)
		}
	}
}