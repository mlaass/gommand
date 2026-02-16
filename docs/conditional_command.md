# ConditionalCommand Reference

## Reference description

`ConditionalCommand` chooses one command at initialize time using a condition callable.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `condition_callable` | Callable returning a boolean. | `func(): return hp > 0` |
| `on_true_command` | Runs when condition is `true`. | `RunCommand.new(...)` |
| `on_false_command` | Runs when condition is `false`. Optional. | `PrintCommand.new("KO")` |
| finish rule | Finishes when active command finishes, or immediately if no active command. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `ConditionalCommand.new(...)` | Creates a branch command. | Required: condition and true command. Optional: false command. | `ConditionalCommand.new(is_grounded, jump, fall)` |

## Full example usage

```gdscript
var is_low_health := func() -> bool: return player_hp < 25
var heal_cmd := PrintCommand.new("Use potion")
var fight_cmd := PrintCommand.new("Keep fighting")

var command := ConditionalCommand.new(is_low_health, heal_cmd, fight_cmd)
CommandScheduler.schedule(command)
```

---
