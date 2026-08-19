import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets

PanelWindow {
	property bool menuOpen: true

	id: menuBar
	screen: Quickshell.screens[0]
	color: "transparent"
	visible: menuOpen

	anchors {
		top: true
	}

	margins {
		top: 6
	}

	Rectangle {
		anchors.fill: parent
		radius: 10
		color: "#0F111A"
		clip: true

		IconImage {
			id: nixIcon
			source: Qt.resolvedUrl("./icons/nix.svg")
			implicitSize: 16

			anchors {
				left: parent.left
				leftMargin: 10
				verticalCenter: parent.verticalCenter
			}
		}

		Text {
			anchors.centerIn: parent
			text: Qt.formatDateTime(clock.date, "hh:mm AP")
			color: "#A6ACCD"
			font.pixelSize: 14
			font.family: "Berkeley Mono"
			font.weight: Font.Bold
		}
	}

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	implicitHeight: 30
	implicitWidth: screen.width * 0.75

	IpcHandler {
		target: "menuBar"

		function toggle(): void {
			menuBar.menuOpen = !menuBar.menuOpen
		}
	}
}

 
