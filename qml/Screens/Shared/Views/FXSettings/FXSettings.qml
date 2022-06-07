import CSI 1.0
import QtQuick 2.12

import '../../Overlays'

FullscreenOverlay {
    id: fxSettings

    anchors.fill: parent
    //onVisibleChanged: { body.updateFxSelection() }

    property int unit: fxSettingsTab.value <= 4 ? topFXUnit.value : bottomFXUnit.value
    property int activeTab: (fxSettingsTab.value-1) % 4 //-1 to "fix the 4 % 4 = 0 issue". Otherwise, on Group FX units, when the active tab is the third FX, it wouldn't be detected

    MappingProperty { id: fxSettingsTab; path: propertiesPath +  ".fxSettings_tab" }
    MappingProperty { id: hasFXFooter; path: propertiesPath + ".hasFXFooter" }

    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units"; onValueChanged: { updateActiveTab() } }
    AppProperty { id: fxStoreProp; path: "app.traktor.fx." + unit + ".store" }
    AppProperty { id: fxRoutingProp; path: "app.traktor.fx." + unit + ".routing" }
    AppProperty { id: fxSelect; path: "app.traktor.fx." + unit + ".select." + Math.max(1, activeTab); onValueChanged: { body.updateFxSelection() } }
    AppProperty { id: fxSingleMode; path: "app.traktor.fx." + unit + ".type"; onValueChanged: { updateActiveTab() } }

    Tabs {
        id: header
        unit: topFXUnit.value
        activeTab: parent.activeTab
        focused: fxSettingsTab.value <= 4
        anchors.top: parent.top
    }

    Tabs {
        id: bottom
        unit: bottomFXUnit.value
        activeTab: parent.activeTab
        focused: fxSettingsTab.value > 4
        anchors.bottom: parent.bottom
    }

    Body {
        id: body
        unit: parent.unit
        activeTab: parent.activeTab
    }

    function updateActiveTab() {
        if (fxSingleMode.value == FxType.Single && activeTab >= 2) {
            if (fxSettingsTab <= 4) {
                fxSettingsTab.value = 2
            }
            else {
                fxSettingsTab.value = 6
            }
        }
        if (fxMode.value == FxMode.TwoFxUnits && unit > 2) {
            if (fxSettingsTab <= 4) {
                fxSettingsTab.value = 1
            }
            else {
                fxSettingsTab.value = 5
            }
        }
    }
}
