# ParallelDeadlineGroup Reference

## Reference description

`ParallelDeadlineGroup` runs multiple commands in parallel, but the deadline command controls when the group ends.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `deadline_command` | Main command that decides finish timing. | `WaitCommand.new(2.0)` |
| `commands` | Other commands that run alongside deadline. | `[spinup, feed]` |
| finish rule | Finishes when deadline command finishes. | N/A |
| end behavior | Ends any still-running children when group ends. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `ParallelDeadlineGroup.new(deadline, commands)` | Creates deadline-based parallel group. | Required: deadline command | `ParallelDeadlineGroup.new(wait, [run_a, run_b])` |

## Full example usage

```gdscript
var deadline := WaitCommand.new(3.0)
var spin := RunCommand.new(func(dt): rotor_speed += dt)
var feed := RunCommand.new(func(dt): ammo_feed_time += dt)

var command := ParallelDeadlineGroup.new(deadline, [spin, feed])
CommandScheduler.schedule(command)
```

---
