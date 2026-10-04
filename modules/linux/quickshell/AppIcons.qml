pragma Singleton

import Quickshell

// Monochrome app logos from https://github.com/kvndrsslr/sketchybar-app-font (CC0),
// https://github.com/simple-icons/simple-icons (CC0), or from the app's own brand kit,
// with every fill set to white.
Singleton {
	// niri app_id -> file name in icons/apps
	readonly property var names: ({
		"com.mitchellh.ghostty": "ghostty",
		"com.t3tools.T3Code": "t3_code",
		"helium": "helium",
		"md.Obsidian": "obsidian",
		"steam": "steam"
	})

	function forApp(appId: string): url {
		return Qt.resolvedUrl(`icons/apps/${names[appId] ?? "default"}.svg`)
	}
}
