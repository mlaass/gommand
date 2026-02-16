# FunctionalCommand Reference

## Reference description

`FunctionalCommand` builds a command from callables for initialize, execute, end, and finish checks.

## Fields

| Field | Description | Example |
| :---- | :---- | :---- |
| `initialize_callable` | Called once on initialize. | `func(): timer = 0.0` |
| `execute_callable` | Called every frame/physics with `delta_time`. | `func(dt): timer += dt` |
| `end_callable` | Called when command ends. | `func(interrupted): stop_fx()` |
| `is_finished_callable` | Returns finish state. Optional. | `func(): return timer >= 1.0` |
| `requirements` | Required subsystems. Optional. | `[shooter]` |

## Methods

| Name | Description | Argument | Example |
| :---- | :---- | :---- | :---- |
| `FunctionalCommand.new(...)` | Creates a command from functions. | Required: 4 callables | `FunctionalCommand.new(on_start, on_tick, on_end, done)` |

## Full example usage

```gdscript
var elapsed := 0.0

var command := FunctionalCommand.new(
	func(): elapsed = 0.0,
	func(dt): elapsed += dt,
	func(interrupted): print("finished", interrupted),
	func(): return elapsed >= 2.0
)

CommandScheduler.schedule(command)
```

---
