import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

// Floats over windows and slides in and out.
PanelWindow {
	id: root

	required property ShellScreen modelData
	property bool open: true

	// 0 = hidden past the screen edge, 1 = fully shown.
	property real shown: open ? 1 : 0

	Behavior on shown {
		NumberAnimation {
			duration: Theme.slideDuration
			easing.type: Easing.OutCubic
		}
	}

	screen: modelData
	visible: shown > 0
	color: "transparent"

	anchors.top: true
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.namespace: "quickshell:bar"

	// Only the bar takes input, not the gap beside it.
	mask: Region { item: bar }

	implicitWidth: screen.width * 0.75
	implicitHeight: bar.height + Theme.screenGap

	Rectangle {
		id: bar

		y: -height + root.shown * (height + Theme.screenGap)
		width: parent.width
		height: 30
		radius: Theme.radius
		color: Theme.background

		IconImage {
			id: nixIcon

			anchors.left: parent.left
			anchors.leftMargin: Theme.padding
			anchors.verticalCenter: parent.verticalCenter
			source: Qt.resolvedUrl("icons/nix.svg")
			implicitSize: Theme.iconSize
		}

		Workspaces {
			anchors.left: nixIcon.right
			anchors.leftMargin: Theme.padding
			anchors.verticalCenter: parent.verticalCenter
			output: root.screen.name
		}

		Clock {
			anchors.centerIn: parent
		}
	}
}
