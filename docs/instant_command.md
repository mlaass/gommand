# InstantCommand Reference

## Reference description

`InstantCommand` runs an action once in `initialize()` and then immediately finishes.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `action_to_run` | Callable invoked once. | `func(): ammo -= 1` |
| `requirements` | Required subsystems. Optional. | `[weapon]` |
| finish rule | Always finishes right away. | `true` |

## Methods

Quick one-shot command creation.

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `InstantCommand.new(action, requirements)` | Creates one-shot action command. | Required: action callable | `InstantCommand.new(func(): print("Hi"))` |

## Full example usage

```gdscript
var command := InstantCommand.new(func():
	player_score += 100
	print("+100")
)

CommandScheduler.schedule(command)
```

---
