pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Workspace and window state from the niri event stream.
// See https://docs.rs/niri-ipc/latest/niri_ipc/enum.Event.html
Singleton {
	id: root

	property var workspaces: []
	property var windows: []

	function workspacesOn(output: string): var {
		return workspaces.filter(w => w.output === output).sort((a, b) => a.idx - b.idx)
	}

	// Left to right by column, then top to bottom within a column.
	// Floating windows have no scrolling position, so they go last.
	function windowsOn(workspaceId: int): var {
		const position = w => w.layout.pos_in_scrolling_layout ?? [Infinity, Infinity]
		const compare = (a, b) => a === b ? 0 : a < b ? -1 : 1

		return windows
			.filter(w => w.workspace_id === workspaceId)
			.sort((a, b) => compare(position(a)[0], position(b)[0]) || compare(position(a)[1], position(b)[1]))
	}

	function focusWorkspace(id: int): void {
		requests.send({ Action: { FocusWorkspace: { reference: { Id: id } } } })
	}

	function focusWindow(id: int): void {
		requests.send({ Action: { FocusWindow: { id } } })
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
		case "WindowsChanged":
			windows = data.windows
			break
		case "WindowOpenedOrChanged": {
			const others = windows.filter(w => w.id !== data.window.id)
			windows = (data.window.is_focused ? others.map(w => updated(w, { is_focused: false })) : others).concat([data.window])
			break
		}
		case "WindowClosed":
			windows = windows.filter(w => w.id !== data.id)
			break
		case "WindowFocusChanged":
			windows = windows.map(w => updated(w, { is_focused: w.id === data.id }))
			break
		case "WindowLayoutsChanged": {
			const layouts = new Map(data.changes)
			windows = windows.map(w => layouts.has(w.id) ? updated(w, { layout: layouts.get(w.id) }) : w)
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
