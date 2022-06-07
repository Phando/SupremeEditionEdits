import CSI 1.0

Module {
    property string surfaceObject
    property string propertiesPath: "mapping.state.left"

    SoftTakeover { name: "softtakeover" }
    SwitchTimer { name: "actiontimer"; resetTimeout: 20 }
    And { name: "indicate"; inputs: [ "actiontimer.output", "softtakeover.active" ] }

    MappingPropertyDescriptor { id: active; path: propertiesPath + ".active"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: input; path: propertiesPath + ".input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { id: output; path: propertiesPath + ".output"; type: MappingPropertyDescriptor.Float; value: 0.0 }

    Wire { from: surfaceObject; to: "softtakeover.input" }
    Wire { from: surfaceObject; to: "actiontimer.input" }
    Wire { from: "softtakeover.active"; to: DirectPropertyAdapter { path: active.path } }
    Wire { from: "softtakeover.input_monitor"; to: DirectPropertyAdapter { path: input.path } }
    Wire { from: "softtakeover.output_monitor"; to: DirectPropertyAdapter { path: output.path } }
}
