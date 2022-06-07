import CSI 1.0

Module {
    property string surfaceObject
    property string propertiesPath: "mapping.state.left"
    property AppProperty appProperty

    SoftTakeover { id: softtakeover; name: "softtakeover" }
    SwitchTimer { name: "actiontimer"; resetTimeout: 20 }

    MappingPropertyDescriptor { id: input; path: propertiesPath + ".input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { id: output; path: propertiesPath + ".output"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { id: io_match; path: propertiesPath + ".active"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: console.log("Takeover: " + value) }

    /*
    Tempo fader phisical range --> from 0 (top high) to 1 (top bottom).
    Tempo AppProperty range --> from -1 (top high) to 1 (top bottom)

    Expression --> (phisical value - 0.5) * 2 = property value
    */

    Wire { from: surfaceObject; to: "softtakeover.input" }
    Wire { from: surfaceObject; to: "actiontimer.input" }
    Wire { from: "softtakeover.active"; to: DirectPropertyAdapter { path: io_match.path } }
    Wire { from: "softtakeover.input_monitor"; to: DirectPropertyAdapter { path: input.path } }
    Wire { from: "softtakeover.output_monitor"; to: DirectPropertyAdapter { path: output.path } }

    Wire { from: surfaceObject; to: DirectPropertyAdapter { path: input.path } }
    MappingPropertyDescriptor { id: phisical_input; path: propertiesPath + ".phisical_input"; type: MappingPropertyDescriptor.Float; value: (input.value-0.5)*2; onValueChanged: console.log("Input:" + input.value.toFixed(4) + " (Scaled: " + ((input.value-0.5)*2).toFixed(4) + "); Output: " + output.value.toFixed(4) + "; Enabled: " + !io_match.value) }

    /*
    MappingPropertyDescriptor { id: phisical_input; path: propertiesPath + ".phisical_input"; type: MappingPropertyDescriptor.Float; value: 0.0; onValueChanged: {
        if (!active.value) {
            appProperty.value = (value-0.5)*2;
        }
        console.log("Input:" + value.toFixed(4) + " (Scaled: " + ((input.value-0.5)*2).toFixed(4) + "); Output: " + output.value.toFixed(4) + "; Enabled: " + !io_match.value) }
    }
    Wire { from: surfaceObject; to: DirectPropertyAdapter { path: phisical_input.path } }
    Wire { from: "softtakeover.output"; to: DirectPropertyAdapter { path: appProperty.path } enabled: active }
    */

    /*
    Tempo fader phisical range --> from 0 (top high) to 1 (top bottom).
    Tempo AppProperty range --> from -1 (top high) to 1 (top bottom)

    Expression --> (phisical value - 0.5) * 2 = property value
    */

    /*
    Attemps to make it work...
    //Wire { from: DirectPropertyAdapter { path: rescaled_input.path } to: DirectPropertyAdapter { path: appProperty } }
    //Wire { from: surfaceObject; to: DirectPropertyAdapter { path: appProperty } }
    //Wire { from: DirectPropertyAdapter { path: input.path } to: "softtakeover.input" }
    //Wire { from: DirectPropertyAdapter { path: rescaled_input.path } to: "softtakeover.input" }
    //Wire { from: ExpressionAdapter { type: ExpressionAdapter.Float; expression: rescaled_input.value } to: "softtakeover.input" }
    //Wire { from: ValuePropertyAdapter { path: rescaled_input.path } to: "softtakeover.input" }
    //Wire { from: "softtakeover.input"; to: DirectPropertyAdapter { path: rescaled_input.path } }

    Wire { from: surfaceObject; to: "softtakeover.input" }
    Wire { from: surfaceObject; to: "actiontimer.input" }
    Wire { from: "softtakeover.active"; to: DirectPropertyAdapter { path: active.path } }
    Wire { from: "softtakeover.input_monitor"; to: DirectPropertyAdapter { path: input.path } }
    Wire { from: "softtakeover.output_monitor"; to: DirectPropertyAdapter { path: output.path } }


    //Wire { from: "softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.decks.2.tempo.adjust" } }
    //Wire { from: "softtakeover.output"; to: ValuePropertyAdapter { path: "app.traktor.decks.2.tempo.adjust" } }
    //Wire { from: ExpressionAdapter { type: ExpressionAdapter.Float; expression: output.value } to: ValuePropertyAdapter { path: "app.traktor.decks.2.tempo.adjust" } }
    //Wire { from: ExpressionAdapter { type: ExpressionAdapter.Float; expression: (output.value-0.5)*2 } to: DirectPropertyAdapter { path: "app.traktor.decks.2.tempo.adjust" } }

    //Wire { from: "softtakeover.input_monitor"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: output.value-0.5 } }
    //Wire { from: "softtakeover.output_monitor"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: output.value-0.5 } }
    */
}
