# Command Reference

## Reference description

`Command` is the base class for all Gommand commands. Override lifecycle methods to define behavior.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `requirements` | Array of subsystems this command needs. | `[movement_subsystem]` |
| `interruptible` | Whether scheduler can interrupt this command. | `true` |
| `initialize()` | Runs once when scheduled. | Reset local state |
| `execute(delta_time)` | Runs every frame while scheduled. | Move character |
| `physics_execute(delta_time)` | Runs every physics frame while scheduled. | Apply forces |
| `is_finished()` | Returns `true` when command should end. | `return elapsed > 1.0` |
| `end(interrupted)` | Runs on finish or cancel. | Stop motor |

## Methods

Use these core methods when creating custom commands.

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `get_requirements()` | Returns current required subsystems. | None | `var reqs = cmd.get_requirements()` |
| `add_requirement(subsystem)` | Adds one required subsystem. | Required: subsystem | `add_requirement(drive)` |
| `is_interruptible()` | Returns interrupt behavior. | None | `if cmd.is_interruptible():` |
| `set_interruptible(value)` | Sets interrupt behavior. | Required: bool | `set_interruptible(false)` |

## Full example usage

```gdscript
extends Node

class MoveForOneSecond:
	extends Command
	var elapsed := 0.0

	func _init(movement_subsystem):
		super._init([movement_subsystem], true)

	func initialize() -> void:
		elapsed = 0.0

	func execute(delta_time: float) -> void:
		elapsed += delta_time

	func physics_execute(delta_time: float) -> void:
		pass

	func is_finished() -> bool:
		return elapsed >= 1.0

	func end(interrupted: bool) -> void:
		print("done", interrupted)
```

---
