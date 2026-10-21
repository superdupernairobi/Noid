--!strict

const types = require("./types")

export type Lifecycle = {
	add: (self: Lifecycle, connection: types.Disconnectable) -> types.Disconnectable,
	add_instance: (self: Lifecycle, instance: Instance) -> Instance,
	destroy_all: (self: Lifecycle) -> (),
	count: (self: Lifecycle) -> number,
}

local Lifecycle = {}

function Lifecycle.new(): Lifecycle
	local tracked: { types.Disconnectable } = {}

	local lifecycle: Lifecycle = {
		add = function(_self: Lifecycle, connection: types.Disconnectable): types.Disconnectable
			table.insert(tracked, connection)

			return connection
		end,

		add_instance = function(_self: Lifecycle, instance: Instance): Instance
			table.insert(tracked, instance :: any)

			return instance
		end,

		destroy_all = function(_self: Lifecycle)
			for index = #tracked, 1, -1 do
				local item: any = tracked[index]
				tracked[index] = nil

				if item.Destroy ~= nil then
					item:Destroy()
				elseif item.Disconnect ~= nil then
					item:Disconnect()
				end
			end
		end,

		count = function(_self: Lifecycle): number
			return #tracked
		end,
	}

	return lifecycle
end

return Lifecycle
