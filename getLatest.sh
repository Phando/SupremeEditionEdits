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

mkdir -p ./qml/CSI/Common/PadsModes
mkdir -p ./qml/Preferences

cp "$target/qml/CSI/Common/PadsModes/EffectsMode.qml" ./qml/CSI/Common/PadsModes
cp "$target/qml/CSI/Common/PadsModes/EffectUnit.qml" ./qml/CSI/Common/PadsModes
cp "$target/qml/Preferences/InstantFXs.qml" ./qml/Preferences

chown -R jandolina: .
echo "Exit"
exit 0  