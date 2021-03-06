import CSI 1.0
import QtQuick 2.12

Module {
    id: effectUnit

    property int frameRate: 30
    property int frameInc: 100 * frameRate
    property int frameTime: 1000 / frameRate // ~= 33

    property int unit : 0
    property int changeStep : 0
    property var pad : null

    Timer { id: pressTimer; interval: holdTimer.value; repeat: false }
    Timer { id: changeTimer; repeat: false; onTriggered: changeEffect() }
    Timer { id: effectTimer; interval: frameTime; repeat: true; onTriggered: onTick() }

    AppProperty { id: focusedDeck; }
    AppProperty { id: unitMode; }
    AppProperty { id: routing; }
    AppProperty { id: drywet; }
    AppProperty { id: knob1; }
    AppProperty { id: knob2; }
    AppProperty { id: knob3; }
    AppProperty { id: effect1; }
    AppProperty { id: effect2; }
    AppProperty { id: effect3; }
    AppProperty { id: enabled; }
    AppProperty { id: button1; }
    AppProperty { id: button2; }
    AppProperty { id: button3; }

    //-----------------------------------------------------------------------------------------------------------------------------------

    Component.onCompleted: {
        //unit += deckId % 2 == 0 ? 2 : 1

        focusedDeck.path = "app.traktor.mixer.channels." + deckId + ".fx.assign." + unit

        unitMode.path = "app.traktor.fx." + unit + ".type"
        routing.path = "app.traktor.fx." + unit + ".routing"

        enabled.path = "app.traktor.fx." + unit + ".enabled"
        button1.path = "app.traktor.fx." + unit + ".buttons.1"
        button2.path = "app.traktor.fx." + unit + ".buttons.2"
        button3.path = "app.traktor.fx." + unit + ".buttons.3"

        effect1.path = "app.traktor.fx." + unit + ".select.1"
        effect2.path = "app.traktor.fx." + unit + ".select.2"
        effect3.path = "app.traktor.fx." + unit + ".select.3"

        drywet.path = "app.traktor.fx." + unit + ".dry_wet"
        knob1.path = "app.traktor.fx." + unit + ".knobs.1"
        knob2.path = "app.traktor.fx." + unit + ".knobs.2"
        knob3.path = "app.traktor.fx." + unit + ".knobs.3"
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function isActive(){
        if (!pad) return false
        else {
            if(pad.isGroupFX()) return (button1.value || button2.value || button3.value)
            else return enabled.value
        }
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function changeEffect(){
        changeStep += 1

        if(changeStep == 1){
            // Changing the effects needs a frame to catch up before setting values, total delay 25ms
            effect1.value = getFXIndex(effect1, pad.data.effect1)
            effect2.value = getFXIndex(effect2, pad.data.effect2)
            effect3.value = getFXIndex(effect3, pad.data.effect3)

            changeTimer.interval = 20
        }

        if(changeStep == 2) {
            drywet.value = pad.getKnobValue(pad.data.drywet)
            knob1.value = pad.getKnobValue(pad.data.knob1)
            knob2.value = pad.getKnobValue(pad.data.knob2)
            knob3.value = pad.getKnobValue(pad.data.knob3)

            enabled.value = true
            button1.value = pad.isDynamicKnob(pad.data.knob1) ? true : pad.data.button1
            button2.value = pad.isDynamicKnob(pad.data.knob2) ? true : pad.data.button2
            button3.value = pad.isDynamicKnob(pad.data.knob3) ? true : pad.data.button3

            focusedDeck.value = true
        }

        if(changeStep < 2)
            changeTimer.restart()
    }

    function getFXIndex(list, name){
        if (name == "Off" || name == "Disabled" || name == "None") return 0;
        else {
            if (name.startsWith("[M] ")) name = name.replace("[M] ", "?? ")
            const fxs = list.valuesDescription
            const index = Math.max(fxs.indexOf(name), fxs.indexOf("?? " + name))
            return index < 0 ? 0 : index
        }
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function enable(){
        unitMode.value = pad.isGroupFX() ? FxType.Group : FxType.Single
        if (pad.getRouting()) routing.value = pad.getRouting()

        pad.active = true
        changeStep = 0
        changeTimer.interval = 5
        changeTimer.restart()

        selectedPadFX = pad.bank * pad.index
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function disable(){
        changeTimer.stop()
        effectTimer.stop()
        pad.active = false
        focusedDeck.value = false

        enabled.value = false
        button1.value = false
        button2.value = false
        button3.value = false

        selectedPadFX = 0
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function pressHandler(target){
        // Determine the pad state

        changeTimer.stop()
        pressTimer.stop()
        effectTimer.stop()

        if (pad != target) {
            if ( pad != null ){
                pad.active = false
            }

            pad = target
            enable()
        }
        else {
            if(pad.active){
                disable()
                return
            }
            else{
                enable()
            }

        }

        // NOTE : This statement makes the Dynamic effects press+hold only
        if(!pad.isDynamicFX())
            pressTimer.restart()

        effectTimer.restart()
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function releaseHander(index){
        if (pressTimer.running) {
            return // Toggle Release
        }

        disable() // Hold Release
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function getDelta(value, payload){
        // If the knob is not dynamic do not increment the value
        if (!pad.isDynamicKnob(payload)) {
            return payload
        }

        value += payload.delta/frameInc

        if(value >= payload.max) {
            value = payload.max
        } else if(value <= payload.min){
            value = payload.min
        }

        return value
    }

    //-----------------------------------------------------------------------------------------------------------------------------------

    function onTick(){
        if(pad == null) return;

        if(pad.isDynamicFX()){
            drywet.value = getDelta(drywet.value, pad.data.drywet)
            knob1.value = getDelta(knob1.value, pad.data.knob1)
            knob2.value = getDelta(knob2.value, pad.data.knob2)
            knob3.value = getDelta(knob3.value, pad.data.knob3)
        }
    }
}