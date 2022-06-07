import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
	id: settingsloader

	property string surface: "path"
	property string settingsPath: "mapping.settings.left"
  
	// Traktor root path
    AppProperty { id: root; path: "app.traktor.settings.paths.root" }
	MappingPropertyDescriptor { id: osType; path: "mapping.settings.osType"; type: MappingPropertyDescriptor.Integer; value: 0 }
  
	//HeaderText Settings
	property variant topRow: [0, 0, 0]
	property variant midRow: [0, 0, 0]
	property variant bottomRow: [0, 0, 0]
  
	MappingPropertyDescriptor { id: displayTopLeft; path: "mapping.settings.displayTopLeft"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: displayTopMid; path: "mapping.settings.displayTopMid"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: displayTopRight; path: "mapping.settings.displayTopRight"; type: MappingPropertyDescriptor.Integer; value: 0 }
  
	MappingPropertyDescriptor { id: displayMidLeft; path: "mapping.settings.displayMidLeft"; type: MappingPropertyDescriptor.Integer; value: 5 }
	MappingPropertyDescriptor { id: displayMidMid; path: "mapping.settings.displayMidMid"; type: MappingPropertyDescriptor.Integer; value: 2 }
	MappingPropertyDescriptor { id: displayMidRight; path: "mapping.settings.displayMidRight"; type: MappingPropertyDescriptor.Integer; value: 0 }
  
	MappingPropertyDescriptor { id: displayBottomLeft; path: "mapping.settings.displayBottomLeft"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: displayBottomMid; path: "mapping.settings.displayBottomMid"; type: MappingPropertyDescriptor.Integer; value: 6 }
	MappingPropertyDescriptor { id: displayBottomRight; path: "mapping.settings.displayBottomRight"; type: MappingPropertyDescriptor.Integer; value: 7 }

	//MixerFX Settings
	MappingPropertyDescriptor { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4"; type: MappingPropertyDescriptor.Integer; value: 0 }
  
	//KeyNotation Settings
	MappingPropertyDescriptor { id: keyNotationDisplayed; path: "mapping.settings.keyNotationDisplayed"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: keyNotationExported; path: "mapping.settings.keyNotationExported"; type: MappingPropertyDescriptor.Integer; value: 0 }
	MappingPropertyDescriptor { id: keyNotationExportedByPass; path: "mapping.settings.keyNotationExportedByPass"; type: MappingPropertyDescriptor.Integer; value: 0 }

	//Extract different Traktor settings from TraktorSettings.tsi XML - unfortuntately we have no access to JS functions like DOMParser or QML XML functions so have to do this in a dirty way...
	function extractDeckDisplaySettings(sSettings) {
		var sSearch = '<Entry Name="Fileinfo.Top.Left" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayTopLeft.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		topRow[0] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Top.Mid" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayTopMid.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		topRow[1] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Top.Right" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayTopRight.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		topRow[3] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Mid.Left" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayMidLeft.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		midRow[0] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Mid.Mid" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayMidMid.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		midRow[1] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Mid.Right" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayMidRight.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		midRow[2] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Bottom.Left" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayBottomLeft.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		bottomRow[0] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Bottom.Mid" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayBottomMid.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		bottomRow[1] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Fileinfo.Bottom.Right" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		displayBottomRight.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
		bottomRow[2] = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
	}
  
	function extractMixerFXSettings(sSettings) {
		var sSearch = '<Entry Name="Audio.ChannelFX.1.Type" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		mixerFXAssigned1.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;

		sSearch = '<Entry Name="Audio.ChannelFX.2.Type" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		mixerFXAssigned2.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;

		sSearch = '<Entry Name="Audio.ChannelFX.3.Type" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		mixerFXAssigned3.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;

		sSearch = '<Entry Name="Audio.ChannelFX.4.Type" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		mixerFXAssigned4.value = parseInt(sSettings.substr(0,sSettings.indexOf('">'))) + 1;
	}

	function extractKeyNotationSettings(sSettings) {
		var sSearch = '<Entry Name="Browser.KeyNotation.Displayed" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		keyNotationDisplayed.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Browser.KeyNotation.Exported" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		keyNotationExported.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));

		sSearch = '<Entry Name="Browser.KeyNotation.Exported.ByPass" Type="1" Value="';
		sSettings = sSettings.substr(sSettings.indexOf(sSearch) + sSearch.length);
		keyNotationExportedByPass.value = parseInt(sSettings.substr(0,sSettings.indexOf('">')));
	}
  
	// read Traktor Settings.tsi - format is actually valid XML
		// Example of Traktor's macOS settings file path - Users:nickmoon:Documents:Native Instruments:Traktor 3.0.2:
		// Example of Traktor's Windows settings file path - C:\Users\Nick\Documents\Native Instruments\Traktor 3.0.2\
		// Note in JavaScript \ has to be entered \\

	function readTraktorSettings() {
        var filePath = root.value;
		if (filePath.indexOf(":\\") == 1) {	
			// Windows 
			osType.value = 2;
			filePath = "file:///" + filePath.replace(/\\/g,"/") + "Traktor Settings.tsi";
		}
		else {
			// macOS
			osType.value = 1;
			filePath = "file:///Volumes/" + filePath.replace(/:/g, "/") + "Traktor Settings.tsi";
		}

		var request = new XMLHttpRequest();
		request.onreadystatechange = function() {
			// Need to wait for the DONE state
			if (request.readyState === XMLHttpRequest.DONE) {
				extractDeckDisplaySettings(request.responseText);
				extractMixerFXSettings(request.responseText);
				extractKeyNotationSettings(request.responseText);
				//traktorSettingsRead = request.responseText;
			}
		}
		request.open("GET", filePath, true); // only async supported
		request.send();
	}

}


