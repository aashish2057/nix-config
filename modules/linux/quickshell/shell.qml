import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
	property bool menuOpen: false

	id: menuBar
	screen: Quickshell.screens[0]
	color: "transparent"
	visible: menuOpen

	anchors {
		right: true
	}

	margins {
		right: 6
	}

	Rectangle {
		anchors.fill: parent
		radius: 10
		color: "#0F111A"
		clip: true
	}

	implicitHeight: screen.height * 0.75
	implicitWidth: 30

	IpcHandler {
		target: "menuBar"

		function toggle(): void {
			menuBar.menuOpen = !menuBar.menuOpen
		}
	}
}

 
