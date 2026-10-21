--!strict

const Noid = require("@game/ReplicatedStorage/Noid")

const RunService = game:GetService("RunService")
const UserInputService = game:GetService("UserInputService")

const ROOT = workspace:WaitForChild("Root") :: BasePart

const SPEED = 18
const GRAVITY = 60
const JUMP = 26
const SKIN = 0.02

const COLORS: { [string]: Color3 } = {
    Grounded = Color3.fromRGB(110, 200, 120),
    Airborne = Color3.fromRGB(200, 90, 90),
    Jumping = Color3.fromRGB(230, 180, 80),
}

const half_height = ROOT.Size.Y / 2

local velocity_y = 0
local grounded = false
local root_cframe = CFrame.new(ROOT.Position)

local machine = Noid.Machine.new("Idle", "client")

local ray_params = RaycastParams.new()
ray_params.FilterType = Enum.RaycastFilterType.Exclude
ray_params.FilterDescendantsInstances = { ROOT }
ray_params.RespectCanCollide = true

machine:Changed():Connect(function(old, new)
    local color = COLORS[new]
    if color then
        ROOT.Color = color
    end
    print(`{old} to {new}`)
end)

const function key_down(key: Enum.KeyCode): boolean
    return UserInputService:IsKeyDown(key)
end

const function move_intent(): Vector2
    local x = 0
    local z = 0

    if key_down(Enum.KeyCode.D) then
        x += 1
    end
    if key_down(Enum.KeyCode.A) then
        x -= 1
    end
    if key_down(Enum.KeyCode.W) then
        z -= 1
    end
    if key_down(Enum.KeyCode.S) then
        z += 1
    end

    return Vector2.new(x, z)
end

const function probe_ground(origin: Vector3): boolean
    const from = Vector3.new(origin.X, origin.Y - half_height + 0.05, origin.Z)
    const result = workspace:Raycast(from, Vector3.new(0, -(SKIN + 0.6), 0), ray_params)
    return result ~= nil
end

local space_was_down = false

const function step(dt: number)
    const intent = move_intent()

    if intent.Magnitude > 0 then
        const direction = Vector3.new(intent.X, 0, intent.Y).Unit
        const distance = SPEED * dt

        const wall_from = Vector3.new(
            root_cframe.Position.X,
            root_cframe.Position.Y - half_height * 0.5,
            root_cframe.Position.Z
        )
        const wall = workspace:Raycast(
            wall_from,
            direction * (distance + ROOT.Size.Z / 2),
            ray_params
        )
        const allowed = if wall and math.abs(wall.Normal.Y) < 0.5 then
            wall.Distance - ROOT.Size.Z / 2 - SKIN
        else
            distance
        root_cframe = root_cframe + direction * math.max(allowed, 0)
    end

    const prior_grounded = grounded

    local velocity_y_local = velocity_y
    const space_down = key_down(Enum.KeyCode.Space)
    if prior_grounded then
        velocity_y_local = 0
        if space_down and not space_was_down then
            velocity_y_local = JUMP
            grounded = false
        end
    else
        velocity_y_local -= GRAVITY * dt
    end
    
    local landed_y = root_cframe.Position.Y + velocity_y_local * dt

    if velocity_y_local <= 0 then
        const from = Vector3.new(
            root_cframe.Position.X,
            landed_y + half_height,
            root_cframe.Position.Z
        )
        const drop = half_height * 2 + SKIN + 0.6
        const floor = workspace:Raycast(from, Vector3.new(0, -drop, 0), ray_params)

        if floor then
            const target_y = floor.Position.Y + half_height + SKIN
            const remaining = landed_y - target_y

            if velocity_y_local < 0 and remaining <= 0 then
                landed_y = target_y
                velocity_y_local = 0
            elseif velocity_y_local <= 0 and remaining <= 0.1 then
                landed_y = target_y
                velocity_y_local = 0
            end
        end
    end

    root_cframe = CFrame.new(root_cframe.Position.X, landed_y, root_cframe.Position.Z)

    ROOT.CFrame = root_cframe
    velocity_y = velocity_y_local

    if velocity_y_local <= 0 then
        grounded = probe_ground(root_cframe.Position)
    end
    space_was_down = space_down

    local desired = Noid.Conditions.resolve({ grounded = grounded }) :: any
    if desired then
        machine:Change({ state = desired, source = "sensor" })
    end
    if velocity_y > 0 then
        machine:Change({ state = "Jumping", source = "consumer" })
    end
end

const camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

RunService.RenderStepped:Connect(function(dt)
    step(math.min(dt, 1/20))

    camera.CFrame = CFrame.new(
        root_cframe.Position + Vector3.new(0, 8, 26)
    ) * CFrame.Angles(math.rad(-15), 0, 0)
end)