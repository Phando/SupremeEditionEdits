#!/bin/bash
if [ "$EUID" -ne 0 ] 
then 
    echo
    echo "Please run as root"
    echo
    exit
fi

echo "Copying - Modified Files"
target="/Applications/Native Instruments/Traktor Pro 3/Traktor.app/Contents/Resources"

# Can we find Traktor
if [ ! -d "$target" ] 
then
    echo "Could not find Traktor at $target" 
    exit
fi

cp ./qml/Screens/S4MK3/Views/Widgets/PerformancePanel.qml "$target/qml/Screens/S4MK3/Views/Widgets"
cp ./qml/Screens/S8/Views/Widgets/PerformancePanel.qml "$target/qml/Screens/S8/Views/Widgets"
cp ./qml/CSI/Common/PadsModes/*.qml "$target/qml/CSI/Common/PadsModes" 
cp ./qml/Preferences/InstantFXs.qml "$target/qml/Preferences" 

chown -R jandolina: .
echo "Exit"
exit 0  