import CSI 1.0
import QtQuick 2.12

import '../' as Widgets

Grid {
    id: sampleParameters

    Column {
        spacing: margins

        Row {
            spacing: margins
            Item {
                height: (remixDeck.height-margins*4)/5
                width: (remixDeck.width-margins)/2

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
                height: (remixDeck.height-margins*4)/5
                width: (remixDeck.width-margins)/2

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
                height: (remixDeck.height-margins*4)/5
                width: (remixDeck.width-margins)/2
                visible: false

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

                AppProperty { id: activeCellY; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".active_cell_row" }
                AppProperty { id: remixColorId; path: "app.traktor.decks." + deckId + ".remix.cell.columns." + (index+1) + ".rows." + (activeCellY.value+1) + ".color_id" }

                AppProperty { id: remixVolume; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".volume" }
                AppProperty { id: remixMuted; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".muted" }
                AppProperty { id: remixFilter; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".filter_value" }
                AppProperty { id: remixFilterOn; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".filter_on" }
                AppProperty { id: remixFXSend; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".fx_send" }
                AppProperty { id: remixFXSendOn; path: "app.traktor.decks." + deckId + ".remix.players." + (index+1) + ".fx_send_on" }

                spacing: margins
                property int activeSlots: slot1Selected.value + slot2Selected.value + slot3Selected.value + slot4Selected.value

                //Volume Slider
                Widgets.Slider {
                    height: (remixDeck.height-margins*4)/5
                    width: (remixDeck.width-margins)/2
                    opacity: (((index + 1) == 1 && slot1Selected.value) || ((index + 1) == 2 && slot2Selected.value) || ((index + 1) == 3 && slot3Selected.value) || ((index + 1) == 4 && slot4Selected.value)) ? 1 : 0.1

                    value: remixVolume.value
                    min: 0
                    max: 1
                    radius: 2
                    centered: false

                    backgroundColor: !remixMuted.value ? colors.colorGrey72: colors.colorGrey24
                    sliderColor: !remixMuted.value ? colors.palette(1, remixColorId.value) : colors.palette(0.5, remixColorId.value)
                    cursorColor: !remixMuted.value ? "white" : "grey"
                }

                //Filter Slider
                Widgets.Slider {
                    height: (remixDeck.height-margins*4)/5
                    width: (remixDeck.width-margins)/2
                    opacity: (((index + 1) == 1 && slot1Selected.value) || ((index + 1) == 2 && slot2Selected.value) || ((index + 1) == 3 && slot3Selected.value) || ((index + 1) == 4 && slot4Selected.value)) ? 1 : 0.1

                    value: remixFilter.value
                    min: 0
                    max: 1
                    centered: true
                    radius: 2

                    backgroundColor: remixFilterOn.value ? colors.colorGrey72: colors.colorGrey24
                    sliderColor: remixFilterOn.value ? colors.palette(1, remixColorId.value) : colors.palette(0.5, remixColorId.value)
                    cursorColor: remixFilterOn.value ? "white" : "grey"
                    centerColor: remixFilterOn.value ? colors.colorGrey40 : colors.colorGrey08
                }

                //FX Send Slider
                Widgets.Slider {
                    height: (remixDeck.height-margins*4)/5
                    width: (remixDeck.width-margins)/2
                    opacity: (((index + 1) == 1 && slot1Selected.value) || ((index + 1) == 2 && slot2Selected.value) || ((index + 1) == 3 && slot3Selected.value) || ((index + 1) == 4 && slot4Selected.value)) ? 1 : 0.1
                    visible: false

                    value: remixFXSend.value
                    min: 0
                    max: 1
                    radius: 2
                    centered: false

                    backgroundColor: remixFXSendOn.value ? colors.colorGrey72: colors.colorGrey24
                    sliderColor: remixFXSendOn.value ? colors.palette(1, remixColorId.value) : colors.palette(0.5, remixColorId.value)
                    cursorColor: remixFXSendOn.value ? "white" : colors.colorGrey40
                }
            }
        }
    }
}
