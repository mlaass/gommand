# ParallelRaceGroup Reference

## Reference description

`ParallelRaceGroup` runs multiple commands in parallel and ends as soon as any child command finishes.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `commands` | Array of child commands. | `[wait_short, run_loop]` |
| `interruptible` | Group interrupt setting. | `true` |
| finish rule | Finishes when at least one child is finished. | N/A |
| end behavior | Ends all unfinished children when group ends. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `ParallelRaceGroup.new(commands)` | Creates first-to-finish parallel group. | Required: array | `ParallelRaceGroup.new([wait, move])` |

## Full example usage

```gdscript
var timeout := WaitCommand.new(1.5)
var wait_for_lock := WaitUntilCommand.new(func(): return target_locked)

var command := ParallelRaceGroup.new([timeout, wait_for_lock])
CommandScheduler.schedule(command)
```

---
