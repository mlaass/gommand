# SequentialCommandGroup Reference

## Reference description

`SequentialCommandGroup` runs child commands one by one in order.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `commands` | Ordered array of child commands. | `[open, wait, close]` |
| `interruptible` | Group interrupt setting. | `true` |
| execution model | Starts next command only after current one finishes. | N/A |
| finish rule | Finishes after the last command completes. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `SequentialCommandGroup.new(commands)` | Creates ordered command chain. | Required: array | `SequentialCommandGroup.new([lift, shoot, retreat])` |

## Full example usage

```gdscript
var open := PrintCommand.new("Open")
var wait := WaitCommand.new(0.5)
var close := PrintCommand.new("Close")

var command := SequentialCommandGroup.new([open, wait, close])
CommandScheduler.schedule(command)
```

---
