--!strict

const types = require("./types")

const RULES: { types.Transition } = {
	{ from = "*", to = "Dead" },
	{ from = "*", to = "Frozen" },
	{ from = "Dead", to = "Idle" },
	{ from = "Frozen", to = "Idle" },

	{ from = "Idle", to = "Grounded" },
	{ from = "Grounded", to = "Idle" },
	{ from = "Grounded", to = "Airborne" },
	{ from = "Grounded", to = "Jumping" },
	{ from = "Grounded", to = "Climbing" },
	{ from = "Grounded", to = "Swimming" },
	{ from = "Grounded", to = "Seated" },
	{ from = "Grounded", to = "Flying" },
	{ from = "Grounded", to = "Falling" },

	{ from = "Jumping", to = "Airborne" },
	{ from = "Jumping", to = "Landed" },
	{ from = "Airborne", to = "Landed" },
	{ from = "Airborne", to = "Falling" },
	{ from = "Airborne", to = "Climbing" },
	{ from = "Airborne", to = "Swimming" },
	{ from = "Airborne", to = "Flying" },
	{ from = "Falling", to = "Landed" },

	{ from = "Landed", to = "Idle" },
	{ from = "Landed", to = "Grounded" },

	{ from = "Climbing", to = "Airborne" },
	{ from = "Climbing", to = "Grounded" },
	{ from = "Swimming", to = "Grounded" },
	{ from = "Swimming", to = "Airborne" },
	{ from = "Seated", to = "Grounded" },
	{ from = "Flying", to = "Airborne" },
	{ from = "Flying", to = "Grounded" },
}

local allowed: { [string]: boolean } = {}
for _, rule in RULES do
	allowed[rule.from .. ">" .. rule.to] = true
end

table.freeze(allowed)

local Transitions = {}

--[=[
A state can never transition to itself, so the rules table is checked before the exact pair. Anything can reach Dead or Frozen.
]=]
function Transitions.can(from: types.State, to: types.State): boolean
	if from == to then
		return false
	end

	if allowed["*>" .. to] then
		return true
	end

	return allowed[from .. ">" .. to] == true
end

function Transitions.rules(): { types.Transition }
	return RULES
end

export type TransitionsClass = typeof(Transitions)

return table.freeze(Transitions :: any) :: TransitionsClass
