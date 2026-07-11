import Quickshell
import QtQuick
import Quickshell.Widgets

PanelWindow {
	anchors {
		top: true
		left: true
		right: true
	}
	implicitHeight: 30
	color: "#0F111A"

	IconImage {
		source: Qt.resolvedUrl("./icons/nix.svg")
		implicitSize: 16

		anchors {
			left: parent.left
			leftMargin: 10
			verticalCenter: parent.verticalCenter
		}
	}

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	Text {
		anchors.centerIn: parent
		text: Qt.formatDateTime(clock.date, "ddd, MMM dd, hh:mm AP")
		color: "#A6ACCD"
		font.pixelSize: 14
	}
}
