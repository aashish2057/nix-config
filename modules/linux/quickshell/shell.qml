import Quickshell
import QtQuick
import Quickshell.Widgets
import Quickshell.Io

Variants {
	model: Quickshell.screens

	delegate: Component {
		PanelWindow {
			id: menuBar
			property string fontFamily: "Berkeley Mono"
			property int fontSize: 14
			property int iconSize: 16
			property color bg: "#0F111A"
			property color fg: "#A6ACCD"
			property var workspaces: []
			property int activeWorkspaceId: 1

			required property var modelData
            screen: modelData


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

			Socket {
				path: Quickshell.env("NIRI_SOCKET")
				connected: true
				onConnectedChanged: {
					write("\"EventStream\"\n")
					flush()
				}
				parser: SplitParser {
					onRead: message =>
					{
						var parsedMessage = JSON.parse(message)

						if (parsedMessage.WorkspacesChanged) {
							workspaces = parsedMessage.WorkspacesChanged.workspaces.sort((a, b) => a.idx - b.idx)
						}

						if (parsedMessage.WorkspaceActivated) {
							menuBar.activeWorkspaceId = parsedMessage.WorkspaceActivated.id
						}
					}
				}
				onError: error => console.log("socket error:", error)
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
						color: modelData.id === menuBar.activeWorkspaceId ? "#FFFFFF" : menuBar.fg
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
	}
}

