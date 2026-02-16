**Gommand** is a command framework for Godot 4 that keeps your code clean.

Instead of managing state machines or tangled control flow, you write small focused commands and compose them into sequences, parallel groups, or conditional flows. The scheduler handles execution order and prevents conflicts automatically.

**What you get:**
- Readable logic: commands have clear names and a single purpose, so the code says exactly what it does
- Declarative style: all your logic lives in one place, no hunting across files to understand what happens
- Composable flows: chain sequences, run things in parallel, add conditions and repeats
- Conflict prevention: subsystem requirements stop commands from clashing
- Input wiring: bind player actions to commands with `ActionTrigger`, no boilerplate

**A simple flow looks like this:**
```gdscript
SequentialCommandGroup.new([
    DashCommand.new(direction),
    WaitCommand.new(0.2),
    AttackCommand.new(target),
])
```

> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand." — Martin Fowler