-- Rex sets this global when it loads the config
---@diagnostic disable-next-line: undefined-global
local rex = rex

local shell = "com.superlogical.terminal.shell"
local fish = "/etc/profiles/per-user/" .. os.getenv("USER") .. "/bin/fish"
-- The Rex server's PATH is only /usr/bin:/bin:/usr/sbin:/sbin
local nix = "/run/current-system/sw/bin/nix"
local projects_root = os.getenv("HOME") .. "/Dev"

local default_windows = {
	{ command = "nvim" },
	{},
}

local projects = {
	{ name = "nix-config", dir = "nix-config" },
}

-- Rex runs Lua 5.1, which has no table.unpack
local function window_command(project, window)
	local command = {}
	if project.dev_shell then
		command = { nix, "develop", "-c" }
	end
	table.insert(command, fish)
	if window.command ~= nil then
		-- fish runs -C commands without job control, so they share its process
		-- group and Rex shows the fish icon instead of the command's
		table.insert(command, "-C")
		table.insert(command, "status job-control full; " .. window.command .. "; status job-control interactive")
	end
	return command
end

local function project_windows(project)
	local dir = projects_root .. "/" .. project.dir
	local windows = {}
	for _, window in ipairs(project.windows or default_windows) do
		table.insert(windows, {
			layout = rex.layout.block({
				flavor = shell,
				options = { cwd = dir, command = window_command(project, window) },
			}),
		})
	end
	return windows
end

local function create_session(project)
	local session, err = rex.call("session.create", {
		label = project.name,
		initial_windows = project_windows(project),
	})
	if err ~= nil then
		error(err, 0)
	end
	return session.session_id, session.initial_windows[1].window_id
end

local shells = { fish = true, zsh = true, bash = true, sh = true }

-- True when the action's session is one window holding one idle shell, such as
-- the empty session Rex.app opens at launch
local function is_idle_shell_session()
	local view = rex.session.view({})
	if view == nil or #view.windows ~= 1 then
		return false
	end
	local layers = view.windows[1].layers
	if #layers ~= 1 or #layers[1].blocks ~= 1 then
		return false
	end

	local process = rex.block.call("com.superlogical.terminal", "process", {
		block_id = layers[1].blocks[1].block_id,
	})
	return process ~= nil and process.foreground ~= nil and shells[process.foreground.name] == true
end

-- Turn the action's session into the project's session
local function adopt_session(ctx, project)
	local old = rex.session.view({}).windows[1].window_id

	local _, err = rex.session.set_label({ label = project.name })
	if err ~= nil then
		error(err, 0)
	end

	local first_window
	for _, window in ipairs(project_windows(project)) do
		local created, window_err = rex.session.new_window({
			layout = window.layout,
			focus = false,
		})
		if window_err ~= nil then
			error(window_err, 0)
		end
		first_window = first_window or created.window_id
	end

	rex.session.focus_window({ window_id = first_window })
	rex.session.close_window({ window_id = old })
	return ctx.session_id, first_window
end

rex.action({
	name = "open_projects",
	title = "Open Project Sessions",
	run = function(ctx)
		local list, err = rex.call("session.list")
		if err ~= nil then
			error(err, 0)
		end

		local existing = {}
		local is_project = {}
		for _, project in ipairs(projects) do
			is_project[project.name] = true
		end
		local can_adopt = ctx.session_id ~= nil
		for _, session in ipairs(list.sessions or {}) do
			existing[session.label] = session.session_id
			if session.session_id == ctx.session_id and is_project[session.label] then
				can_adopt = false
			end
		end
		can_adopt = can_adopt and is_idle_shell_session()

		local created = {}
		local first_window = {}
		for _, project in ipairs(projects) do
			if existing[project.name] == nil then
				local session_id, window_id
				if can_adopt then
					session_id, window_id = adopt_session(ctx, project)
					can_adopt = false
				else
					session_id, window_id = create_session(project)
				end
				existing[project.name] = session_id
				first_window[project.name] = window_id
				table.insert(created, project.name)
			end
		end

		-- Switch the app to the first project. Only the app can do this, so skip it
		-- when the action runs from the CLI or is already there.
		local first = projects[1]
		local target = first and existing[first.name]
		if target ~= nil and target ~= ctx.session_id and (ctx.origin == "key" or ctx.origin == "palette") then
			rex.client.queue("session.select", {
				session_id = target,
				window_id = first_window[first.name],
			})
			-- The app drops a select for a window it hasn't seen yet. Starting a
			-- process before returning gives it time to catch up.
			rex.exec({ "sleep", "0" })
		end

		return { created = created }
	end,
})

rex.bind("cmd+shift+o", "open_projects")
