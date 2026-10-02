pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Workspace state from the niri event stream.
// See https://docs.rs/niri-ipc/latest/niri_ipc/enum.Event.html
Singleton {
	id: root

	property var workspaces: []

	function workspacesOn(output: string): var {
		return workspaces.filter(w => w.output === output).sort((a, b) => a.idx - b.idx)
	}

	function focusWorkspace(id: int): void {
		requests.send({ Action: { FocusWorkspace: { reference: { Id: id } } } })
	}

	// Copy of object with changes applied. QML's JS engine has no object spread.
	function updated(object: var, changes: var): var {
		return Object.assign({}, object, changes)
	}

	function handle(event: var): void {
		const [type, data] = Object.entries(event)[0]

		switch (type) {
		case "WorkspacesChanged":
			workspaces = data.workspaces
			break
		case "WorkspaceActivated": {
			const output = workspaces.find(w => w.id === data.id)?.output
			workspaces = workspaces.map(w => updated(w, {
				is_active: w.output === output ? w.id === data.id : w.is_active,
				is_focused: data.focused ? w.id === data.id : w.is_focused
			}))
			break
		}
		}
	}

	Socket {
		path: Quickshell.env("NIRI_SOCKET")
		connected: true

		onConnectedChanged: {
			if (!connected) return
			write('"EventStream"\n')
			flush()
		}

		parser: SplitParser {
			onRead: line => root.handle(JSON.parse(line))
		}
	}

	Socket {
		id: requests

		function send(request: var): void {
			write(`${JSON.stringify(request)}\n`)
			flush()
		}

		path: Quickshell.env("NIRI_SOCKET")
		connected: true

		parser: SplitParser {
			onRead: line => {
				const reply = JSON.parse(line)
				if (reply.Err) console.warn("niri request failed:", reply.Err)
			}
		}
	}
}
