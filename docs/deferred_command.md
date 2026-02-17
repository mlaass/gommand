# DeferredCommand Reference

## Reference description

`DeferredCommand` creates its real inner command at runtime during `initialize()`.



## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `factory_callable` | Callable that returns a `Command`. | `func(): return build_attack_command()` |
| created command | Stored after factory call if result is a `Command`. | `RunCommand.new(...)` |
| finish rule | Finishes when created command finishes, or immediately if none is created. | N/A |

## Methods

Use for late-bound command creation.

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `DeferredCommand.new(factory)` | Defers command creation to schedule time. | Required: callable | `DeferredCommand.new(func(): return choose_command())` |

## Full example usage

```gdscript
var make_runtime_command := func() -> Command:
	if player_has_target:
		return PrintCommand.new("Attack")
	return PrintCommand.new("Search")

var command := DeferredCommand.new(make_runtime_command)
CommandScheduler.schedule(command)
```

---
