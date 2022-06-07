pragma Singleton

import QtQuick 2.12

// Constants to use in enables based on active overlay
QtObject {
    readonly property int disabled: 0
    readonly property int armed: 1
    readonly property int used: 2
    readonly property int full: 3
}

  
