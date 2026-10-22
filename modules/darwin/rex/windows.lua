-- Rex sets this global when it loads the config
---@diagnostic disable-next-line: undefined-global
local rex = rex

-- Cmd+1-9 counts tabs across every session. Count only the current session's
-- windows, like tmux.
rex.action({
	name = "goto_session_window",
	title = "Go to Window in Session",
	args = { index = "integer" },
	run = function(ctx, args)
		local view = rex.session.view({})
		local window = view and view.windows[args.index]
		if window == nil then
			return
		end
		local select = { session_id = ctx.session_id, window_id = window.window_id }

		if ctx.server == nil then
			rex.client.queue("session.select", select)
			return
		end

		-- On a remote host, the app has to be asked through that host's server,
		-- where it has another client ID. Its label is this Mac's name.
		local name = rex.exec({ "/usr/sbin/scutil", "--get", "ComputerName" }).stdout:gsub("%s+$", "")
		local clients = rex.call("client.list")
		for _, client in ipairs(clients and clients.clients or {}) do
			if client.info and client.info.kind == "app" and client.info.label == name then
				rex.call("client.perform", {
					client_id = client.client_id,
					action = "session.select",
					args = select,
				})
				return
			end
		end
	end,
})

for i = 1, 9 do
	rex.bind("cmd+" .. i, "goto_session_window", { index = i })
end
