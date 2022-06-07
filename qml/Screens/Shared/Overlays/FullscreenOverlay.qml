import QtQuick 2.12

Rectangle {
  id: root

  property bool  active: false
  property int transitionTime: 500

  property alias state: overlay.state //INFO: Alias so that the state can be set externally

  anchors.fill: parent
  anchors.margins: 0
  color: brightMode.value ? "white" :"black"

  Item {
    id: overlay
    states: [
      State { name: "visible"; PropertyChanges { target: root; opacity: 1; active: true } },
      State { name: "up"; PropertyChanges { target: root; opacity: 0; active: false } },
      State { name: "down"; PropertyChanges { target: root; opacity: 0; active: false } },
      State { name: "left"; PropertyChanges { target: root; opacity: 0; active: false } },
      State { name: "right"; PropertyChanges { target: root; opacity: 0; active: false } }
    ]

    transitions: [

      //Slide-out animation
      Transition {
        from: "visible"; to: "up";
        //reversible: true;
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.topMargin"; from: 0; to: -parent.height; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation { target: root; property: "anchors.bottomMargin"; from: 0; to: parent.height; duration: transitionTime; easing.type: Easing.OutExpo }
          }
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          PropertyAction { target: root; property: "anchors.topMargin"; value: 0 }
          PropertyAction { target: root; property: "anchors.bottomMargin"; value: 0 }
        }
      },
      Transition {
        from: "visible"; to: "down";
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation{ target: root; property: "anchors.topMargin"; from: 0; to: parent.height; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation{ target: root; property: "anchors.bottomMargin"; from: 0; to: -parent.height; duration: transitionTime; easing.type: Easing.OutExpo }
          }
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          PropertyAction { target: root; property: "anchors.topMargin"; value: 0 }
          PropertyAction { target: root; property: "anchors.bottomMargin"; value: 0 }
        }
      },
      Transition {
        from: "visible"; to: "left";
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation{ target: root; property: "anchors.leftMargin"; from: 0; to: -parent.width; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation{ target: root; property: "anchors.rightMargin"; from: 0; to: parent.width; duration: transitionTime; easing.type: Easing.OutExpo }
          }
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          PropertyAction { target: root; property: "anchors.leftMargin"; value: 0 }
          PropertyAction { target: root; property: "anchors.rightomMargin"; value: 0 }
        }
      },
      Transition {
        from: "visible"; to: "right";
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation{ target: root; property: "anchors.leftMargin"; from: 0; to: parent.width; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation{ target: root; property: "anchors.rightMargin"; from: 0; to: -parent.width; duration: transitionTime; easing.type: Easing.OutExpo }
          }
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          PropertyAction { target: root; property: "anchors.leftMargin"; value: 0 }
          PropertyAction { target: root; property: "anchors.rightMargin"; value: 0 }
        }
      },

      //Slide-in animation
      Transition {
        from: "up"; to: "visible";
        SequentialAnimation {
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.topMargin"; from: -parent.height; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation { target: root; property: "anchors.bottomMargin"; from: parent.height; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
          }
        }
      },
      Transition {
        from: "down"; to: "visible";
        SequentialAnimation {
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.topMargin"; from: parent.height; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation { target: root; property: "anchors.bottomMargin"; from: -parent.height; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
          }
        }
      },
      Transition {
        from: "left"; to: "visible";
        SequentialAnimation {
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.leftMargin"; from: -parent.width; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation { target: root; property: "anchors.rightMargin"; from: parent.width; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
          }
        }
      },
      Transition {
        from: "right"; to: "visible";
        SequentialAnimation {
          PropertyAction { target: root; property: "opacity" }
          PropertyAction { target: root; property: "active" }
          ParallelAnimation {
            NumberAnimation { target: root; property: "anchors.leftMargin"; from: parent.width; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
            NumberAnimation { target: root; property: "anchors.rightMargin"; from: -parent.width; to: 0; duration: transitionTime; easing.type: Easing.OutExpo }
          }
        }
      }
    ]
  }
}
