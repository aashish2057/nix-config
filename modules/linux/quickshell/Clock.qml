import Quickshell
import QtQuick

Column {
	id: root

	// Format with AP so Qt uses 12-hour time.
	readonly property var time: Qt.formatDateTime(clock.date, "hh mm AP").split(" ")

	component Label: Text {
		anchors.horizontalCenter: parent.horizontalCenter
		color: Theme.foreground
		font.family: Theme.fontFamily
		font.pixelSize: Theme.smallFontSize
	}

	component TimeLabel: Label {
		color: Theme.highlight
		font.pixelSize: Theme.fontSize
		font.weight: Font.Bold
	}

	spacing: 8

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		Label { text: Qt.formatDateTime(clock.date, "ddd") }
		Label { text: Qt.formatDateTime(clock.date, "dd") }
	}

	Column {
		anchors.horizontalCenter: parent.horizontalCenter

		TimeLabel { text: root.time[0] }
		TimeLabel { text: root.time[1] }
		Label { text: root.time[2] }
	}
}
