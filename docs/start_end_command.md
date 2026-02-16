# StartEndCommand Reference

## Reference description

`StartEndCommand` runs a start callable on initialize and an end callable when canceled or finished.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `on_start_callable` | Called once on initialize. | `func(): light_on()` |
| `on_end_callable` | Called once in `end(...)`. | `func(): light_off()` |
| `requirements` | Required subsystems. Optional. | `[intake]` |
| finish rule | Always returns `false`, so it runs until canceled. | N/A |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `StartEndCommand.new(on_start, on_end, requirements)` | Creates paired start/end behavior. | Required: start and end callables | `StartEndCommand.new(begin_spin, stop_spin, [motor])` |

## Full example usage

```gdscript
var command := StartEndCommand.new(
	func(): shield.visible = true,
	func(): shield.visible = false
)

CommandScheduler.schedule(command)
```

---
