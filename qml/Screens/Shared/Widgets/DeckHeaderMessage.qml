import CSI 1.0
import QtQuick 2.12

Rectangle {
    id: warning_box
    property bool permanentMessage: false
    property bool shortMessageHasBackground: true
    property bool showLongMessage: true
    property int timeInterval: 1000 //1200

    color: deck_header.color
    visible: deckHeaderMessageActive.value

    Rectangle {
        id: short_message_background
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: 20
        color: errorMessage ? colors.red : colors.orange
        visible: shortMessageHasBackground
    }

    Text {
        id: short_message
        anchors.fill: short_message_background
        anchors.leftMargin: 5

        text: deckHeaderMessageShortMessage.value
        font.pixelSize: fonts.middleFontSize
        color: shortMessageHasBackground ? deck_header.color : (errorMessage ? colors.red : colors.orange)

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    Text {
        id: long_message
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 5
        visible: showLongMessage

        text: deckHeaderMessageMessage.value
        font.pixelSize: fonts.smallFontSize
        color: errorMessage ? colors.red : colors.orangeDimmed
        elide: Text.ElideRight

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    Timer {
        id: messageTimer
        interval: timeInterval
        repeat: true
        running: deckHeaderMessageActive.value && !permanentMessage
        onTriggered: {
            if (warning_box.opacity == 1) {
                warning_box.opacity = 0;
            }
            else {
                warning_box.opacity = 1;
            }
        }
    }

    Timer {
        id: backgroundMessageTimer
        interval:timeInterval
        repeat: true
        running: deckHeaderMessageActive.value && permanentMessage && shortMessageHasBackground
        onTriggered: {
            if (short_message_background.visible) {
                short_message_background.visible = false
                short_message.color = errorMessage ? colors.red : colors.orange
            }
            else {
                short_message_background.visible = true
                short_message.color = deck_header.color
            }
        }
    }
}
