import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: fxSelectBody
    property int unit
    property int activeTab

    anchors.fill: parent
    anchors.margins: 5
    anchors.bottomMargin: 10
    clip: true

    //onVisibleChanged: { updateFxSelection() }

    readonly property int delegateHeight: 27
    readonly property int macroEffectChar: 0x00B6

    AppProperty { id: fxSelectList; path: "app.traktor.fx." + unit + ".select." + activeTab
        onValueChanged: {
            fxList.currentIndex = fxSelectList.value //BUG: the first time that the fxSelectList value changes (from undefined to value), it doesn't work.
        }
    }

    //Top FX Settings View
    Item {
        id: topFXSettings
        property int currentBtn: 0
        property int currentIndex: topFXSettings.btnToIndexMap[ topFXSettings.currentBtn ]

        readonly property variant btnNames: [	fxSettingsTab.value <= 4 ? "Top FX Unit" : "Bottom FX Unit", "Unit Mode", "Routing",
            "Unit 1", "Single", "Insert",
            "Unit 2", "Group", "Post Fader",
            "Unit 3", "FX Units", "Send",
            "Unit 4", "2 FX Units", "Snapshot",
            "-", "4 FX Units", "Save"
        ]

        readonly property variant btnToIndexMap: [ 3, 6, 9, 12, 4, 7, 13, 16, 5, 8, 11, 17 ]
        readonly property variant btnDescriptions: [ "", "", "", "", "Set FX Unit as a Single Effect Unit", "Set FX Unit as a Group Effect Unit", "", "", "Applied to the input signal of the channel", "Applied to the output signal of the channel", "For external mixing only!", "Take a snapshot of the current state of the unit" ]

        readonly property variant indexTextButtons: [ 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ]  //put a 1 if you want it to be a text cell
        readonly property variant indexRadioButtons: [ 1, 1, 1, 1, 1, 1, 1, 1, 1, fxMode.value == FxMode.FourFxUnits ? 1 : 0, 1, 1, fxMode.value == FxMode.FourFxUnits ? 1 : 0, 1, 1, 1, 1, 0 ]  //put a 0 if you want it not to have radio button (not necessary if already a Text Button)

        readonly property int buttonCount: btnToIndexMap.length

        anchors.fill: parent
        visible: activeTab == 0 && fxSettingsTab.value <= 4

        Grid {
            columns: 3
            rows: 6
            columnSpacing: fxSelectBody.width * 0.05
            rowSpacing: 5
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10

            Repeater {
                model: parent.columns*parent.rows

                // buttons
                Rectangle {
                    width: fxSelectBody.width * 0.85/3
                    height: fxSelectBody.height * 0.1
                    color: topFXSettings.indexTextButtons[index]==1 ? "transparent" : colors.colorGrey16
                    border.width: 1
                    opacity: (topFXSettings.btnNames[ index ] != "-") ? 1 : 0
                    border.color: topFXSettings.indexTextButtons[index]==1 ? "transparent" : (index==topFXSettings.currentIndex) ? colors.orange : colors.colorGrey32

                    Text {
                        anchors.horizontalCenter: topFXSettings.indexTextButtons[index]==1 ? parent.horizontalCenter : undefined
                        anchors.verticalCenter: parent.verticalCenter
                        x: 9
                        font.pixelSize: fonts.middleFontSize
                        text: topFXSettings.btnNames[index]
                        color: topFXSettings.indexTextButtons[index]==1 ? colors.orange : ((index == topFXSettings.currentIndex) ? colors.orange : colors.colorFontFxHeader)
                    }

                    // radio buttons
                    Rectangle {
                        visible: topFXSettings.indexTextButtons[index]==1 ? false : ((topFXSettings.indexRadioButtons[index]==1) ? true : false)
                        width: 8
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -1
                        anchors.right: parent.right
                        anchors.rightMargin: 9
                        radius: 4
                        border.width: 1
                        border.color: (isButtonAtIndexSelected(index) || index==topFXSettings.currentIndex) ? colors.orange : colors.colorGrey72
                        color: (isButtonAtIndexSelected(index)) ? colors.orange : "transparent"
                    }
                }
            }
        }
    }

    //Bottom FX Settings View
    Item {
        id: bottomFXSettings
        property int currentBtn: 0
        property int currentIndex: bottomFXSettings.btnToIndexMap[ bottomFXSettings.currentBtn ]

        readonly property variant btnNames: [	fxSettingsTab.value <= 4 ? "Top FX Unit" : "Bottom FX Unit", "Unit Mode", "Routing",
            "Unit 1", "Single", "Insert",
            "Unit 2", "Group", "Post Fader",
            "Unit 3", "FX Units", "Send",
            "Unit 4", "2 FX Units", "Snapshot",
            "Disable", "4 FX Units", "Save"
        ]

        readonly property variant btnToIndexMap: [ 3, 6, 9, 12, 15, 4, 7, 13, 16, 5, 8, 11, 17 ]
        readonly property variant btnDescriptions: [ "", "", "", "", "This will prevent it from appearing in the Bottom Overlay", "Set FX Unit as a Single Effect Unit", "Set FX Unit as a Group Effect Unit", "", "", "Applied to the input signal of the channel", "Applied to the output signal of the channel", "For external mixing only!", "Take a snapshot of the current state of the unit" ]

        readonly property variant indexTextButtons: [ 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 ] //put a 1 if you want it to be a text cell
        readonly property variant indexRadioButtons: [ 1, 1, 1, 1, 1, 1, 1, 1, 1, fxMode.value == FxMode.FourFxUnits ? 1 : 0, 1, 1, fxMode.value == FxMode.FourFxUnits ? 1 : 0, 1, 1, 1, 1, 0 ]  //put a 0 if you want it not to have radio button (not necessary if already a Text Button)

        readonly property int buttonCount: btnToIndexMap.length

        anchors.fill: parent
        visible: activeTab == 0 && fxSettingsTab.value > 4

        Grid {
            columns: 3
            rows: 6
            columnSpacing: fxSelectBody.width * 0.05
            rowSpacing: 5
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10

            Repeater {
                model: parent.columns*parent.rows

                // buttons
                Rectangle {
                    width: fxSelectBody.width * 0.85/3
                    height: fxSelectBody.height * 0.1
                    color: bottomFXSettings.indexTextButtons[index]==1 ? "transparent" : colors.colorGrey16
                    border.width: 1
                    opacity: (bottomFXSettings.btnNames[ index ] != "-") ? 1 : 0
                    border.color: bottomFXSettings.indexTextButtons[index]==1 ? "transparent" : (index==bottomFXSettings.currentIndex) ? colors.orange : colors.colorGrey32

                    Text {
                        anchors.horizontalCenter: bottomFXSettings.indexTextButtons[index]==1 ? parent.horizontalCenter : undefined
                        anchors.verticalCenter: parent.verticalCenter
                        x: 9
                        font.pixelSize: fonts.middleFontSize
                        text: bottomFXSettings.btnNames[index]
                        elide: Text.ElideRight
                        color: bottomFXSettings.indexTextButtons[index]==1 ? colors.orange : ((index == bottomFXSettings.currentIndex) ? colors.orange : colors.colorFontFxHeader)
                    }

                    // radio buttons
                    Rectangle {
                        visible: bottomFXSettings.indexTextButtons[index]==1 ? false : ((bottomFXSettings.indexRadioButtons[index]==1) ? true : false)
                        width: 8
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -1
                        anchors.right: parent.right
                        anchors.rightMargin: 9
                        radius: 4
                        border.width: 1
                        border.color: (isButtonAtIndexSelected(index) || index==bottomFXSettings.currentIndex) ? colors.orange : colors.colorGrey72
                        color: (isButtonAtIndexSelected(index)) ? colors.orange : "transparent"
                    }
                }
            }
        }
    }

    //FX List View
    ListView {
        id: fxList
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 33
        height: 189
        clip: true

        visible: activeTab != 0
        model: fxSelectList.valuesDescription

        delegate:
            Item {
            id: contactDelegate
            anchors.horizontalCenter: parent.horizontalCenter
            height: delegateHeight // item (= line) height
            width: parent.width

            property bool isCurrentItem: ListView.isCurrentItem
            readonly property bool isMacroFx: (modelData.charCodeAt(0) == macroEffectChar)
            Image {
                id: macroIcon
                source: "../../Images/Fx_Multi_Icon_Large.png"
                fillMode: Image.PreserveAspectCrop
                width: sourceSize.width
                height: sourceSize.height
                anchors.right: fxName.left
                anchors.top: parent.top
                anchors.rightMargin: 5
                anchors.topMargin: 5
                visible: false
                smooth: false
            }
            ColorOverlay {
                anchors.fill: macroIcon
                source: macroIcon
                color: fxSelectList.description == modelData ? colors.orange : (isCurrentItem ? colors.colorWhite : colors.colorGrey56)
                visible: isMacroFx
            }

            //FX Name
            Text {
                id: fxName
                anchors.centerIn: parent

                anchors.horizontalCenterOffset: isMacroFx ? 10 : 0
                font.pixelSize: fonts.largeFontSize
                font.capitalization: Font.AllUppercase
                color: fxSelectList.description == modelData ? colors.orange : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
                text: isMacroFx? modelData.substr(1) : modelData
            }
        }
    }

    function updateFxSelection() {
        if (fxSelect.value) {
            //preNavMenuValue = fxSelect.value //fxList.currentIndex
            fxList.currentIndex = utils.clamp(fxSelect.value, 0, fxList.count-1)
        }
    }

