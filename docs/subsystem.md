# Subsystem Reference

## Reference description

`Subsystem` is a `RefCounted` object that groups related behavior and can expose a default command.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `default_command` | Command automatically scheduled when subsystem is idle. | `movement.set_default_command(idle_move)` |
| `_init()` | Registers subsystem in scheduler. | Auto-called on construction |
| `_notification(NOTIFICATION_PREDELETE)` | Unregisters subsystem in scheduler. | Auto-called before free |
| `periodic(delta_time)` | Per-frame subsystem update hook (_process). | Updating coin counter |
| `physics_periodic(delta_time)` | Physics-step subsystem update hook (_physics_process). | Update kinematics |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `set_default_command(command)` | Sets or clears default command. Warns if command does not require this subsystem. | Required: `Command` or `null` | `set_default_command(idle_drive)` |

## Full example usage

```gdscript
class_name DriveSubsystem
extends Subsystem


func _init() -> void:
	var idle_drive := RunCommand.new(func(dt):
		# keep tiny stabilization logic here
		pass,
		[self]
	)
	set_default_command(idle_drive)

func periodic(delta_time: float) -> void:
	pass
```

---
