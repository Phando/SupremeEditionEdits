import CSI 1.0
import QtQuick 2.12

Rectangle {
    id: side
    property int topDeckId: 1
    property int bottomDeckId: 3

    color: brightMode.value ? "white" : colors.colorBlack

//------------------------------------------------------------------------------------------------------------------
// DECKS INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    Deck {
        id: topDeck
        deckId: topDeckId

        /*
        anchors.left: parent.left
        anchors.right: parent.right
        height: smallDeckHeight
        y: 0 //INFO: Do not use anchors.top or we won't be able to animate y
        visible: height != 0
        */
        anchors.fill: parent
        visible: topDeckFocused.value
        clip: true
    }

    Deck {
        id: bottomDeck
        deckId: bottomDeckId

        /*
        anchors.top: topDeck.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: height != 0
        */
        anchors.fill: parent
        visible: !topDeckFocused.value
        clip: true
    }

//------------------------------------------------------------------------------------------------------------------
// DECK FOCUS
//------------------------------------------------------------------------------------------------------------------

    MappingProperty { id: topDeckFocused; path: propertiesPath + ".top_deck_focus" }

    property int focusedDeckId: topDeckFocused.value ? topDeckId : bottomDeckId
    property int unfocusedDeckId: !topDeckFocused.value ? topDeckId : bottomDeckId
    property int remixId: (focusedDeck().hasRemixProperties || !unfocusedDeck().hasRemixProperties) || onlyFocusedDeck.value ? focusedDeckId : unfocusedDeckId
    property int footerId: (focusedDeck().hasBottomControls || !unfocusedDeck().hasBottomControls) || onlyFocusedDeck.value ? focusedDeckId : unfocusedDeckId

    function focusedDeck() {
        return topDeckFocused.value ? topDeck : bottomDeck
    }

    function unfocusedDeck() {
        return !topDeckFocused.value ? topDeck : bottomDeck
    }

//--------------------------------------------------------------------------------------------------------------------
// DECKS STATES
//--------------------------------------------------------------------------------------------------------------------

    /*
    readonly property int largeDeckHeight: sideHeight
    readonly property int mediumDeckHeight: largeDeckHeight - smallDeckHeight
    readonly property int smallDeckHeight: 82 //Waveform+Header //58

    state: topDeckFocused.value ? (screenIsSingleDeck.value ? "TOP" : "TOPbottom") : (screenIsSingleDeck.value ? "BOTTOM" : "topBOTTOM")
    states: [
        State {
            name: "TOP"; // Top deck --> Single view
            PropertyChanges { target: topDeck; deckSize: "large"; height: largeDeckHeight; y: 0 }
            PropertyChanges { target: bottomDeck; deckSize: "small"; height: 0 }
        },
        State {
            name: "TOPbottom"; // Dual view (top focus)
            PropertyChanges { target: topDeck; deckSize: "medium"; height: mediumDeckHeight; y: 0 }
            PropertyChanges { target: bottomDeck; deckSize: "small";  height: smallDeckHeight;		 }
        },
        State {
            name: "topBOTTOM"; // Dual view (bottom focus)
            PropertyChanges { target: topDeck; deckSize: "small";  height: smallDeckHeight;  y: 0 }
            PropertyChanges { target: bottomDeck; deckSize: "medium"; height: mediumDeckHeight;		}
        },
        State {
            name: "BOTTOM";  // Bottom deck --> Single view
            PropertyChanges { target: topDeck; deckSize: "small"; height: 0; y: 0 }
            PropertyChanges { target: bottomDeck; deckSize: "large"; height: largeDeckHeight }
        }
    ]

    //Transitions
    readonly property int speed: durations.deckTransition
    transitions: [
        Transition {
            from: "TOP"; to: "TOPbottom";
            SequentialAnimation {
                PropertyAction  { target: bottomDeck; property: "height"; value: smallDeckHeight }
                NumberAnimation { target: topDeck; property: "height"; duration: speed }
            }
        },
        Transition {
            from: "TOPbottom"; to: "TOP";
            SequentialAnimation {
                NumberAnimation { target: topDeck; property: "height"; duration: speed }
                PropertyAction  { target: bottomDeck; property: "height"; value: 0 }
            }
        },
        Transition {
            from: "TOPbottom"; to: "topBOTTOM";
            SequentialAnimation {
                PropertyAction  { target: topDeck; property: "deckSize" }
                PropertyAction  { target: bottomDeck; property: "deckSize" }

                ParallelAnimation {
                    NumberAnimation { target: topDeck; property: "height"; duration: speed }
                    NumberAnimation { target: bottomDeck; property: "height"; duration: speed }
                }
                PropertyAction  { target: topDeck; property: "deckSize" }
            }
        },
        Transition {
            from: "topBOTTOM"; to: "TOPbottom";
            SequentialAnimation {
                PropertyAction  { target: topDeck; property: "deckSize" }
                PropertyAction  { target: bottomDeck; property: "deckSize" }
                ParallelAnimation {
                    NumberAnimation { target: topDeck; property: "height"; duration: speed }
                    NumberAnimation { target: bottomDeck; property: "height"; duration: speed }
                }
                PropertyAction  { target: bottomDeck; property: "deckSize" }
            }
        },
        Transition {
            from: "topBOTTOM"; to: "BOTTOM";
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: bottomDeck; property: "height"; duration: speed }
                    NumberAnimation { target: topDeck; property: "y"; to: -smallDeckHeight; duration: speed }
                }
                PropertyAction  { target: topDeck; property: "y" }
                PropertyAction  { target: topDeck; property: "height" }
            }
        },
        Transition {
            from: "BOTTOM"; to: "topBOTTOM";
            SequentialAnimation {
                PropertyAction  { target: topDeck; property: "y"; value: -smallDeckHeight }
                PropertyAction  { target: topDeck; property: "height";					}
                ParallelAnimation {
                    NumberAnimation { target: bottomDeck; property: "height"; duration: speed }
                    NumberAnimation { target: topDeck; property: "y"; duration: speed }
                }
            }
        },
        Transition {
            from: "BOTTOM"; to: "TOP";
            SequentialAnimation {
                PropertyAction  { target: topDeck; property: "y"; value: -side.height }
                PropertyAction  { target: topDeck; property: "height"; value: side.height }
                NumberAnimation { target: topDeck; property: "y"; duration: speed }
                PropertyAction  { target: bottomDeck; property: "height" }
                PropertyAction  { target: bottomDeck; property: "deckSize" }
            }
        },
        Transition {
            from: "TOP"; to: "BOTTOM";
            SequentialAnimation {
                PropertyAction  { target: bottomDeck; property: "height" }
                NumberAnimation { target: topDeck; property: "y"; to:-side.height; duration: speed }
                PropertyAction  { target: topDeck; property: "height" }
                PropertyAction  { target: topDeck; property: "y" }
                PropertyAction  { target: topDeck; property: "deckSize" }
            }
        }
    ]
    */
}
