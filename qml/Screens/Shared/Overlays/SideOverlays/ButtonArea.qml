import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../Widgets' as Widgets

Rectangle {
    id: buttonArea
    property bool isLeftRow
    property string contentState
    property int scrollPosition
    property int textAngle
    property alias topText: topText.text
    property alias bottomText: bottomText.text
    property alias visibleState: visibleState.state
    property bool isTopHighlighted: false
    property bool isBottomHighlighted: false

    anchors.top: parent.top
    anchors.topMargin: contentState == "ScrollBar" ? 60 : ((contentState == "EditIcons" || contentState == "Magnifiers") ? 80 : 60)
    anchors.bottom: parent.bottom
    anchors.bottomMargin: contentState == "ScrollBar" ? 60 : ((contentState == "EditIcons" || contentState == "Magnifiers") ? 70 : 50)
    width: 38
    color: colors.colorBlack

    /*
    //Glow
    RectangularGlow {
        id: buttonAreaGlow
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        glowRadius: 4
        spread: 0
        color: "transparent"
        cornerRadius: buttonArea.radius + glowRadius
    }

    //Black border
    Rectangle {
        id: buttonAreaBorder
        anchors.fill: buttonArea
        color: colors.colorBlack
    }
    */

    //Background
    Rectangle {
        id: buttonAreaBg
        anchors.fill: parent
        color: colors.colorFxHeaderBg
        anchors.margins: 2
    }

    //Top Rectangle
    Rectangle {
        id: topButtonAreaBg
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        height: (parent.height-6)/2
        width: parent.width-4
        color: content.state == "EditIcons" ? (gridLock.value? colors.cyan : colors.colorFxHeaderBg) : colors.colorFxHeaderBg
        visible: content.state != "ScrollBar" ? true : false

        Image {
            id: gridLockImage
            source: "../../Images/gridLock.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 5
            width: 35
            height: 35
            visible: false
        }

        ColorOverlay {
            id: gridLock_color
            anchors.fill: gridLockImage
            source: gridLockImage
            color: gridLock.value? "black" : colors.colorGrey72
        }

        Image {
            id: magnifierPlus
            source: "../../Images/Overlay_PlusIcon.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: sourceSize.width
            height: sourceSize.height
            opacity: 0.3
        }
    }
    Text {
        id: topText
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.bottom: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right

        text: ""
        color: isTopHighlighted ? colors.colorGrey32 : colors.colorGrey72
        font.pixelSize: fonts.smallFontSize
        rotation: -90
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    //Bottom Rectangle
    Rectangle {
        id: bottomButtonAreaBg
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 2
        anchors.rightMargin: 2
        height: (parent.height-6)/2
        width:  parent.width-4
        color: content.state == "EditIcons" ? (isTrackTick.value? colors.cyan : colors.colorFxHeaderBg) : colors.colorFxHeaderBg
        visible: content.state != "ScrollBar" ? true : false

        Image {
            id: beatTick
            source: "../../Images/PreviewIcon_Big.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: sourceSize.width
            height: sourceSize.height
            visible: false
        }

        ColorOverlay {
            id: beatTick_color
            anchors.fill: beatTick
            source: beatTick
            color: isTrackTick.value? "black" : colors.colorGrey72
            visible: false //set in state
        }
        Image {
            id: magnifierMinus
            source: "../../Images/Overlay_MinusIcon.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: sourceSize.width
            height: sourceSize.height
            opacity: 0.3
        }
    }
    Text {
        id: bottomText
        anchors.top: parent.verticalCenter
        anchors.topMargin: -2
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right

        text: ""
        color: isBottomHighlighted ? colors.colorGrey32 : colors.colorGrey72
        font.pixelSize: fonts.smallFontSize
        rotation: -90
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    //ScrollBar
    RemixScrollBar {
        id: remixScrollBar
        anchors.fill: parent
        currentPosition: parent.scrollPosition
    }

//------------------------------------------------------------------------------------------------------------------
//  STATES
//------------------------------------------------------------------------------------------------------------------

    Item {
        id: visibleState
        state: "hide"

        states: [
            State {
                name: "hide"
                PropertyChanges { target: buttonArea; opacity: 0 }
            },
            State {
                name: "show"
                PropertyChanges { target: buttonArea; opacity: 1 }
            }
        ]

        transitions: [
            Transition {
                from: "hide"; to: "show";
                NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 100 }
            },
            Transition {
                from: "show"; to: "hide";
                NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad; duration: 100 }
            }
        ]
    }

    Item {
        id: content
        state: contentState
        states: [
            State {
                // remix deck indicators
                name: "ScrollBar"
                PropertyChanges { target: buttonAreaBg; visible: true }
                PropertyChanges { target: remixScrollBar; visible: true }
                PropertyChanges { target: topText; visible: false }
                PropertyChanges { target: bottomText; visible: false }
                PropertyChanges { target: magnifierPlus; visible: false }
                PropertyChanges { target: magnifierMinus; visible: false }
                PropertyChanges { target: gridLock_color; visible: false }
                PropertyChanges { target: beatTick_color; visible: false }
            },
            State {
                name: "TextArea"
                PropertyChanges { target: buttonAreaBg; visible: false }
                PropertyChanges { target: remixScrollBar; visible: false }
                PropertyChanges { target: topText; visible: true }
                PropertyChanges { target: bottomText; visible: true }
                PropertyChanges { target: magnifierPlus; visible: false }
                PropertyChanges { target: magnifierMinus; visible: false }
                PropertyChanges { target: gridLock_color; visible: false }
                PropertyChanges { target: beatTick_color; visible: false }
            },
            State {
                name: "Magnifiers"
                PropertyChanges { target: buttonAreaBg; visible: false }
                PropertyChanges { target: remixScrollBar; visible: false }
                PropertyChanges { target: topText; visible: false }
                PropertyChanges { target: bottomText; visible: false }
                PropertyChanges { target: magnifierPlus; visible: true }
                PropertyChanges { target: magnifierMinus; visible: true }
                PropertyChanges { target: gridLock_color; visible: false }
                PropertyChanges { target: beatTick_color; visible: false }
            },
            State {
                name: "EditIcons"
                PropertyChanges { target: buttonAreaBg; visible: false }
                PropertyChanges { target: remixScrollBar; visible: false }
                PropertyChanges { target: topText; visible: false }
                PropertyChanges { target: bottomText; visible: false }
                PropertyChanges { target: magnifierPlus; visible: false }
                PropertyChanges { target: magnifierMinus; visible: false }
                PropertyChanges { target: gridLock_color; visible: true }
                PropertyChanges { target: beatTick_color; visible: true }
            }
        ]
    }
}
