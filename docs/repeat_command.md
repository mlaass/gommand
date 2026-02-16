# RepeatCommand Reference

## Reference description

`RepeatCommand` runs an inner command repeatedly for a fixed count, or forever when count is less than or equal to zero.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `inner_command` | Command to restart each cycle. | `PrintCommand.new("tick")` |
| `times` | Number of repetitions. `<= 0` means infinite repeats. | `3` |
| finish rule | Finishes when `count >= times` for positive `times`. | N/A |
| restart behavior | Re-schedules and re-initializes inner command each completed cycle. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `RepeatCommand.new(inner, times)` | Creates repeat wrapper. | Required: inner command. Optional: times. | `RepeatCommand.new(fire_once, 5)` |

## Full example usage

```gdscript
var ping := PrintCommand.new("tick")
var command := RepeatCommand.new(ping, 3)

CommandScheduler.schedule(command)
```

---
