import CSI 1.0
import QtQuick 2.12

Item {
  id : phaseMeter
  property int deckId: 1
  property color masterColor: colors.orange
  property color deckColor: colors.green //colors.cyan
  property bool masterLetter: false

  AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
  AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }

  MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase" }
  MappingProperty { id: beatCounterMode; path: "mapping.settings.beatCounterMode" }

  MappingProperty { id: beatCounterX; path: deckPropertiesPath + ".beatgrid.counter.x" }
  MappingProperty { id: beatCounterY; path: deckPropertiesPath + ".beatgrid.counter.y" }
  MappingProperty { id: beatCounterZ; path: deckPropertiesPath + ".beatgrid.counter.z" }

//------------------------------------------------------------------------------------------------------------------
// Master Beats Value
//------------------------------------------------------------------------------------------------------------------

  Text {
    id: masterBeatsString
    anchors.bottom: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right
    font.pixelSize: fonts.scale(14)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    color: masterColor
    text: masterId.value > -1 ? (masterId.value + 1 == deckId ? "--.-" : utils.beatCounterString((masterId.value+1), beatCounterMode.value)) : "CLOCK"
  }

  Text {
    id: masterLetterString
    anchors.bottom: parent.verticalCenter
    anchors.right: masterBeatsString.right
    anchors.rightMargin: 55
    font.pixelSize: fonts.scale(14)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    color: masterColor
    text: deckLetters[masterId.value] + ":"
    visible: masterLetter
  }

//------------------------------------------------------------------------------------------------------------------
// Deck Beats Value
//------------------------------------------------------------------------------------------------------------------

  Text {
    anchors.top: parent.verticalCenter
    anchors.topMargin: 2
    anchors.left: parent.left
    anchors.right: parent.right
    color: deckColor
    text: isLoaded.value ? utils.beatCounterString(deckId, beatCounterMode.value) : "--.-"
    font.pixelSize: fonts.scale(14)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
  }
}
