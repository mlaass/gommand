# SelectCommand Reference

## Reference description

`SelectCommand` picks one command from a dictionary map using a selector key at initialize time.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `selector_callable` | Callable that returns a key. | `func(): return state_name` |
| `command_map` | Dictionary from key to command. | `{"idle": idle_cmd, "run": run_cmd}` |
| selected command | Active command from map lookup. | `command_map[selected_key]` |
| finish rule | Finishes when selected command finishes, or immediately if key is missing. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `SelectCommand.new(selector, map)` | Creates keyed branch command. | Required: selector callable and map | `SelectCommand.new(mode_key, mode_commands)` |

## Full example usage

```gdscript
var mode_key := func(): return weapon_mode
var mode_map := {
	"burst": PrintCommand.new("Burst fire"),
	"single": PrintCommand.new("Single fire")
}

var command := SelectCommand.new(mode_key, mode_map)
CommandScheduler.schedule(command)
```

---
