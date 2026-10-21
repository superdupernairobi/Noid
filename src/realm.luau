--!strict

const types = require("./types")

const CLIENT_SOURCES: { [types.ChangeSource]: boolean } = {
	sensor = true,
	driver = true,
	consumer = true,
	server = false,
	client = false,
}

const SERVER_SOURCES: { [types.ChangeSource]: boolean } = {
	sensor = true,
	driver = true,
	consumer = false,
	server = true,
	client = false,
}

local Realm = {}

--[=[
A change that is tagged client is rejected on a server machine so a client cannot add its own state.
]=]
function Realm.may_set(realm: types.Realm, source: types.ChangeSource): boolean
	if realm == "client" then
		return CLIENT_SOURCES[source]
	end

	return SERVER_SOURCES[source]
end

export type RealmClass = typeof(Realm)

return table.freeze(Realm :: any) :: RealmClass
