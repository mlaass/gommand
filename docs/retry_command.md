# RetryCommand Reference

## Reference description

`RetryCommand` is a practical retry pattern built with `RepeatCommand`: rerun the same command for multiple attempts until attempts are exhausted.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| implementation | Use `RepeatCommand` in this project. | `RepeatCommand.new(task, attempts)` |
| `attempts` | Total attempts to run the command. | `3` |
| finish rule | Finishes after the configured attempt count. | N/A |
| note | There is no separate `RetryCommand` class file currently. | `repeat_command.gd` |

## Methods

Simple retry-style setup.

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `RepeatCommand.new(task, attempts)` | Retries `task` for a limited number of attempts. | Required: command and attempts | `RepeatCommand.new(connect_once, 3)` |

## Full example usage

```gdscript
var connect_once := InstantCommand.new(func():
	print("attempt connection")
)

var retry_connect := RepeatCommand.new(connect_once, 3)
CommandScheduler.schedule(retry_connect)
```

---
