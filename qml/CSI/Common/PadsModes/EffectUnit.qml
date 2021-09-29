import CSI 1.0
import QtQuick 2.5

import "../../../Preferences/"

Module {
	//id: effectUnit
	property bool enabled: false
	property int padIndex: -1
	property int lastPadIndex: -1
	
	property int frameRate: 30
	property int frameInc: 100 * frameRate
    property int frameTime: 1000 / frameRate // ~= 33

	property int deck: 0
    //onDeckChanged: handleDeckChange()
	
	property int unit: 0
	//onUnitChanged: handleDeckChange()
	
    InstantFXs { name: "preferences"; id: preferences }
	property var pads : preferences.pads
	
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

	// TODO : It would be nice to set 'deck' and unit from the EffectsMode doc directly without having to call 'init'
	function init(_deck, _unit) {
		deck = _deck
		unit = _unit
		
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
	
    function isGroup(index){
		if(typeof pads[index] == 'undefined'){
			return false
		}
		return ( pads[index].effect2 > 0 ||  pads[index].effect3 > 0 )
	}

	function isKnobDynamic(knob){
		return typeof knob == 'object'
	}

	function getKnobValue(knob){
		return isKnobDynamic(knob) ? knob.value : knob
	}

	function isDynamic(){
		return unit >= 3
	}

    function isActive(){
		if(isGroup(padIndex)){
			return (button1.value || button2.value || button3.value)
		}
		return button0.value
	}

	function enable(index){
		if(index != lastPadIndex || isDynamic()){
			knob0.value = getKnobValue(pads[index].knob0)
			knob1.value = getKnobValue(pads[index].knob1)
			knob2.value = getKnobValue(pads[index].knob2)
			knob3.value = getKnobValue(pads[index].knob3)
		}

		button0.value = true
		button1.value = isKnobDynamic(pads[index].knob1) ? true : pads[index].button1
		button2.value = isKnobDynamic(pads[index].knob2) ? true : pads[index].button2
		button3.value = isKnobDynamic(pads[index].knob3) ? true : pads[index].button3
		lastPadIndex = padIndex
	}

	function disable(index){
		holdPadFX_tick.stop()
		enabled = false

		button0.value = false
		button1.value = false
		button2.value = false
		button3.value = false
	}

	function pressHandler(index){
		
		// Determine the pad state
		if (index != padIndex) {
			padIndex = index
			enabled = true

			focusedDeck.value = deck
			unitMode.value = isGroup(index) ? FxType.Group : FxType.Single
			effect1.value = pads[index].effect1
			effect2.value = pads[index].effect2
			effect3.value = pads[index].effect3
		}
		else {
			enabled = !enabled
		}
		
		// NOTE : This if statement makes the Dynamic effects press+hold only
		if(!isDynamic(index)){
			pressTimer.restart()
		} 
		holdPadFX_tick.restart()
	}

	function releaseHander(index){
		// Toggle Click
		if (pressTimer.running){
			if(!enabled){
				disable(index)
			}
			return
		}
		
		// Hold Release
		disable(index)
	}

	function getDelta(value, data){
		// If the knob is not dynamic do not increment the value
		if (!isKnobDynamic(data)) {
			return data
		}

		value += data.delta/frameInc
		
		if(value >= data.max){
			value = data.max
		} else if(value <= data.min){
			value = data.min
		}

		return value
	}

	function onTick(){
		if(padIndex < 0) return;
		
		// Initialize the effects levels
		if(enabled && !isActive()){
			enable(padIndex)
		}		

		if(isDynamic()){
			knob0.value = getDelta(knob0.value, pads[padIndex].knob0)
			knob1.value = getDelta(knob1.value, pads[padIndex].knob1)
			knob2.value = getDelta(knob2.value, pads[padIndex].knob2)
			knob3.value = getDelta(knob3.value, pads[padIndex].knob3)
		}
	}
}