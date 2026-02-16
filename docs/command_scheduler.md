# CommandScheduler Reference

## Reference description

`CommandScheduler` is the runtime coordinator that schedules, executes, cancels, and conflict-resolves commands.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `_active_commands` | Currently running commands. | tracked automatically |
| `_subsystem_usage` | Maps subsystem to occupying command. | one command per subsystem |
| `_subsystems` | Registered subsystems. | from `Subsystem._enter_tree()` |
| `_action_triggers` | Registered action triggers. | from `ActionTrigger.build()` |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `schedule(command)` | Attempts to schedule command, canceling interruptible conflicts. Returns success. | Required: `Command` | `CommandScheduler.schedule(aim_cmd)` |
| `cancel(command)` | Cancels one command if active. | Required: `Command` | `CommandScheduler.cancel(aim_cmd)` |
| `cancel_all()` | Cancels all active commands. | None | `CommandScheduler.cancel_all()` |
| `is_scheduled(command)` | Returns whether command is currently active. | Required: `Command` | `if CommandScheduler.is_scheduled(cmd):` |
| `register_subsystem(subsystem)` | Registers a subsystem instance. | Required: `Subsystem` | auto from `_enter_tree()` |
| `unregister_subsystem(subsystem)` | Unregisters a subsystem instance. | Required: `Subsystem` | auto from `_exit_tree()` |
| `register_action_trigger(action_trigger)` | Registers an action trigger. | Required: `ActionTrigger` | auto in trigger init |
| `unregister_action_trigger(action_trigger)` | Unregisters an action trigger. | Required: `ActionTrigger` | manual cleanup |

## Full example usage

```gdscript
var open_cmd := PrintCommand.new("Open door")

if CommandScheduler.schedule(open_cmd):
	print("scheduled")

if CommandScheduler.is_scheduled(open_cmd):
	CommandScheduler.cancel(open_cmd)

CommandScheduler.cancel_all()
```

---
