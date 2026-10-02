import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

PanelWindow {
	id: root

	required property ShellScreen modelData
	property bool open: true

	screen: modelData
	visible: open
	color: "transparent"

	anchors.top: true
	margins.top: Theme.screenGap
	WlrLayershell.namespace: "quickshell:bar"

	implicitWidth: screen.width * 0.75
	implicitHeight: 30

	Rectangle {
		anchors.fill: parent
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
