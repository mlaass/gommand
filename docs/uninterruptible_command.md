# UninterruptibleCommand Reference

## Reference description

`UninterruptibleCommand` wraps another command and forces interruptibility to `false`.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `inner_command` | Wrapped command. | `SequentialCommandGroup.new([...])` |
| interruptible | Always `false` on wrapper. | cannot be interrupted by scheduler |
| finish rule | Mirrors wrapped command `is_finished()`. | N/A |
| end behavior | Forwards `end(interrupted)` if inner is still running. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `UninterruptibleCommand.new(inner)` | Creates non-interruptible wrapper. | Required: command | `UninterruptibleCommand.new(critical_action)` |

## Full example usage

```gdscript
var critical_sequence := SequentialCommandGroup.new([
	PrintCommand.new("Start save"),
	WaitCommand.new(1.0),
	PrintCommand.new("Save done")
])

var command := UninterruptibleCommand.new(critical_sequence)
CommandScheduler.schedule(command)
```

---
