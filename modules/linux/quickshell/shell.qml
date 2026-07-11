import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
	anchors.top: true
	anchors.left: true
	anchors.right: true
	implicitHeight: 30
	color: "#0F111A"

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
