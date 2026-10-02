pragma Singleton

import Quickshell
import QtQuick

Singleton {
	readonly property string fontFamily: "Berkeley Mono"
	readonly property int fontSize: 14
	readonly property int smallFontSize: 11
	readonly property int iconSize: 16

	readonly property color background: "#0F111A"
	readonly property color foreground: "#A6ACCD"
	readonly property color highlight: "#FFFFFF"

	readonly property int radius: 10
	readonly property int padding: 12
	readonly property int screenGap: 6
	readonly property int slideDuration: 200
}
