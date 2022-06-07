import CSI 1.0

Module {
    id: module
    property string surface: "path"

    property bool cancelMultiSelection: false
    property int currentlySelectedFx: -1

    //Channels Mixer FX
    ChannelFX {
        id: channel1
        name: "channelA"
        surface: module.surface + ".channels." + deckId
        deckId: 1
        onFxChanged: { cancelMultiSelection = true }
        channelFxSelectorVal: currentlySelectedFx
    }

    ChannelFX {
        id: channel2
        name: "channelB"
        surface: module.surface + ".channels." + deckId
        deckId: 2
        onFxChanged: { cancelMultiSelection = true }
        channelFxSelectorVal: currentlySelectedFx
    }

    ChannelFX {
        id: channel3
        name: "channelC"
        surface: module.surface + ".channels." + deckId
        deckId: 3
        onFxChanged: { cancelMultiSelection = true }
        channelFxSelectorVal: currentlySelectedFx
    }

    ChannelFX {
        id: channel4
        name: "channelD"
        surface: module.surface + ".channels." + deckId
        deckId: 4
        onFxChanged: { cancelMultiSelection = true }
        channelFxSelectorVal: currentlySelectedFx
    }

    //Mixer FX Selector
    Wire {
        from: "%surface%.channel_fx.filter";
        to: ButtonScriptAdapter {
            brightness: isFxUsed(0)
            color: Color.LightOrange
            onPress: {
                mixerFXButtonPressed(0)
            }
            onRelease: {
                mixerFXButtonReleased(0);
            }
        }
    }

    Wire {
        from: "%surface%.channel_fx.fx1";
        to: ButtonScriptAdapter {
            brightness: isFxUsed(1)
            color: Color.Red
            onPress: {
                mixerFXButtonPressed(1)
            }
            onRelease: {
                mixerFXButtonReleased(1);
            }
        }
    }
    Wire {
        from: "%surface%.channel_fx.fx2";
        to: ButtonScriptAdapter {
            brightness: isFxUsed(2)
            color: Color.Green
            onPress: {
                mixerFXButtonPressed(2)
            }
            onRelease: {
                mixerFXButtonReleased(2);
            }
        }
    }

    Wire {
        from: "%surface%.channel_fx.fx3";
        to: ButtonScriptAdapter {
            brightness: isFxUsed(3)
            color: Color.Blue
            onPress: {
                mixerFXButtonPressed(3)
            }
            onRelease: {
                mixerFXButtonReleased(3);
            }
        }
    }
    Wire {
        from: "%surface%.channel_fx.fx4";
        to: ButtonScriptAdapter {
            brightness: isFxUsed(4)
            color: Color.Yellow
            onPress: {
                mixerFXButtonPressed(4)
            }
            onRelease: {
                mixerFXButtonReleased(4);
            }
        }
    }

    //Helper Functions
    function mixerFXButtonReleased(fxSelection) {
        if (!cancelMultiSelection) {
            channel1.selectedFx.value = fxSelection
            channel2.selectedFx.value = fxSelection
            channel3.selectedFx.value = fxSelection
            channel4.selectedFx.value = fxSelection
        }
        if (currentlySelectedFx == fxSelection) {
            currentlySelectedFx = -1
        }
    }

    function mixerFXButtonPressed(fxSelection) {
        cancelMultiSelection = (currentlySelectedFx != -1);
        currentlySelectedFx = fxSelection;
    }

    function isFxUsed(index) {
        return channel1.selectedFx.value == index || channel2.selectedFx.value == index || channel3.selectedFx.value == index || channel4.selectedFx.value == index
    }
}
