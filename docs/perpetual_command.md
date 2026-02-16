# PerpetualCommand Reference

## Reference description

`PerpetualCommand` wraps another command and never finishes on its own.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `inner_command` | Wrapped command. | `RunCommand.new(...)` |
| interruptible | Uses wrapped command interruptibility. | mirrors inner command |
| finish rule | Always returns `false`. | Never auto-finishes |
| end behavior | If inner command is not finished, calls `inner.end(interrupted)`. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `PerpetualCommand.new(inner)` | Creates never-ending wrapper around `inner`. | Required: command | `PerpetualCommand.new(track_target)` |

## Full example usage

```gdscript
var track_target := RunCommand.new(func(dt):
	look_at(enemy.global_position)
)

var command := PerpetualCommand.new(track_target)
CommandScheduler.schedule(command)
```

---
