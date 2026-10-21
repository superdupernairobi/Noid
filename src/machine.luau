--!strict

const types = require("./types")
const transitions = require("./transitions")
const signal = require("./signal")

export type Machine = {
	State: (self: any) -> types.State,
	Change: (self: any, request: types.ChangeRequest) -> boolean,
	Changed: (self: any) -> any,
	Destroy: (self: any) -> (),
}

local Machine = {}

function Machine.new(initial: types.State): Machine
	local current: types.State = initial
	local changed: any = signal.new()

	local machine: Machine = {
		State = function(_self: Machine): types.State
			return current :: types.State
		end,

		Change = function(_self: Machine, request: types.ChangeRequest): boolean
			const target = request.state

			if not transitions.can(current, target :: types.State) then
				return false
			end

			const previous = current
			current = target :: types.State

			changed:Fire(previous, target)

			return true
		end,

		Changed = function(_self: Machine): any
			return changed
		end,

		Destroy = function(_self: Machine)
			changed:DisconnectAll()
		end,
	}

	return machine
end

return Machine
