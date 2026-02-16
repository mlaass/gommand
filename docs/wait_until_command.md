# WaitUntilCommand Reference

## Reference description

`WaitUntilCommand` waits until a predicate callable returns `true`.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `predicate` | Callable that returns a boolean. | `func(): return ammo > 0` |
| finish rule | Finishes when predicate is valid and returns `true`. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `WaitUntilCommand.new(predicate)` | Creates condition-based wait command. | Required: callable | `WaitUntilCommand.new(func(): return target_locked)` |

## Full example usage

```gdscript
var wait_for_lock := WaitUntilCommand.new(func():
	return target_locked
)

var command := SequentialCommandGroup.new([
	wait_for_lock,
	PrintCommand.new("Locked")
])

CommandScheduler.schedule(command)
```

---
