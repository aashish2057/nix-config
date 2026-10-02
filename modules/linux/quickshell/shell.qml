import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
	id: root

	property bool barOpen: true

	IpcHandler {
		target: "menuBar"

		function toggle(): void {
			root.barOpen = !root.barOpen
		}
	}

	Variants {
		model: Quickshell.screens

		Bar {
			open: root.barOpen
		}
	}
}
