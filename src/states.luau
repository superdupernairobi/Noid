--!strict

const types = require("./types")

const NAMES: { types.State } = {
	"Idle",
	"Grounded",
	"Airborne",
	"Jumping",
	"Landed",
	"Falling",
	"Climbing",
	"Swimming",
	"Seated",
	"Flying",
	"Dead",
	"Frozen",
}

const INFO: { [types.State]: types.StateInfo } = {
	Idle = { grounded = true, airborne = false, manual = true, terminal = false, enum_name = "Running" },
	Grounded = { grounded = true, airborne = false, manual = true, terminal = false, enum_name = "Running" },
	Airborne = { grounded = false, airborne = true, manual = false, terminal = false, enum_name = "Freefall" },
	Jumping = { grounded = false, airborne = true, manual = true, terminal = false, enum_name = "Jumping" },
	Landed = { grounded = true, airborne = false, manual = false, terminal = false, enum_name = "Landed" },
	Falling = { grounded = false, airborne = true, manual = false, terminal = false, enum_name = "FallingDown" },
	Climbing = { grounded = false, airborne = false, manual = false, terminal = false, enum_name = "Climbing" },
	Swimming = { grounded = false, airborne = false, manual = false, terminal = false, enum_name = "Swimming" },
	Seated = { grounded = true, airborne = false, manual = true, terminal = false, enum_name = "Seated" },
	Flying = { grounded = false, airborne = false, manual = true, terminal = false, enum_name = "Flying" },
	Dead = { grounded = false, airborne = false, manual = true, terminal = true, enum_name = "Dead" },
	Frozen = { grounded = false, airborne = false, manual = true, terminal = true, enum_name = nil },
}

const ALIASES: { [string]: types.State } = {
	Running = "Grounded",
	Freefall = "Airborne",
	Ragdoll = "Falling",
	GettingUp = "Landed",
	Physics = "Frozen",
}

type Alias = "Running" | "Freefall" | "Ragdoll" | "GettingUp" | "Physics"

local by_name: { [string]: boolean } = {}
for _, name in NAMES do
	by_name[name] = true
end

table.freeze(by_name)

local States = {}

function States.resolve(name: types.State | Alias): types.State?
	if by_name[name] then
		return name :: types.State
	end

	return ALIASES[name]
end

function States.info(state: types.State): types.StateInfo
	return INFO[state]
end

function States.names(): { types.State }
	return NAMES
end

export type StatesClass = typeof(States)

return table.freeze(States :: any) :: StatesClass
