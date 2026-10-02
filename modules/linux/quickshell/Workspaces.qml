pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Row {
	id: root

	required property string output

	spacing: Theme.padding

	Repeater {
		// Keyed by id so delegates survive updates. Each delegate looks up its live data.
		model: ScriptModel {
			values: Niri.workspacesOn(root.output).map(w => w.id)
		}

		Text {
			id: workspace

			required property int modelData
			readonly property var info: Niri.workspaces.find(w => w.id === modelData)

			text: info?.idx ?? ""
			color: info?.is_active ? Theme.highlight : Theme.foreground
			font.family: Theme.fontFamily
			font.pixelSize: Theme.fontSize

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: Niri.focusWorkspace(workspace.modelData)
			}
		}
	}
}
