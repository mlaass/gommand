# ScheduleCommand Reference

## Reference description

`ScheduleCommand` schedules another command in `initialize()` and then immediately finishes.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `command_to_schedule` | Command sent to scheduler. | `RunCommand.new(...)` |
| scheduler dependency | Requires `CommandScheduler` singleton to exist. | `Engine.has_singleton("CommandScheduler")` |
| finish rule | Always finishes right away. | `true` |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `ScheduleCommand.new(command)` | Schedules command once, then ends. | Required: command | `ScheduleCommand.new(auto_aim)` |

## Full example usage

```gdscript
var child := PrintCommand.new("Scheduled by wrapper")
var wrapper := ScheduleCommand.new(child)

CommandScheduler.schedule(wrapper)
```

---
