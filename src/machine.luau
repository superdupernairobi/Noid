--!strict

const types = require("./types")
const signal = require("./signal")
const realm = require("./realm")

export type Machine = {
	State: (self: any) -> types.State,
	Change: (self: any, request: types.ChangeRequest) -> boolean,
	Changed: (self: any) -> signal.Signal<types.StateChanged>,
	Destroy: (self: any) -> (),
}

local Machine = {}

function Machine.new(initial: types.State, machine_realm: types.Realm): Machine
	local current: types.State = initial
	local own_realm: types.Realm = machine_realm
	local changed: any = signal.new()

	local machine: Machine = {
		State = function(_self: Machine): types.State
			return current :: types.State
		end,

		Change = function(_self: Machine, request: types.ChangeRequest): boolean
			const target = request.state

			if not realm.may_set(own_realm, request.source) then
				return false
			end

			const previous = current
			current = target :: types.State

			changed:Fire(previous, target)

			return true
		end,

		Changed = function(_self: Machine): signal.Signal<types.StateChanged>
			return changed
		end,

		Destroy = function(_self: Machine)
			changed:DisconnectAll()
		end,
	}

	return machine
end

return Machine
