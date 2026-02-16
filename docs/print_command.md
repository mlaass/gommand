# PrintCommand Reference

## Reference description

`PrintCommand` prints a message once during `initialize()` and then finishes immediately.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `message` | Text printed to output. | `"Ready"` |
| finish rule | Always finishes right away. | `true` |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `PrintCommand.new(message)` | Creates a one-shot print command. | Required: string | `PrintCommand.new("Hello")` |

## Full example usage

```gdscript
var command := PrintCommand.new("Wave started")
CommandScheduler.schedule(command)
```

---
