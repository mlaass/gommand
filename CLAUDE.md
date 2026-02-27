# CLAUDE.md — Gommand

## Project Overview

Gommand is a **command-based framework** for **Godot 4.6** written entirely in **GDScript**. It provides a declarative way to compose game logic using small, focused commands instead of state machines or tangled control flow. Inspired by WPILib's command-based paradigm from FRC robotics.

**Repository:** `COOKIE-POLICE/gommand`
**License:** MIT
**Author:** Benny Zhu

## Directory Structure

```
gommand/
├── addons/gommand/             # The plugin (only this ships to users)
│   ├── core/
│   │   ├── commands/           # All command types (Command base + 18 subclasses)
│   │   ├── command_scheduler.gd  # Singleton autoload — the execution engine
│   │   ├── command_state.gd    # Internal state wrapper for scheduled commands
│   │   ├── action_trigger.gd   # Input → command binding (builder pattern)
│   │   └── subsystem.gd        # Resource ownership + default commands
│   ├── scripts/
│   │   ├── functional_tools.gd # Static map/filter/any/all/for_each/reduce
│   │   ├── guard.gd            # Precondition assertion helpers
│   │   └── set.gd              # Dictionary-backed set data structure
│   ├── assets/editor_icons/    # Plugin icons (icon.png, gear.svg)
│   ├── plugin.gd               # EditorPlugin — registers autoload + custom type
│   └── plugin.cfg              # Plugin metadata (name, version, author)
├── manual_integration_test/    # Manual test scenes (run in Godot editor)
│   ├── action_trigger_manual_integration_test/
│   ├── decorator_manual_integration_test/
│   └── subsystem_manual_integration_test/
├── docs/                       # MkDocs documentation source (Markdown)
├── mkdocs.yml                  # MkDocs Material config
├── project.godot               # Godot project file (config_version=5, Godot 4.6)
└── .github/workflows/ci.yml   # CI: deploys docs via mkdocs gh-deploy
```

## Architecture

### Core Concepts

1. **Command** (`addons/gommand/core/commands/command.gd`) — Base class (extends `RefCounted`). Lifecycle: `initialize()` → `execute(delta)` / `physics_execute(delta)` → `is_finished()` → `end(interrupted)`. All commands extend this.

2. **CommandScheduler** (`addons/gommand/core/command_scheduler.gd`) — Singleton autoload (extends `Node`). Manages command lifecycle, subsystem ownership, conflict resolution, and action trigger polling. Runs in both `_process` and `_physics_process`.

3. **Subsystem** (`addons/gommand/core/subsystem.gd`) — Extends `RefCounted`. Represents a shared resource that commands can "require". Only one command can use a subsystem at a time. Supports default commands that run when the subsystem is idle.

4. **ActionTrigger** (`addons/gommand/core/action_trigger.gd`) — Input binding via builder pattern. Supports on-press, on-release, while-pressed, and toggle modes.

### Command Types

| Command | Purpose |
|---------|---------|
| `SequentialCommandGroup` | Runs children in order |
| `ParallelCommandGroup` | Runs children simultaneously, finishes when all done |
| `ParallelRaceGroup` | Runs children simultaneously, finishes when any one finishes |
| `ParallelDeadlineGroup` | Runs children until a deadline command finishes |
| `ConditionalCommand` | Runs true-branch or false-branch based on a callable |
| `SelectCommand` | Chooses a command from a dictionary using a selector callable |
| `RepeatCommand` | Repeats an inner command N times (0 = forever) |
| `FunctionalCommand` | Command defined entirely by callables |
| `InstantCommand` | Runs a callable once, finishes immediately |
| `RunCommand` | Runs a callable every tick, never finishes |
| `StartEndCommand` | Calls start on init, end on interruption, never self-finishes |
| `WaitCommand` | Waits for a duration (seconds) |
| `WaitUntilCommand` | Waits until a predicate returns true |
| `DeferredCommand` | Creates a command lazily via factory callable at initialize time |
| `ScheduleCommand` | Schedules another command via the scheduler, then finishes |
| `PrintCommand` | Prints a message, finishes immediately |
| `PerpetualCommand` | Wraps a command to never finish (must be interrupted) |
| `UninterruptibleCommand` | Wraps a command to prevent interruption |

### Key Patterns

- **Functional style:** The codebase uses `FunctionalTools.map`, `filter`, `any`, `all`, `for_each` extensively instead of raw loops. Follow this convention.
- **Guard preconditions:** Use `Guard.against_null()`, `Guard.against_false()`, etc. from `guard.gd` instead of bare `assert()`.
- **Builder pattern:** `ActionTrigger` uses a nested `Builder` class with fluent API.
- **RefCounted base:** `Command`, `Subsystem`, and `ActionTrigger` all extend `RefCounted` (not `Node`). They use `_notification(NOTIFICATION_PREDELETE)` for cleanup instead of `_exit_tree`.
- **Requirement adoption:** Composite commands (groups, decorators) adopt child requirements in their `_init()`.
- **Const preloads:** Dependencies between scripts use `const X = preload("path")` at the top of the file, not `class_name` references for internal scripts.

