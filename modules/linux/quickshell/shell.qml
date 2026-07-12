import Quickshell
import QtQuick
import Quickshell.Widgets

PanelWindow {
	id: menuBar
	property string fontFamily: "Berkeley Mono"
	property int fontSize: 14
	property int iconSize: 16
	property color bg: "#0F111A"
	property color fg: "#A6ACCD"


	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: 30
	color: menuBar.bg

	IconImage {
		source: Qt.resolvedUrl("./icons/nix.svg")
		implicitSize: menuBar.iconSize

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
		color: menuBar.fg 
		font.pixelSize: menuBar.fontSize
		font.family: menuBar.fontFamily
	}
}
