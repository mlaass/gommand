# RunCommand Reference

## Reference description

`RunCommand` calls a runnable callable every update and never finishes by itself.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `runnable_callable` | Callable receiving `delta_time`. | `func(dt): velocity += accel * dt` |
| `requirements` | Required subsystems. Optional. | `[movement]` |
| `interruptible` | Whether scheduler may interrupt this command. | `true` |
| finish rule | Always returns `false`. | Runs until canceled |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `RunCommand.new(runnable, requirements)` | Creates continuous run command. | Required: callable | `RunCommand.new(func(dt): move(dt), [drive])` |

## Full example usage

```gdscript
var command := RunCommand.new(func(dt):
	player.position.x += speed * dt
)

CommandScheduler.schedule(command)
```

---