## Coding Conventions

### GDScript Style

- **Indentation:** Tabs (Godot default)
- **Naming:**
  - `snake_case` for functions, variables, and file names
  - `PascalCase` for class names (`class_name` declarations)
  - Private members/methods prefixed with `_` (e.g., `_commands`, `_execute_inner`)
- **Type annotations:** Used for function parameters and return types. Variables use `:=` for type inference where possible.
- **File organization:** One class per file. File name matches the `snake_case` version of the `class_name`.
- **Blank lines:** Two blank lines between functions. One blank line after the last `const`/`var` declaration block.
- **Trailing return self:** Builder methods and `Command.add_requirement()` return `self` for fluent chaining.

### Error Handling

- Use `Guard` static methods for precondition checks (they call `push_error`/`push_warning`, not `assert`)
- Check `is_instance_valid()` before accessing objects that may have been freed
- Use `weakref()` for references that shouldn't prevent garbage collection (e.g., action triggers in scheduler)
- Null checks before operations: `if command == null: return`

### Command Implementation Pattern

When creating a new command type:
1. Extend `Command`
2. Call `super._init(requirements, interruptible)` — pass `[]` for requirements if adopting from children
3. Adopt child requirements in `_init()` using `FunctionalTools.for_each` + `add_requirement`
4. Override `_on_scheduled()` → call `super._on_scheduled()` then schedule children
5. Override lifecycle methods as needed: `initialize()`, `execute(delta)`, `physics_execute(delta)`, `is_finished()`, `end(interrupted)`
6. For decorators (wrappers): manage inner command initialization via `_has_initialized()` / `_mark_initialized()`

### Decorator Command Pattern

Commands that wrap a single inner command follow this structure:
- Store `_inner_command` in `_init()`
- Adopt inner requirements
- Delegate lifecycle calls (`_initialize_inner`, `_execute_inner`, etc.)
- Handle `end(interrupted)` — only end inner if it hasn't already finished

## Testing

**No automated unit tests.** The project uses **manual integration tests** run inside the Godot editor:

- Located in `manual_integration_test/` with subdirectories per feature area
- Each test is a GDScript scene script (extends `Node3D`) that prints expected behavior and exercises commands
- Tests use `await get_tree().process_frame` and `await get_tree().create_timer(N).timeout` for timing
- Test verification is done by reading console output against the printed `EXPECT:` lines

To run tests: Open the project in Godot 4.6, open the test scene, and run it. Check the Output panel.

The `project.godot` references GdUnit4 settings (`[gdunit4]` section) indicating previous unit test usage, but unit tests were removed in favor of manual integration tests.

## CI/CD

The only CI workflow (`.github/workflows/ci.yml`) deploys documentation:
- Triggers on push to `master` or `main`
- Uses `mkdocs-material` to build and deploy docs to GitHub Pages via `mkdocs gh-deploy --force`
- No automated test pipeline

## Documentation

- **MkDocs site** built from `docs/` directory with `mkdocs.yml` (Material theme)
- Each command type and core class has its own `.md` file in `docs/`
- Published to GitHub Pages at `https://cookie-police.github.io/gommand/`

## Plugin Distribution

The `.gitattributes` uses `export-ignore` to ensure only `addons/gommand/` is included when the repository is downloaded as a Godot asset. Everything else (tests, docs, project files) is excluded from exports.

## Working with This Codebase

### Adding a New Command

1. Create `addons/gommand/core/commands/your_command.gd`
2. Add `class_name YourCommand` and `extends Command`
3. Follow the command implementation pattern above
4. Add a manual integration test in `manual_integration_test/`
5. Add documentation in `docs/your_command.md`
6. Add the doc entry to `mkdocs.yml` under the appropriate nav section

### Modifying the Scheduler

The `CommandScheduler` is the central singleton. Changes here affect all commands. Key areas:
- `run()` — main process loop (action triggers → subsystem periodic → command execution → default commands)
- `physics_run()` — physics process loop
- `_schedule_internal()` — conflict resolution logic
- `_unschedule_internal()` — cleanup logic

### Important Notes

- `CommandScheduler` is an **autoload singleton** — access it globally by name
- All `*.gd.uid` files are Godot-generated unique IDs; do not manually edit
- The `Set` class is `preload`-ed (no `class_name`) to avoid global namespace pollution
- `FunctionalTools.for_each` uses `Array.map()` internally (side-effect based) — this is intentional
- Commands can be composed deeply (nested groups, decorators wrapping groups, etc.)
