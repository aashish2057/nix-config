import Quickshell

PanelWindow {
	screen: Quickshell.screens[0]
	color: "#0F111A"

	anchors {
		right: true
	}

	margins {
		right: 6
	}

	implicitHeight: screen.height * 0.75
	implicitWidth: 30
}
