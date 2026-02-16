# ActionTrigger Reference

## Reference description

`ActionTrigger` binds a Godot input action to command scheduling on press, release, hold, and toggle.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `action_name` | Input action name from Input Map. | `"shoot"` |
| `commands_on_action_pressed` | Commands scheduled on rising edge. | fire once |
| `commands_on_action_released` | Commands scheduled on falling edge. | stop charge |
| `commands_while_action_pressed` | Commands scheduled while held, canceled on release. | move while held |
| `toggle_states` | Tracks toggled commands for press-to-toggle behavior. | toggle auto-fire |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `ActionTrigger.builder(action_name)` | Starts builder flow for one action. | Required: `String` | `ActionTrigger.builder("jump")` |
| `Builder.add_on_action_pressed(command)` | Adds command for press event. | Required: `Command` | `.add_on_action_pressed(jump_cmd)` |
| `Builder.add_on_action_released(command)` | Adds command for release event. | Required: `Command` | `.add_on_action_released(stop_cmd)` |
| `Builder.add_while_action_pressed(command)` | Adds command to run while held. | Required: `Command` | `.add_while_action_pressed(move_cmd)` |
| `Builder.add_toggle_on_action_pressed(command)` | Adds toggled command. | Required: `Command` | `.add_toggle_on_action_pressed(light_cmd)` |
| `Builder.build()` | Creates and registers trigger in scheduler. | None | `.build()` |
| `clear_all_bindings()` | Removes all trigger bindings. | None | `trigger.clear_all_bindings()` |

## Full example usage

```gdscript
var jump_cmd := InstantCommand.new(func(): player.jump())
var move_cmd := RunCommand.new(func(dt): player.move_right(dt))

var trigger := ActionTrigger
	.builder("move_right")
	.add_while_action_pressed(move_cmd)
	.add_on_action_pressed(jump_cmd)
	.build()
```

---
