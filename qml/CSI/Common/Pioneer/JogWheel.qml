import CSI 1.0

Module {
  id: module
  property bool active: true
  property int deckId: 1

  readonly property bool jogTouch: jogTouch.value

  MappingPropertyDescriptor {
    id: jogMode
    path: deckPropertiesPath + ".jog_mode"
    type: MappingPropertyDescriptor.Boolean
    value: true
  }

  MappingPropertyDescriptor {
    id: jogTouch
    path: deckPropertiesPath + ".jog_touch"
    type: MappingPropertyDescriptor.Boolean
    value: false
  }

  Turntable { name: "cdj_jogwheel"; channel: deckId }
  WiresGroup {
      enabled: active
      Wire { from: "surface.jog_mode"; to:  TogglePropertyAdapter{ path: deckPropertiesPath + ".jog_mode"; defaultValue: false } }
      Wire { from: "surface.display.current_time"; to: "cdj_jogwheel.playhead_info" } //"moved" from DeckInfo.qml?

      WiresGroup {
          enabled: !loopInAdjust.value && !loopOutAdjust.value

          Wire { from: "surface.jogwheel.rotation"; to: "cdj_jogwheel.rotation" }
          Wire { from: "surface.jogwheel.speed"; to: "cdj_jogwheel.speed" }
          Wire { from: "surface.jogwheel.touch"; to: "cdj_jogwheel.touch"; enabled: jogMode.value }
          Wire { from: "surface.jogwheel.touch"; to: HoldPropertyAdapter { path: jogTouch.path } enabled: jogMode.value }
      }

      Wire {
          enabled: loopInAdjust.value || loopOutAdjust.value
          from: "%surface%.jogwheel";
          to: EncoderScriptAdapter {
              onIncrement: {
                  const minimalTickValue = 0.001;
                  if (value < -minimalTickValue || value > minimalTickValue) {
                      moveMode.value = loopInAdjust.value ? 2 : 3
                      moveSize.value = 0 //TODO: if speed > parameter, do fine adjustments instead of xFine
                      move.value = 1
                  }
              }
              onDecrement: {
                  const minimalTickValue = 0.001;
                  if (value < -minimalTickValue || value > minimalTickValue) {
                      moveMode.value = loopInAdjust.value ? 2 : 3
                      moveSize.value = 0 //TODO: if speed > parameter, do fine adjustments instead of xFine
                      move.value = -1
                  }
              }
          }
      }
  }
}
