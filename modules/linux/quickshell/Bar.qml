import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

// A pill on the right edge that floats over windows and slides in and out.
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

	anchors.right: true
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.namespace: "quickshell:bar"

	// Only the pill takes input, not the gap beside it.
	mask: Region { item: bar }

	implicitWidth: bar.width + Theme.screenGap
	implicitHeight: bar.height

	Rectangle {
		id: bar

		x: (1 - root.shown) * (width + Theme.screenGap)
		width: 40
		height: content.implicitHeight
		radius: Theme.radius
		color: Theme.background

		Column {
			id: content

			anchors.horizontalCenter: parent.horizontalCenter
			topPadding: Theme.padding
			bottomPadding: Theme.padding
			spacing: Theme.padding

			IconImage {
				anchors.horizontalCenter: parent.horizontalCenter
				source: Qt.resolvedUrl("icons/nix.svg")
				implicitSize: Theme.iconSize
			}

			Workspaces {
				anchors.horizontalCenter: parent.horizontalCenter
				output: root.screen.name
			}

			// Separates the workspaces from the date and time.
			Item {
				anchors.horizontalCenter: parent.horizontalCenter
				width: 20
				height: 25

				Rectangle {
					anchors.centerIn: parent
					width: parent.width
					height: 1
					color: Theme.foreground
					opacity: 0.3
				}
			}

			Clock {
				anchors.horizontalCenter: parent.horizontalCenter
			}
		}
	}
}
