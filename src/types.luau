--!strict

export type Realm = "server" | "client" | "shared"

export type State =
	"Idle"
	| "Grounded"
	| "Airborne"
	| "Jumping"
	| "Landed"
	| "Falling"
	| "Climbing"
	| "Swimming"
	| "Seated"
	| "Flying"
	| "Dead"
	| "Frozen"

export type StateInfo = {
	grounded: boolean,
	airborne: boolean,
	manual: boolean,
	terminal: boolean,
	enum_name: string?,
}

export type Transition = {
	from: State | "*",
	to: State,
}

export type ChangeSource = "sensor" | "driver" | "consumer" | "server" | "client"

export type ChangeRequest = {
	state: State,
	source: ChangeSource,
}

export type StateChanged = (old: State, new: State) -> ()

export type Disconnectable = {
	Disconnect: (() -> ())?,
	Destroy: (() -> ())?,
}

return {}
