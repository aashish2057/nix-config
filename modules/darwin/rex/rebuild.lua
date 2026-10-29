-- `rex do rebuild` runs the action in the server, where rex.servers() is empty.
-- From a terminal, run this file as a script: rex do ~/.config/rex/rebuild.lua

-- Rex sets this global when it loads the config
---@diagnostic disable-next-line: undefined-global
local rex = rex

-- On success the session closes itself. On failure it reports why and leaves a
-- shell in the repo.
local script = [[
# Without this, fish stays the foreground program and Rex shows its icon.
status job-control full

# https://www.superlogical.com/rex/docs/build/program-status
# state can carry extra pairs, such as blocked:kind=auth.
function report --argument-names state msg
  printf '\e]7501;state=%s:app=nix-rebuild:msg=%s\e\\' $state (printf %s $msg | base64 | tr -d '\n')
end

function fail --argument-names msg
  report error $msg
  echo (set_color red)$msg(set_color normal)
  exec fish
end

set nh nh (test (uname) = Darwin && echo darwin || echo os)

cd ~/Dev/nix-config; or fail "No nix-config checkout"

report working "Updating nix-config"
jj git fetch; or fail "Fetch failed"
jj restack; or fail "Restack failed"
test -z "$(jj log -r 'conflicts() & @' --no-graph -T change_id)"; or fail "Conflicts after restack"

report working "Building"
$nh build .; or fail "Build failed"

if not sudo -nv 2>/dev/null
  report blocked:kind=auth "Password needed to switch"
  sudo -v; or fail "sudo failed"
end

report working "Switching"
$nh switch --show-activation-logs .; or fail "Switch failed"

$REX_BIN_DIR/rex kill $REX_SESSION
]]

local windows = {
	{
		layout = rex.layout.block({
			flavor = "com.superlogical.terminal.shell",
			options = {
				command = { "fish", "-c", script },
				exit = { on_completion = false },
			},
		}),
	},
}

local function hostname()
	local r = assert(rex.exec({ "hostname", "-s" }))
	assert(r.ok, r.stderr)
	return (r.stdout:gsub("%s+$", ""))
end

-- Every host Rex can reach, keyed by label. `current` is the host running this.
local function hosts(current)
	local ret = { [current] = rex }
	for _, name in ipairs(rex.servers()) do
		if name ~= current then
			ret[name] = rex.server(name)
		end
	end
	return ret
end

local function rebuild(ctx)
	local started = {}
	for name, host in pairs(hosts(ctx and ctx.server or hostname())) do
		local label = name .. "-rebuild"
		local _, err = host.call("session.create", { label = label, initial_windows = windows })
		started[name] = { label = label, error = err }
	end
	return started
end

-- rex.args is only set when this runs as a script.
if rex.args then
	return rebuild()
end

rex.action({ name = "rebuild", title = "Rebuild All Hosts", run = rebuild })
