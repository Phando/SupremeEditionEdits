import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Rectangle {
  id: syncBox

  property bool clockIndicator: false
  property bool masterIndicator: false
  property bool phaseIndicator: false
  property bool phaseIndicatorOnlyWhileRunning: false
  property bool phaseIndicatorOkWhilePaused: true
  property bool phaseLabel: false

  property color textColor: "black"
  property color backgroundColor: colors.colorGrey72

  property color clockColor: colors.cyan
  property color masterColor: colors.greenActive
  property color syncColor: colors.greenActive
  property color phaseColor: colors.red

  color: getBackgroundColor()

  Text {
    anchors.fill: parent
    anchors.topMargin: 1
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: clockIndicator && masterId.value == -1 && isSyncEnabled.value ? "Clock" : (isSyncEnabled.value && (!phaseIndicatorOnlyWhileRunning || (phaseIndicatorOnlyWhileRunning && isRunning.value)) && !syncInPhase && phaseLabel ? "Phase" : "Sync")
    font.pixelSize: fonts.smallFontSize
    font.capitalization: Font.AllUppercase
    color: getLabelColor()
  }

  function getBackgroundColor() {
    //Master
    if (isMaster && isSyncEnabled.value && masterIndicator) {
        return masterColor
    }
    //Synchronized to clock
    else if (masterId.value == -1 && isSyncEnabled.value && clockIndicator) {
        return clockColor
    }
    //Synchronized to deck
    else if (isSyncEnabled.value) {
        if (!phaseIndicator) return syncColor
        //In phase
        else if (((!phaseIndicatorOnlyWhileRunning || (phaseIndicatorOnlyWhileRunning && isRunning.value)) && syncInPhase) || (!isRunning.value && phaseIndicatorOkWhilePaused))  return syncColor
        //Out of phase
        else return phaseColor
    }
    //Sync disabled
    else return backgroundColor
  }

  function getLabelColor() {
    if (isSyncEnabled.value) {
        if (getBackgroundColor() != backgroundColor) return "black"
        //INFO: This is just in case I'm missing any scenario
        else if ((!phaseIndicatorOnlyWhileRunning || (phaseIndicatorOnlyWhileRunning && isRunning.value)) && syncInPhase) return "black"
        else return syncColor
    }
    //Sync disabled
    else return textColor
  }
}