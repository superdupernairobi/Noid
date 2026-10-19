--!strict

export type Connection = {
	Disconnect: (self: Connection) -> (),
	Connected: (self: Connection) -> boolean,
}

export type Handler<T...> = (T...) -> ()

export type Signal<T...> = {
	Fire: (self: Signal<T...>, T...) -> (),
	Connect: (self: Signal<T...>, Handler<T...>) -> Connection,
	DisconnectAll: (self: Signal<T...>) -> (),
	Count: (self: Signal<T...>) -> number,
}

type Node = {
	handler: Handler<any>,
	next: Node?,
	connection: Connection,
}

const function new_connection(): Connection
	local connected = true

	return {
		Disconnect = function(self: Connection)
			connected = false
		end,
		Connected = function(self: Connection): boolean
			return connected
		end,
	}
end

local Signal = {}

function Signal.new(): Signal<any>
	local head: Node? = nil

	local signal: Signal<any> = {
		Connect = function(self: any, handler: Handler<any>): Connection
			local connection = new_connection()

			head = {
				handler = handler,
				next = head,
				connection = connection,
			}

			return connection
		end,

		Fire = function(self: any, ...: any)
			local node = head

			while node ~= nil do
				if node.connection:Connected() then
					node.handler(...)
				end

				node = node.next
			end
		end,

		DisconnectAll = function(self: any)
			head = nil
		end,

		Count = function(self: any): number
			local total = 0
			local node = head

			while node ~= nil do
				if node.connection:Connected() then
					total += 1
				end

				node = node.next
			end

			return total
		end,
	}

	return signal
end

return Signal
