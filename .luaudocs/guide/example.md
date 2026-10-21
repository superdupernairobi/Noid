# Example

The example is a construct, not a controller. It uses an anchored part moved by `CFrame` from a single `RenderStepped` loop, one Y axis raycast, and no collision response. That is the smallest thing that can produce a grounded state, I chose it so the state machine is the only interesting part.

Please do not actually use this "character controller" example. A real controller needs a collide and slide, step handling and its own input and camera. Noid takes none of that on, it just decides what state a character is in and tells you when it changes.

## What does it show
- `Conditions.resolve` turning a grounded boolean into a state
- `Machine.Change` refusing a transition the rulee table does not contain
- `Changed` driving a reaction, but here we use a colour

## What it does not show

Physics, replicating, input handling, or animation. Every one of those is your jobs and the four lines that call Noid are th esame regardless of how you do them.

## The four lines

```luau
local desired = Noid.Conditions.resolve({ grounded = grounded })
if desired then
    machine:Change({ state = desired, source = "sensor" })
end
```

## The full source
[`dev/root.client.luau`](https://github.com/superdupernairobi/Noid/blob/main/dev/root.client.luau)