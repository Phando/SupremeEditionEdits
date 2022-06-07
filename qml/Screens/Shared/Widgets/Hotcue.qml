import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor
import QtGraphicalEffects 1.12
import CSI 1.0


// The hotcue can be used to show all different types of hotcues. Type switching is done by using the 'hotcue state'.
// The number shown in the hotcue can be set by using hotcueId.
Item {
  id : hotcue
  property int deckId: 1
  property int hotcueId
  property int hotcueLength
  property bool showHead
  property bool smallHead

  property int topMargin: 6
  property color hotcueColor: (exists.value && type.value != -1) ? colors.hotcueColor(hotcueId, type.value, exists.value, hotcueColors.value) : "transparent"
  property var letters: ["A", "B", "C", "D", "E", "F", "G", "H"]
  property string hotcueText: hotcueColors.value != 0 ? letters[hotcueId-1] : hotcueId //charCode: 0x0040 + hotcueId
  height: parent.height
  clip: false

  readonly property double borderWidth: 2
  readonly property bool useAntialiasing: true
  readonly property int smallCueHeight: height + 3
  readonly property int smallCueTopMargin: 0 //-4
  readonly property int largeCueHeight: height + 3
  readonly property var hotcueMarkerTypes: { 0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  readonly property string hotcueState: (exists.value && type.value != -1) ? (hotcueColors.value != 0 ? "rekordbox" : hotcueMarkerTypes[type.value]) : "off"


  AppProperty { id: pos;	path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueId + ".start_pos" }
  AppProperty { id: length; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueId + ".length" }
  AppProperty { id: type;   path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueId + ".type" }
  AppProperty { id: active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueId + ".active" }
  AppProperty { id: exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + hotcueId + ".exists" }

  //--------------------------------------------------------------------------------------------------------------------
  // If the hotcue should only be represented as a single line, use 'flagpole'

  Rectangle {
    id: flagpole
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    height: smallCueHeight - 2
    width: 3
    border.width: 1
    border.color: colors.colorBlack50
    color: hotcueColor
    visible: !showHead && (smallHead == true)
  }

  //--------------------------------------------------------------------------------------------------------------------
  // cue loader loads the different kinds of hotcues depending on their type (-> states at end of file)

  Item {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: smallHead ? 32 : (parent.height)
    width: 40
    clip: false
    visible: showHead
    Loader {
      id: cueLoader
      anchors.fill: parent
      active: true
      visible: true
      clip: false
    }
  }

  // GRID --------------------------------------------------------------------------------------------------------------

  Component {
    id: gridComponentSmall
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.topMargin: smallCueTopMargin
      anchors.leftMargin: -8

      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50

      points: [ Qt.point(0 , 10)
              , Qt.point(0 , 0)
              , Qt.point(13, 0)
              , Qt.point(13, 10)
              , Qt.point(7 , 14)
              , Qt.point(7 , smallCueHeight-4)
              , Qt.point(6 , smallCueHeight-4)
              , Qt.point(6 , 14)
              ]
      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.topMargin: -1
        color: colors.colorBlack
        text: hotcueText
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  Component {
    id: gridComponentLarge
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.leftMargin: -10
      anchors.topMargin: -1
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(0 , 12)
              , Qt.point(0 , 0)
              , Qt.point(15, 0)
              , Qt.point(15, 12)
              , Qt.point(8 , 17)
              , Qt.point(8 , largeCueHeight-4)
              , Qt.point(7 , largeCueHeight-4)
              , Qt.point(7 , 17)
              ]
      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 5
        color: colors.colorBlack
        text: hotcueText
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  // CUE ----------------------------------------------------------------------------------------------------------------

  Component {
    id: hotcueComponentSmall
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.topMargin: smallCueTopMargin
      anchors.leftMargin: -2
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(0 , 0)
              , Qt.point(12, 0)
              , Qt.point(15, 5.5)
              , Qt.point(12, 11)
              , Qt.point(1 , 11)
              , Qt.point(1 , smallCueHeight-4)
              , Qt.point(0 , smallCueHeight-4)
              ]
      Text {
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.leftMargin: 4
        anchors.topMargin: -1
        color: colors.colorBlack;
        text: hotcueText;
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  Component {
    id: hotcueComponentLarge
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.leftMargin: -3
      anchors.topMargin: -1
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(0 , 0)
              , Qt.point(14, 0)
              , Qt.point(19, 6.5)
              , Qt.point(14, 13)
              , Qt.point(1 , 13)
              , Qt.point(1 , largeCueHeight-4)
              , Qt.point(0 , largeCueHeight-4)
              ]
      Text {
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.leftMargin: 5
        color: colors.colorBlack;
        text: hotcueText;
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  // FADE IN -----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeInComponentSmall
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.right: cueLoader.right
      anchors.topMargin: smallCueTopMargin
      anchors.rightMargin: -1
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(-0.4, 11)
              , Qt.point(5 , 0)
              , Qt.point(17, 0)
              , Qt.point(17, smallCueHeight-4)
              , Qt.point(16, smallCueHeight-4)
              , Qt.point(16, 11)
              ]

      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: -1
        anchors.leftMargin: borderWidth + 6
        color: colors.colorBlack
        text: hotcueText;
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  Component {
    id: fadeInComponentLarge
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.topMargin: -1
      anchors.leftMargin: -23
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(-0.4 , 13)
              , Qt.point(6 , 0)
              , Qt.point(20, 0)
              , Qt.point(20, largeCueHeight-4)
              , Qt.point(19, largeCueHeight-4)
              , Qt.point(19, 13)
              ]

      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 9
        color: colors.colorBlack
        text: hotcueText;
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  // FADE OUT ----------------------------------------------------------------------------------------------------------

  Component {
    id: fadeOutComponentSmall
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.topMargin: smallCueTopMargin
      anchors.leftMargin: -2
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(0, 0)
              , Qt.point(12, 0)
              , Qt.point(17, 11)
              , Qt.point(1, 11)
              , Qt.point(1, smallCueHeight-4)
              , Qt.point(0, smallCueHeight-4)
              ]
      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 4.5
        anchors.topMargin: -1
        color: colors.colorBlack;
        text: hotcueText;
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  Component {
    id: fadeOutComponentLarge
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.leftMargin: -3
      anchors.topMargin: -1
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(0, 0)
              , Qt.point(14, 0)
              , Qt.point(20, 13)
              , Qt.point(1, 13)
              , Qt.point(1, largeCueHeight-4)
              , Qt.point(0, largeCueHeight-4)
              ]
      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 6
        color: colors.colorBlack
        text: hotcueText
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  // LOAD --------------------------------------------------------------------------------------------------------------

  Component {
    id: loadComponentSmall
    Item {
      anchors.top: cueLoader.top
      anchors.topMargin: smallCueTopMargin
      anchors.horizontalCenter: cueLoader.horizontalCenter
      clip: false

      // pole border
      Rectangle {
        anchors.top: circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin: 4
        width: 3
        height: 18
        color: colors.colorBlack50
      }

      // round head
      Rectangle {
        id: circle
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: -1
        color: hotcueColor
        width: 15
        height: width
        radius: 0.5*width
        border.width: 1
        border.color: colors.colorBlack50

        Text {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.leftMargin: 4
          anchors.topMargin: 0
          color: colors.colorBlack
          text: hotcueText
          font.pixelSize: fonts.smallFontSize
        }
      }
      // pole
      Rectangle {
        anchors.top: circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin: 5
        anchors.topMargin: -1
        width: 1
        height: hotcue.height - circle.width + 2
        color: hotcueColor
      }

    }
  }

  Component {
    id: loadComponentLarge
    Item {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.leftMargin: -21
      anchors.topMargin: -2
      height: cueLoader.height
      clip: false

      // pole border
      Rectangle {
        anchors.top: circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.leftMargin: 4
        width: 3
        height: hotcue.height - circle.height + 1
        color: colors.colorBlack50
      }

      // round head
      Rectangle {
        id: circle
        anchors.top: parent.top
        anchors.topMargin: -1
        anchors.horizontalCenter: parent.horizontalCenter
        color: hotcueColor
        width: 19
        height: width
        radius: 0.5*width
        border.width: borderWidth
        border.color: colors.colorBlack50

        Text {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.leftMargin: 6
          anchors.topMargin: 2
          color: colors.colorBlack
          text: hotcueText
          font.pixelSize: fonts.smallFontSize
        }
      }

      // pole
      Rectangle {
        anchors.top: circle.bottom
        anchors.horizontalCenter: circle.horizontalCenter
        anchors.topMargin: -2
        anchors.leftMargin: 5
        width: 1
        height: hotcue.height - circle.height + 5
        color: hotcueColor
      }
    }
  }

  // LOOP --------------------------------------------------------------------------------------------------------------

   Component {
      id: loopComponentSmall
    Item {
      clip: false
      anchors.top: cueLoader.top
      anchors.topMargin: smallCueTopMargin
      anchors.left: cueLoader.left
      Traktor.Polygon {
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: -15
        antialiasing: true
        color: hotcueColor
        border.width: borderWidth
        border.color: colors.colorBlack50
        points: [ Qt.point(0 , 11)
                , Qt.point(0 , 0)
                , Qt.point(14, 0)
                , Qt.point(14, smallCueHeight-4)
                , Qt.point(13, smallCueHeight-4)
                , Qt.point(13, 11)
                ]

        Text {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.leftMargin: 4
          anchors.topMargin: -1
          color: colors.colorBlack
          text: hotcueText
          font.pixelSize: fonts.smallFontSize
        }
      }

      Traktor.Polygon {
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: hotcueLength -1
        // anchors.topMargin: topMargin
        antialiasing: useAntialiasing

        color: hotcueColor
        border.width: borderWidth
        border.color: colors.colorBlack50
        points: [ Qt.point(0, 0)
                , Qt.point(14, 0)
                , Qt.point(14, 11)
                , Qt.point(1, 11)
                , Qt.point(1, smallCueHeight-4)
                , Qt.point(0, smallCueHeight-4)
                ]
      }
    }
  }

  Component {
    id: loopComponentLarge
    Item {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.left
      anchors.topMargin: -1
      anchors.leftMargin: -1
      clip: false
      Traktor.Polygon {
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: -17
        antialiasing: true
        color: hotcueColor
        border.width: borderWidth
        border.color: colors.colorBlack50

        points: [ Qt.point(0 , 13)
                , Qt.point(0 , 0)
                , Qt.point(16, 0)
                , Qt.point(16, largeCueHeight-4)
                , Qt.point(15, largeCueHeight-4)
                , Qt.point(15, 13)
                ]

        Text {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.leftMargin: 5
          color: colors.colorBlack
          text: hotcueText
          font.pixelSize: fonts.smallFontSize
        }
      }

      Traktor.Polygon {
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: hotcueLength -1
        antialiasing: useAntialiasing

        color: hotcueColor
        border.width: borderWidth
        border.color: colors.colorBlack50
        points: [ Qt.point(0, 0)
                , Qt.point(16, 0)
                , Qt.point(16, 13)
                , Qt.point(1, 13)
                , Qt.point(1, largeCueHeight-4)
                , Qt.point(0, largeCueHeight-4)
                ]
      }
    }
  }

  // RB Style --------------------------------------------------------------------------------------------------------------

  Component {
    id: rbComponentSmall
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.topMargin: smallCueTopMargin
      anchors.leftMargin: -8

      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50

      points: [ Qt.point(0 , 10)
              , Qt.point(0 , 0)
              , Qt.point(13, 0)
              , Qt.point(13, 10)
              ]
      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.topMargin: -1
        color: colors.colorBlack
        text: hotcueText
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  Component {
    id: rbComponentLarge
    Traktor.Polygon {
      anchors.top: cueLoader.top
      anchors.left: cueLoader.horizontalCenter
      anchors.leftMargin: -10
      anchors.topMargin: -1
      antialiasing: useAntialiasing

      color: hotcueColor
      border.width: borderWidth
      border.color: colors.colorBlack50
      points: [ Qt.point(0 , 12)
              , Qt.point(0 , 0)
              , Qt.point(15, 0)
              , Qt.point(15, 12)
              ]
      Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 5
        color: colors.colorBlack
        text: hotcueText
        font.pixelSize: fonts.smallFontSize
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  state: hotcueState
  states: [
    State {
      name: "off";
      PropertyChanges { target: hotcue; visible: false }
    },
    State {
      name: "grid";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? gridComponentSmall : gridComponentLarge }
      PropertyChanges { target: hotcue; visible: true }
    },
    State {
      name: "hotcue";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? hotcueComponentSmall : hotcueComponentLarge  }
      PropertyChanges { target: hotcue; visible: true }
    },
    State {
      name: "fadeIn";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? fadeInComponentSmall : fadeInComponentLarge }
      PropertyChanges { target: hotcue; visible: true }
    },
    State {
      name: "fadeOut";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? fadeOutComponentSmall : fadeOutComponentLarge }
      PropertyChanges { target: hotcue; visible: true }
    },
    State {
      name: "load";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? loadComponentSmall : loadComponentLarge }
      PropertyChanges { target: hotcue; visible: true }
    },
    State {
       name: "loop";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? loopComponentSmall : loopComponentLarge }
      PropertyChanges { target: hotcue; visible: true }
    },
    State {
      name: "rekordbox";
      PropertyChanges { target: cueLoader; sourceComponent: smallHead ? rbComponentSmall : rbComponentLarge }
      PropertyChanges { target: hotcue; visible: true }
    }
  ]
}
