import QtQuick 2.12
import CSI 1.0

Item {
    id: tabs
    property int unit
    property int activeTab
    property bool focused

    width: parent.width
    height: 19

    property string fxUnitName: unit != 0 ? ("FX UNIT: " + unit) : "FX UNIT: DISABLED"
    readonly property variant headerNames: [fxUnitName, fxSelectList1.description, fxSelectList2.description, fxSelectList3.description]
    readonly property int macroEffectChar: 0x00B6

    AppProperty { id: fxSingleMode; path: "app.traktor.fx." + unit + ".type" }
    AppProperty { id: fxSelectList1; path: "app.traktor.fx." + unit + ".select.1" }
    AppProperty { id: fxSelectList2; path: "app.traktor.fx." + unit + ".select.2" }
    AppProperty { id: fxSelectList3; path: "app.traktor.fx." + unit + ".select.3" }

    Row {
        spacing: 1
        anchors.fill: parent
        Repeater {
            model: 4

            Rectangle {
                width: parent.width / 4
                height: tabs.height
                color: focused && index == activeTab ? colors.orange : colors.colorFxHeaderBg

                readonly property bool isMacroFx: (headerNames[index].charCodeAt(0) == macroEffectChar)

                Rectangle {
                    id: macroIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    width: 12
                    height: 11
                    radius: 1
                    visible: isMacroFx && (index == 1 || (fxSingleMode.value==FxType.Group) )
                    color: focused && index == activeTab ? colors.colorBlack85 : colors.colorGrey80

                    Text {
                        anchors.fill: parent
                        anchors.topMargin: -1
                        anchors.leftMargin: 1
                        text: "M"
                        font.pixelSize: fonts.miniFontSize
                        color: focused && index == activeTab ? colors.orange : colors.colorBlack
                    }
                }

                Text {
                    visible: index == 0 || index == 1 || fxSingleMode.value==FxType.Group
                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.topMargin: 2
                    anchors.leftMargin: (headerNames[index].charCodeAt(0) == macroEffectChar)? 20 : 5
                    anchors.rightMargin: 3
                    font.pixelSize: fonts.smallFontSize
                    font.capitalization: Font.AllUppercase
                    color: focused && index == activeTab ? colors.colorBlack : colors.colorFontBrowserHeader
                    text: isMacroFx? headerNames[index].substr(1) : headerNames[index]
                    clip: true
                    elide: Text.ElideRight
                }
            }
        }
    }
}