//------------------------------------------------------------------------------------------------------------------
// Properties Description Text
//------------------------------------------------------------------------------------------------------------------

    Text{
        id: preference_descriptor
        font.family: "Pragmatica"
        font.pixelSize: fonts.middleFontSize
        anchors.top: parent.top
        anchors.topMargin: 225
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        color: colors.orange
        text: fxSettingsTab.value <= 4 ? topFXSettings.btnDescriptions[topFXSettings.currentBtn] : bottomFXSettings.btnDescriptions[bottomFXSettings.currentBtn]
        visible: activeTab == 0
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS NAVIGATION
//------------------------------------------------------------------------------------------------------------------

    property int preNavMenuValue: 0
    MappingProperty { id: settingsNavigation; path: propertiesPath + ".fxSettingsNavigation"
        onValueChanged: {
            var delta = settingsNavigation.value - preNavMenuValue
            preNavMenuValue = settingsNavigation.value
            if (activeTab == 0) {
                if (fxSettingsTab.value <= 4) {
                    var btn = topFXSettings.currentBtn
                    btn = (btn + delta) % topFXSettings.buttonCount
                    topFXSettings.currentBtn = (btn < 0) ? topFXSettings.buttonCount + btn : btn
                }
                else {
                    var btn = bottomFXSettings.currentBtn
                    btn = (btn + delta) % bottomFXSettings.buttonCount
                    bottomFXSettings.currentBtn = (btn < 0) ? bottomFXSettings.buttonCount + btn : btn
                }
            }
            else {
                var index = fxList.currentIndex + delta
                fxList.currentIndex = utils.clamp(index, 0, fxList.count-1)
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS SELECTION
//------------------------------------------------------------------------------------------------------------------

    MappingProperty { id: settingsPush; path: propertiesPath + ".fxSettingsPush"
        onValueChanged: {
            if (activeTab == 0) {
                if (fxSettingsTab.value <= 4) {
                    if	  (topFXSettings.currentBtn == 0) topFXUnit.value = 1
                    else if (topFXSettings.currentBtn == 1) topFXUnit.value = 2
                    else if (topFXSettings.currentBtn == 2 && fxMode.value == FxMode.FourFxUnits) topFXUnit.value = 3
                    else if (topFXSettings.currentBtn == 3 && fxMode.value == FxMode.FourFxUnits) topFXUnit.value = 4
                    else if (topFXSettings.currentBtn == 4) fxSingleMode.value = FxType.Single
                    else if (topFXSettings.currentBtn == 5) fxSingleMode.value = FxType.Group
                    else if (topFXSettings.currentBtn == 6) fxMode.value = FxMode.TwoFxUnits
                    else if (topFXSettings.currentBtn == 7) fxMode.value = FxMode.FourFxUnits
                    else if (topFXSettings.currentBtn == 8) fxRoutingProp.value = FxRouting.Insert
                    else if (topFXSettings.currentBtn == 9) fxRoutingProp.value = FxRouting.PostFader
                    else if (topFXSettings.currentBtn == 10) fxRoutingProp.value = FxRouting.Send
                    else if (topFXSettings.currentBtn == 11) fxStoreProp.value = true
                }
                else {
                    if	  (bottomFXSettings.currentBtn == 0) bottomFXUnit.value = 1
                    else if (bottomFXSettings.currentBtn == 1) bottomFXUnit.value = 2
                    else if (bottomFXSettings.currentBtn == 2 && fxMode.value == FxMode.FourFxUnits) bottomFXUnit.value = 3
                    else if (bottomFXSettings.currentBtn == 3 && fxMode.value == FxMode.FourFxUnits) bottomFXUnit.value = 4
                    else if (bottomFXSettings.currentBtn == 4) bottomFXUnit.value = 0
                    else if (bottomFXSettings.currentBtn == 5) fxSingleMode.value = FxType.Single
                    else if (bottomFXSettings.currentBtn == 6) fxSingleMode.value = FxType.Group
                    else if (bottomFXSettings.currentBtn == 7) fxMode.value = FxMode.TwoFxUnits
                    else if (bottomFXSettings.currentBtn == 8) fxMode.value = FxMode.FourFxUnits
                    else if (bottomFXSettings.currentBtn == 9) fxRoutingProp.value = FxRouting.Insert
                    else if (bottomFXSettings.currentBtn == 10) fxRoutingProp.value = FxRouting.PostFader
                    else if (bottomFXSettings.currentBtn == 11) fxRoutingProp.value = FxRouting.Send
                    else if (bottomFXSettings.currentBtn == 12) fxStoreProp.value = true
                }
            }
            else {
                fxSelectList.value = fxList.currentIndex
                //Auto close FX Select overlay when selecting an effect of the list
                //screenOverlay.value = Overlay.none
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// ACTIVE BUTTON DISPLAY FUNCTIONS
//------------------------------------------------------------------------------------------------------------------

    function isButtonAtIndexSelected(index) {
        if (activeTab == 0) {
            if (fxSettingsTab.value <= 4) {
                if ( (index == topFXSettings.btnToIndexMap[0] && topFXUnit.value == 1)
                        || (index == topFXSettings.btnToIndexMap[1] && topFXUnit.value == 2)
                        || (index == topFXSettings.btnToIndexMap[2] && topFXUnit.value == 3)
                        || (index == topFXSettings.btnToIndexMap[3] && topFXUnit.value == 4)
                        || (index == topFXSettings.btnToIndexMap[4] && fxSingleMode.value == FxType.Single)
                        || (index == topFXSettings.btnToIndexMap[5] && fxSingleMode.value == FxType.Group)
                        || (index == topFXSettings.btnToIndexMap[6] && fxMode.value == FxMode.TwoFxUnits)
                        || (index == topFXSettings.btnToIndexMap[7] && fxMode.value == FxMode.FourFxUnits)
                        || (index == topFXSettings.btnToIndexMap[8] && fxRoutingProp.value == FxRouting.Insert)
                        || (index == topFXSettings.btnToIndexMap[9] && fxRoutingProp.value == FxRouting.PostFader)
                        || (index == topFXSettings.btnToIndexMap[10] && fxRoutingProp.value == FxRouting.Send) ) {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                if ( (index == bottomFXSettings.btnToIndexMap[0] && bottomFXUnit.value == 1)
                        || (index == bottomFXSettings.btnToIndexMap[1] && bottomFXUnit.value == 2)
                        || (index == bottomFXSettings.btnToIndexMap[2] && bottomFXUnit.value == 3)
                        || (index == bottomFXSettings.btnToIndexMap[3] && bottomFXUnit.value == 4)
                        || (index == bottomFXSettings.btnToIndexMap[4] && bottomFXUnit.value == 0)
                        || (index == bottomFXSettings.btnToIndexMap[5] && fxSingleMode.value == FxType.Single)
                        || (index == bottomFXSettings.btnToIndexMap[6] && fxSingleMode.value == FxType.Group)
                        || (index == bottomFXSettings.btnToIndexMap[7] && fxMode.value == FxMode.TwoFxUnits)
                        || (index == bottomFXSettings.btnToIndexMap[8] && fxMode.value == FxMode.FourFxUnits)
                        || (index == bottomFXSettings.btnToIndexMap[9] && fxRoutingProp.value == FxRouting.Insert)
                        || (index == bottomFXSettings.btnToIndexMap[10] && fxRoutingProp.value == FxRouting.PostFader)
                        || (index == bottomFXSettings.btnToIndexMap[11] && fxRoutingProp.value == FxRouting.Send) ) {
                    return true
                }
                else {
                    return false
                }
            }
        }
    }
}
