import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets

ShellRoot {
	id: root

	property bool menuOpen: true
	property var workspaces: []
	property int activeWorkspaceId: 1
	property var now: clock.date

	property string fontFamily: "Berkeley Mono"
	property int fontSize: 14
	property int iconSize: 16
	property color bg: "#0F111A"
	property color fg: "#A6ACCD"
	property string voxtypeState: "idle"

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	IpcHandler {
		target: "menuBar"

		function toggle(): void {
			root.menuOpen = !root.menuOpen
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
			onRead: message => {
				var parsedMessage = JSON.parse(message)

				if (parsedMessage.WorkspacesChanged) {
					root.workspaces = parsedMessage.WorkspacesChanged.workspaces.sort((a, b) => a.idx - b.idx)
				}

				if (parsedMessage.WorkspaceActivated) {
					root.activeWorkspaceId = parsedMessage.WorkspaceActivated.id
				}
			}
		}
		onError: error => console.log("socket error:", error)
	}

	Process {
		running: true
		command: ["voxtype", "status", "--follow", "--format", "json"]

		stdout: SplitParser {
			onRead: line => {
				const status = JSON.parse(line)
				root.voxtypeState = status.alt
			}
		}
	}

	Variants {
		model: Quickshell.screens

		delegate: Component {
			PanelWindow {
				id: menuBar

				required property var modelData

				screen: modelData
				color: "transparent"
				visible: root.menuOpen

				anchors {
					top: true
				}

				margins {
					top: 6
				}

				implicitHeight: 30
				implicitWidth: screen.width * 0.75

				Rectangle {
					anchors.fill: parent
					radius: 10
					color: root.bg
					clip: true

					IconImage {
						id: nixIcon
						source: Qt.resolvedUrl("./icons/nix.svg")
						implicitSize: root.iconSize

						anchors {
							left: parent.left
							leftMargin: 10
							verticalCenter: parent.verticalCenter
						}
					}

					Rectangle {
						radius: 10
						color: root.bg
						clip: true

						anchors {
							left: nixIcon.right
							leftMargin: 10
							verticalCenter: parent.verticalCenter
						}

						implicitWidth: workspaceRow.implicitWidth
						implicitHeight: workspaceRow.implicitHeight

						Row {
							id: workspaceRow
							spacing: 10
							Repeater {
								model: root.workspaces
								Item {
									implicitWidth: childrenRect.width
									implicitHeight: childrenRect.height

									Text {
										text: modelData.idx
										color: modelData.id === root.activeWorkspaceId ? "#FFFFFF" : root.fg
										font.pixelSize: root.fontSize
										font.family: root.fontFamily
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
						text: Qt.formatDateTime(root.now, "ddd, MMM dd, hh:mm AP")
						color: root.fg
						font.pixelSize: root.fontSize
						font.family: root.fontFamily
						font.weight: Font.Bold
					}

					Text {
						anchors {
							right: parent.right
							rightMargin: 10
							verticalCenter: parent.verticalCenter
						}

						text: {
							switch (root.voxtypeState) {
							case "recording":
								return "●"
							case "streaming":
								return "●"
							case "transcribing":
								return "◐"
							case "stopped":
								return "○"
							default:
								return "󰍬"
							}
						}

						color: {
							switch (root.voxtypeState) {
							case "recording":
							case "streaming":
								return "#FF5370"
							case "transcribing":
								return "#FFCB6B"
							default:
								return root.fg
							}
						}

						font.pixelSize: root.iconSize
						font.family: root.fontFamily
					}
				}
			}
		}
	}
}
