import CSI 1.0
import QtQuick 2.12

import "../../../Helpers/LED.js" as LED

ButtonScriptAdapter {
    id: padFX;

    property int bank: 1;
    property int index: 1;

    property bool active: false
    property var data: pads[(bank-1)*8 + index - 1]

    name: String("padFX" + index + "bank" + bank)
    color: LED.getLED(data.color) || Color.Black
    brightness: (padFXs.isActive() && selectedPadFX == bank*index) || dimmed
    onPress: padFXs.pressHandler(this)
    onRelease: padFXs.releaseHander(this)

    function getRouting(){
        switch(data.routing) {
            case "Insert":
                return 1;
            case "Post Fader":
                return 2;
            case "Send":
                return 0;
        }
    }

    function getKnobValue(knob){
        return typeof knob == "object" ? knob.value : knob
    }

    function isDynamicKnob(knob){
        return typeof knob == "object"
    }

    function isDynamicFX(){
        return data && (
            isDynamicKnob(data.drywet) ||
            isDynamicKnob(data.knob1) ||
            isDynamicKnob(data.knob2) ||
            isDynamicKnob(data.knob3) )
    }

    function isGroupFX(){
        return data && (
            (data.effect2 && data.effect2 != "Off" && data.effect2 != "Disabled" && data.effect2 != "None") ||
            (data.effect3 && data.effect3 != "Off" && data.effect3 != "Disabled" && data.effect3 != "None") )
    }
}