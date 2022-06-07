import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1

    Hotcues { name: "hotcues"; channel: deckId }

    CuePointsProvider { name: "cuepoints_provider"; channel: deckId }
    Wire { from: "surface.cue_points"; to: "cuepoints_provider.output"; enabled: active }

    MappingPropertyDescriptor {
      id: cuePointDelete
      path: deckPropertiesPath + ".cue_delete"
      type: MappingPropertyDescriptor.Boolean;
    }

    Wire {
        from: "surface.hotcue_delete"
        to: TogglePropertyAdapter { path: deckPropertiesPath + ".cue_delete" }
        enabled: active
    }

    WiresGroup {
      enabled: !cuePointDelete.value && active
      Wire { from: "surface.hotcue_a"; to: "hotcues.1.trigger" }
      Wire { from: "surface.hotcue_b"; to: "hotcues.2.trigger" }
      Wire { from: "surface.hotcue_c"; to: "hotcues.3.trigger" }
      Wire { from: "surface.hotcue_d"; to: "hotcues.4.trigger" }
      Wire { from: "surface.hotcue_e"; to: "hotcues.5.trigger" }
      Wire { from: "surface.hotcue_f"; to: "hotcues.6.trigger" }
      Wire { from: "surface.hotcue_g"; to: "hotcues.7.trigger" }
      Wire { from: "surface.hotcue_h"; to: "hotcues.8.trigger" }
    }

    WiresGroup {
      enabled: cuePointDelete.value && active
      Wire { from: "surface.hotcue_a"; to: "hotcues.1.delete" }
      Wire { from: "surface.hotcue_b"; to: "hotcues.2.delete" }
      Wire { from: "surface.hotcue_c"; to: "hotcues.3.delete" }
      Wire { from: "surface.hotcue_d"; to: "hotcues.4.delete" }
      Wire { from: "surface.hotcue_e"; to: "hotcues.5.delete" }
      Wire { from: "surface.hotcue_f"; to: "hotcues.6.delete" }
      Wire { from: "surface.hotcue_g"; to: "hotcues.7.delete" }
      Wire { from: "surface.hotcue_h"; to: "hotcues.8.delete" }
    }

    Beatjump { id: beatjump; name: "beatjump"; channel: deckId }

    MappingPropertyDescriptor {
      id: beatjumpSize
      path: deckPropertiesPath + ".beatjump_size"
      type: MappingPropertyDescriptor.Integer;
    }

    // values align with index on beatjump, negative implies backwards
    // see "JumpSizes.qml" for descriptions

    WiresGroup {
        enabled: active

        Wire { from: DirectPropertyAdapter { path: deckPropertiesPath + ".beatjump_size" } to: "beatjump.size" }

        Wire { from: "surface.beatjump_fwd1"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: 7;  defaultValue: 0 } }
        Wire { from: "surface.beatjump_fwd2"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: 8;  defaultValue: 0 } }
        Wire { from: "surface.beatjump_fwd4"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: 9;  defaultValue: 0 } }
        Wire { from: "surface.beatjump_fwd8"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: 10; defaultValue: 0 } }
        Wire { from: "surface.beatjump_fwd16"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: 11; defaultValue: 0 } }
        Wire { from: "surface.beatjump_fwd32"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: 12; defaultValue: 0 } }

        Wire { from: "surface.beatjump_rev1"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: -7;  defaultValue: 0 } }
        Wire { from: "surface.beatjump_rev2"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: -8;  defaultValue: 0 } }
        Wire { from: "surface.beatjump_rev4"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: -9;  defaultValue: 0 } }
        Wire { from: "surface.beatjump_rev8"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: -10; defaultValue: 0 } }
        Wire { from: "surface.beatjump_rev16"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: -11; defaultValue: 0 } }
        Wire { from: "surface.beatjump_rev32"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".beatjump_size"; value: -12; defaultValue: 0 } }
    }

}
