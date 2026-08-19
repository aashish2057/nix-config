import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets

PanelWindow {
	property bool menuOpen: true
	property var workspaces: []
	property int activeWorkspaceId: 1

	property string fontFamily: "Berkeley Mono"
	property int fontSize: 14
	property int iconSize: 16
	property color bg: "#0F111A"
	property color fg: "#A6ACCD"

	required property var modelData
	screen: modelData

	id: menuBar
	color: "transparent"
	visible: menuOpen

	anchors {
		top: true
	}

	margins {
		top: 6
	}

	Rectangle {
		anchors.fill: parent
		radius: 10
		color: menuBar.bg
		clip: true

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

		Rectangle {
			radius: 10
			color: menuBar.bg
			clip: true

			anchors {
				left: nixIcon.right
				leftMargin: 10
				verticalCenter: parent.verticalCenter
			}

			implicitWidth: childrenRect.width
			implicitHeight: childrenRect.height

			Row {
				anchors {
					left: nixIcon.right
					leftMargin: 10
					verticalCenter: parent.verticalCenter
				}
				spacing: 10
				Repeater {
					model: menuBar.workspaces
					Item {
						implicitWidth: childrenRect.width
						implicitHeight: childrenRect.height

						Text {
							text: modelData.idx
							color: modelData.id === menuBar.activeWorkspaceId ? "#FFFFFF" : menuBar.fg
							font.pixelSize: menuBar.fontSize
							font.family: menuBar.fontFamily
						}

						MouseArea {
							anchors.fill: parent
							cursorShape: Qt.PointingHandCursor
							onClicked: Quickshell.execDetached([
								"niri",
								"msg",
								"action",
								"focus-workspace",
								String(modelData.idx)
							])
						}
					}
				}
			}
		}

		Text {
			anchors.centerIn: parent
			text: Qt.formatDateTime(clock.date, "hh:mm AP")
			color: menuBar.fg
			font.pixelSize: menuBar.fontSize
			font.family: menuBar.fontFamily
			font.weight: Font.Bold
		}
	}

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	implicitHeight: 30
	implicitWidth: screen.width * 0.75

	IpcHandler {
		target: "menuBar"

		function toggle(): void {
			menuBar.menuOpen = !menuBar.menuOpen
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
}

 
