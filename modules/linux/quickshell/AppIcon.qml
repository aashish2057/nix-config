import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

IconImage {
	id: root

	required property int windowId
	readonly property var window: Niri.windows.find(w => w.id === windowId)

	source: AppIcons.forApp(window?.app_id ?? "")
	implicitSize: Theme.iconSize

	// The icons are white, so colorizing tints them to the theme color.
	layer.enabled: true
	layer.effect: MultiEffect {
		colorization: 1
		colorizationColor: root.window?.is_focused ? Theme.highlight : Theme.foreground
	}

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: Niri.focusWindow(root.windowId)
	}
}
