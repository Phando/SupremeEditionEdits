import CSI 1.0
import QtQuick 2.12

Item {
  property int slice_index // index of this slice
  property bool first_slice // whether we are the first slice in the row
  property bool last_slice // whether we are the last slice in the row

  AppProperty { id: propCurrentSlice; path: "app.traktor.decks." + deckId + ".freeze.current_slice" }
  AppProperty { id: propFirstSliceInRange; path: "app.traktor.decks." + deckId + ".freeze.first_slice_in_range" }
  AppProperty { id: propLastSliceInRange; path: "app.traktor.decks." + deckId + ".freeze.last_slice_in_range" }
  AppProperty { id: propSlicerMode; path: "app.traktor.decks." + deckId + ".freeze.is_slicer_mode" }
  AppProperty { id: propLastActive; path: "app.traktor.decks." + deckId + ".freeze.last_activated_slice"; onValueChanged: { if ( value === slice_index ) fade_animation.trigger() } }

  property int current_slice: propCurrentSlice.value
  property int first_slice_in_range: propFirstSliceInRange.value
  property int last_slice_in_range: propLastSliceInRange.value

  property bool active: slice_index == current_slice
  property bool in_range: slice_index >= first_slice_in_range && slice_index <= last_slice_in_range
  property bool on_beat: false // not implemented
  property bool freeze_mode: propSlicerMode.value == 0

  Component.onCompleted: update_colors();
  onActiveChanged: update_colors();
  onIn_rangeChanged: update_colors();
  onFreeze_modeChanged: update_colors();

  Rectangle {
    id: backgroundColor
    anchors.fill: parent
    anchors.bottomMargin: stemView.value ? 17 : 12
    anchors.leftMargin: 1
    color: freeze_mode ? "transparent" : colors.freezeBackground_inactive // slice background is colored green in loop mode
  }

  Rectangle {
    id: slice_rect
    property real fade: 0

    anchors.fill: parent
    anchors.bottomMargin: 17
    anchors.leftMargin: 1
    // this color is added on top of the  slice color ( in slice mode it turns from transparent to blue , in loop mode the green color brightens up by 20%)
    color: parent.freeze_mode ? colors.freeze_blue : colors.freeze_green
    opacity: parent.freeze_mode ? fade : (parent.in_range ? 1 : 0) // highlighting mechanism

    PropertyAnimation {
        id: fade_animation

        function trigger() {
            stop();
            slice_rect.fade = 1;
            start();
        }

        target: slice_rect
        property: "fade"
        from: 1
        to: 0
        duration: 250
        easing.type: Easing.OutCubic
    }
  }

  function update_colors() {
    left_marker.color = marker_color(first_slice)
    right_marker.color = marker_color(last_slice)
    slice_box.color = box_color()
    slice_number.color = text_color()
  }

  // this function caclulates the color of the box beneath the waveform depending on the current slice state
  function box_color() {
    if (freeze_mode) {
        // should the colors here be deck dependent?
        return active ? colors.brightBlue : colors.colorGrey16 // freeze box bg color (active/inactive)
    }

    if (active) return colors.green;   //  currently active loop slice
    if (in_range) return colors.freezeBackground_selected; //  loopslices in selected range
    return colors.freezeBackground_inactive				 //  inactive loop slices
  }

  function marker_color(edge) {
    if (freeze_mode) {
        return colors.colorGrey48;			// freeze marker color
    }
    else {
        if (edge) return colors.green; // edge marker color in loop mode (invisible in freeze mode)
        if (on_beat) return "black";			 // not implemented yet
        return colors.loop_marker;				// marker color in loop mode
    }
  }

  function text_color() {
    if (freeze_mode && !active) {
        return colors.brightBlue;	 // freeze box text color
    }
    if (!freeze_mode && !active) {
        return colors.green;				// loop box text color
    }
    return colors.colorBlack;				// text color when slice is active
  }

  Rectangle {
    id: left_marker
    width: 1
    height: parent.height
    // color set in function
  }

  Rectangle {
    id: right_marker
    width: 1
    height: parent.height
    x: parent.width
    visible: parent.last_slice
    // color set in function
  }

  // box at bottom of slice
  Rectangle {
    id: slice_box
    property int box_height: stemView.value ? 13 : 9
    height: box_height
    anchors.fill: parent
    anchors.leftMargin: 3
    anchors.rightMargin: 2
    anchors.topMargin: parent.height - box_height
    // color set above

    Text {
        id: slice_number
        text: slice_index+1
        anchors.horizontalCenter: slice_box.horizontalCenter
        anchors.verticalCenter: slice_box.verticalCenter
        font.pixelSize: fonts.scale(9)
        font.bold: true
    }
  }
}
