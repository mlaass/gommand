# WaitCommand Reference

## Reference description

`WaitCommand` waits for a fixed duration in seconds and then finishes.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `duration_seconds` | Wait length. Values below `0` clamp to `0`. | `1.5` |
| internal timer | Uses `Time.get_ticks_msec()` to track elapsed time. | N/A |
| finish rule | Finishes when elapsed time reaches duration. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `WaitCommand.new(duration_seconds)` | Creates duration-based wait command. | Required: float duration | `WaitCommand.new(0.25)` |

## Full example usage

```gdscript
var command := SequentialCommandGroup.new([
	PrintCommand.new("Charging"),
	WaitCommand.new(2.0),
	PrintCommand.new("Fire")
])

CommandScheduler.schedule(command)
```

---
