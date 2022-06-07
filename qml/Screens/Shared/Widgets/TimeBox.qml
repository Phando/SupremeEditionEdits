import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Item {
  id: timeField

  property bool remaining: true
  property bool showMiliseconds: true

  property int timeSize: 27
  property int msSize: 24

  width: minutes.paintedWidth + separator.paintedWidth + seconds.paintedWidth + (showMiliseconds ? miliseconds.paintedWidth : 0) + 3
  height: minutes.paintedHeight - 1

  //Minutes
  Text {
    id: minutes
    anchors.bottom: parent.bottom
    anchors.right: separator.left
    color: colors.colorGrey232
    font.pixelSize: fonts.scale(timeSize)
    font.family: "Pragmatica"
    text: getMinutes()
  }

  function getMinutes() {
    let time = remaining ? trackLength.value - elapsedTime.value : elapsedTime.value
    if (time < 0) time = 0;

    let seconds = Math.floor(time % 60);
    let minutes = (Math.floor(time) - seconds) / 60;
    if (minutes < 10) return (remaining ? "- 0" : "0") + minutes
    else return remaining ? "-" + minutes : minutes
  }

  //Separator
  Text {
    id: separator
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: -1
    color: colors.colorGrey232
    font.pixelSize: fonts.scale(timeSize)
    font.family: "Pragmatica"
    text: ":"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  //Seconds
  Text {
    id: seconds
    anchors.bottom: parent.bottom
    anchors.left: separator.right
    color: colors.colorGrey232
    font.pixelSize: fonts.scale(timeSize)
    font.family: "Pragmatica"
    text: getSeconds()
  }

  function getSeconds() {
    let time = remaining ? trackLength.value - elapsedTime.value : elapsedTime.value
    if (time < 0) time = 0;

    let seconds = Math.floor(time % 60);
    if (seconds < 10) return "0" + seconds;
    else return seconds
  }

  //Miliseconds
  Text {
    id: miliseconds
    anchors.bottom: parent.bottom
    anchors.left: seconds.right
    color: colors.colorGrey72
    font.pixelSize: fonts.scale(msSize)
    font.family: "Pragmatica"
    text: getMiliseconds()
    visible: showMiliseconds
  }

  function getMiliseconds() {
    let time = remaining ? trackLength.value - elapsedTime.value : elapsedTime.value
    if (time < 0) time = 0;

    let ms = Math.floor((time % 1) * 10);
    return "." + ms;
  }
}