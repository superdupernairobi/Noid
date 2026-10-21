--!strict

--[=[
A state machine like the Humanoid's, for custom character controllers.

Noid does not move anything or cast anything, it decides what state a character is in and tells you when that changes. Physics, raycast and replication stay with you.

```lua
local Noid = require(game:GetService("ReplicatedStorage").Packages.Noid)

local machine = Noid.Machine.new("Idle", "client")
local desired = Noid.Conditions.resolve({ grounded = true })

if desired then
    machine:Change({ state = desired, source = "sensor" })
end
```
]=]

const types = require("@self/types")
const conditions = require("@self/conditions")
const lifecycle = require("@self/lifecycle")
const machine = require("@self/machine")
const realm = require("@self/realm")
const signal = require("@self/signal")
const states = require("@self/states")
const transitions = require("@self/transitions")

export type State = types.State
export type StateInfo = types.StateInfo
export type ChangeSource = types.ChangeSource
export type ChangeRequest = types.ChangeRequest
export type StateChanged = types.StateChanged
export type Realm = types.Realm
export type Connection = signal.Connection
export type Conditions = conditions.Conditions
export type Machine = machine.Machine
export type Lifecycle = lifecycle.Lifecycle

const Noid = {
	Conditions = conditions,
	Lifecycle = lifecycle,
	Machine = machine,
	Realm = realm,
	Signal = signal,
	States = states,
	Transitions = transitions,
}

return table.freeze(Noid)
