import Quickshell
import QtQuick
import Quickshell.Widgets
import Quickshell.Io

PanelWindow {
	id: menuBar
	property string fontFamily: "Berkeley Mono"
	property int fontSize: 14
	property int iconSize: 16
	property color bg: "#0F111A"
	property color fg: "#A6ACCD"
	property var workspaces: []


	anchors {
		top: true
		left: true
		right: true
	}

	implicitHeight: 30
	color: menuBar.bg

	IconImage {
		id: nixIcon
		source: Qt.resolvedUrl("./icons/nix.svg")
		implicitSize: menuBar.iconSize

		anchors {
			left: parent.left
			leftMargin: 10
			verticalCenter: parent.verticalCenter
		}
	}

	Process {
		id: niri
		running: true
		command: [ "niri", "msg", "--json", "workspaces" ]
		stdout: StdioCollector {
			onStreamFinished: {
				workspaces = JSON.parse(this.text).sort((a, b) => a.idx - b.idx)
			}
		}
	}

    Timer {
      interval: 10
      running: true
      repeat: true

      onTriggered: niri.running = true
    }

	Row {
		anchors {
			left: nixIcon.right
			leftMargin: 10
			verticalCenter: parent.verticalCenter
		}
		spacing: 10
		Repeater {
			model: menuBar.workspaces
			Text {
				text: modelData.idx
				color: modelData.is_active ? "#FFFFFF" : menuBar.fg
				font.pixelSize: menuBar.fontSize
				font.family: menuBar.fontFamily
			}
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
