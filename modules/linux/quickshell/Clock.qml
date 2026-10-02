import Quickshell
import QtQuick

Text {
	text: Qt.formatDateTime(clock.date, "ddd, MMM dd, hh:mm AP")
	color: Theme.foreground
	font.family: Theme.fontFamily
	font.pixelSize: Theme.fontSize
	font.weight: Font.Bold

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}
}
