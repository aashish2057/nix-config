import Quickshell
import Quickshell.Io

PanelWindow {
	property bool menuOpen: false

	id: menuBar
	screen: Quickshell.screens[0]
	color: "#0F111A"
	visible: menuOpen

	anchors {
		right: true
	}

	margins {
		right: 6
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

 
