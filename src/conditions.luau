--!strict

local types = require("./types")

export type Conditions = {
	grounded: boolean?,
	swimming: boolean?,
	climbing: boolean?,
	seated: boolean?,
	dead: boolean?,
}

local Conditions = {}

-- Every param is optional and nil means not known, not false, so a field you leave out just goes through to the next check, priority order is: Dead, Seated, Swimming, Climbing, Grounded, Airborne
function Conditions.resolve(conditions: Conditions): types.State?
	if conditions.dead then
		return "Dead"
	end
	if conditions.seated then
		return "Seated"
	end
	if conditions.swimming then
		return "Swimming"
	end
	if conditions.climbing then
		return "Climbing"
	end
	if conditions.grounded == true then
		return "Grounded"
	end
	if conditions.grounded == false then
		return "Airborne"
	end
	return nil
end

export type ConditionClass = typeof(Conditions)

return table.freeze(Conditions :: any) :: ConditionClass
