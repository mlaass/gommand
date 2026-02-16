# ParallelCommandGroup Reference

## Reference description

`ParallelCommandGroup` runs multiple commands at the same time and finishes when all of them finish.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `commands` | Array of child commands. | `[cmd_a, cmd_b]` |
| `interruptible` | Group interrupt setting. | `true` |
| finish rule | Finishes when every child is finished. | N/A |
| interruption behavior | If interrupted, unfinished children receive `end(true)`. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `ParallelCommandGroup.new(commands)` | Creates an all-must-finish parallel group. | Required: array | `ParallelCommandGroup.new([drive, aim])` |

## Full example usage

```gdscript
var spinup := WaitCommand.new(1.0)
var aim := WaitUntilCommand.new(func(): return target_locked)

var command := ParallelCommandGroup.new([spinup, aim])
CommandScheduler.schedule(command)
```

---
