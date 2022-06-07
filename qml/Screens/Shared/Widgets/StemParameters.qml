import CSI 1.0
import QtQuick 2.12

Grid {
    id: stems

    property int margins: 3
    property bool showFX: false

    readonly property int columnWidth: showFX ? (stems.width-margins)/3 : (stems.width-margins)/2

    Column {
        spacing: margins

        Row {
            spacing: margins
            Item {
                height: (stems.height-margins*4)/5
                width: columnWidth

                Text {
                    text: "Volume"
                    font.pixelSize: 24
                    font.family: "Roboto"
                    font.weight: Font.Normal
                    color: "white"
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Item {
                height: (stems.height-margins*4)/5
                width: columnWidth

                Text {
                    text: "Filter"
                    font.pixelSize: 24
                    font.family: "Roboto"
                    font.weight: Font.Normal
                    color: "white"
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Item {
                height: (stems.height-margins*4)/5
                width: columnWidth
                visible: showFX

                Text {
                    text: "FX Send"
                    font.pixelSize: 24
                    font.family: "Roboto"
                    font.weight: Font.Normal
                    color: "white"
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Repeater {
            model: 4

            Row {
                id: slotRow

                AppProperty { id: stemName; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".name" }
                AppProperty { id: stemColorId; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".color_id" }

                AppProperty { id: stemVolume; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".volume" }
                AppProperty { id: stemMuted; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".muted" }
                AppProperty { id: stemFilter; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".filter_value" }
                AppProperty { id: stemFilterOn; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".filter_on" }
                AppProperty { id: stemFXSend; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".fx_send" }
                AppProperty { id: stemFXSendOn; path: "app.traktor.decks." + deckId + ".stems." + (index+1) + ".fx_send_on" }

                spacing: margins
                property int activeStems: slot1Selected.value + slot2Selected.value + slot3Selected.value + slot4Selected.value

                //Volume Slider
                Slider {
                    height: (stems.height-margins*4)/5
                    width: columnWidth
                    opacity: (((index + 1) == 1 && slot1Selected.value) || ((index + 1) == 2 && slot2Selected.value) || ((index + 1) == 3 && slot3Selected.value) || ((index + 1) == 4 && slot4Selected.value)) ? 1 : 0.1

                    value: stemVolume.value
                    min: 0
                    max: 1
                    radius: 2
                    centered: false

                    backgroundColor: !stemMuted.value ? colors.colorGrey72: colors.colorGrey24
                    sliderColor: !stemMuted.value ? colors.palette(1, stemColorId.value) : colors.palette(0.5, stemColorId.value)
                    cursorColor: !stemMuted.value ? "white" : "grey"
                }

                //Filter Slider
                Slider {
                    height: (stems.height-margins*4)/5
                    width: columnWidth
                    opacity: (((index + 1) == 1 && slot1Selected.value) || ((index + 1) == 2 && slot2Selected.value) || ((index + 1) == 3 && slot3Selected.value) || ((index + 1) == 4 && slot4Selected.value)) ? 1 : 0.1

                    value: stemFilter.value
                    min: 0
                    max: 1
                    centered: true
                    radius: 2

                    backgroundColor: stemFilterOn.value ? colors.colorGrey72: colors.colorGrey24
                    sliderColor: stemFilterOn.value ? colors.palette(1, stemColorId.value) : colors.palette(0.5, stemColorId.value)
                    cursorColor: stemFilterOn.value ? "white" : "grey"
                    centerColor: stemFilterOn.value ? colors.colorGrey40 : colors.colorGrey08
                }

                //FX Send Slider
                Slider {
                    height: (stems.height-margins*4)/5
                    width: columnWidth
                    opacity: (((index + 1) == 1 && slot1Selected.value) || ((index + 1) == 2 && slot2Selected.value) || ((index + 1) == 3 && slot3Selected.value) || ((index + 1) == 4 && slot4Selected.value)) ? 1 : 0.1
                    visible: showFX

                    value: stemFXSend.value
                    min: 0
                    max: 1
                    radius: 2
                    centered: false

                    backgroundColor: stemFXSendOn.value ? colors.colorGrey72: colors.colorGrey24
                    sliderColor: stemFXSendOn.value ? colors.palette(1, stemColorId.value) : colors.palette(0.5, stemColorId.value)
                    cursorColor: stemFXSendOn.value ? "white" : colors.colorGrey40
                }
            }
        }
    }
}