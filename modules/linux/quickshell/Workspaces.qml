pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Column {
	id: root

	required property string output

	spacing: Theme.padding

	Repeater {
		// Keyed by id so delegates survive updates. Each delegate looks up its live data.
		model: ScriptModel {
			values: Niri.workspacesOn(root.output).map(w => w.id)
		}

		Column {
			id: workspace

			required property int modelData
			readonly property var info: Niri.workspaces.find(w => w.id === modelData)

			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 6

			Text {
				anchors.horizontalCenter: parent.horizontalCenter
				text: workspace.info?.idx ?? ""
				color: workspace.info?.is_active ? Theme.highlight : Theme.foreground
				font.family: Theme.fontFamily
				font.pixelSize: Theme.fontSize

				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: Niri.focusWorkspace(workspace.modelData)
				}
			}

			Repeater {
				model: ScriptModel {
					values: Niri.windowsOn(workspace.modelData).map(w => w.id)
				}

				AppIcon {
					required property int modelData

					anchors.horizontalCenter: parent.horizontalCenter
					windowId: modelData
				}
			}
		}
	}
}
