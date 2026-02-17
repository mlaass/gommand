**Gommand** is a command framework inspired heavily by WPILib for Godot 4 that keeps your code clean.

Instead of managing state machines or tangled control flow, you write small focused commands and compose them into sequences, parallel groups, or conditional flows. The scheduler handles execution order and prevents conflicts automatically.

**What you get:**

- Readable logic: commands have clear names and a single purpose, so the code says exactly what it does
- Declarative style: all your logic lives in one place, no hunting across files to understand what happens
- Composable flows: chain sequences, run things in parallel, add conditions and repeats
- Conflict prevention: subsystem requirements stop commands from clashing
- Input wiring: bind player actions to commands with `ActionTrigger`

## Gommand At a Glance

### Without Gommand

```gdscript
extends Node3D

var is_dashing := false
var dash_time := 0.0
var attack_pending := false

func _ready() -> void:
    print("Press ui_accept to dash, then attack.")

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept") and not is_dashing:
        is_dashing = true
        dash_time = 0.2
        start_dash()

    if is_dashing:
        dash_time -= delta
        if dash_time <= 0.0:
            is_dashing = false
            stop_dash()
            attack_pending = true

    if attack_pending:
        attack_pending = false
        attack_target()


func start_dash() -> void:
    print("Dash start")


func stop_dash() -> void:
    print("Dash end")


func attack_target() -> void:
    print("Attack")
```

### With Gommand

```gdscript
extends Node3D

var trigger: ActionTrigger


func _ready() -> void:
    print("Press ui_accept to run dash + attack sequence.")

    var dash_and_attack := SequentialCommandGroup.new([
        PrintCommand.new("Dash start"),
        WaitCommand.new(0.2),
        PrintCommand.new("Dash end"),
        PrintCommand.new("Attack"),
    ])

    trigger = (
        ActionTrigger
        .builder("ui_accept")
        .add_on_action_pressed(dash_and_attack)
        .build()
    )
```

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand." — Martin Fowler