class_name TurnToCommand
extends Command

# Command that rotates a navigation subsystem to face a target heading/direction.
# The command finishes when the agent is facing the target direction.

var _navigation_subsystem: PureNavigationSubsystem = null
var _target_heading: Vector3 = Vector3.FORWARD

func _init(navigation_subsystem: PureNavigationSubsystem, target_heading: Vector3, interruptible: bool = true) -> void:
	_navigation_subsystem = navigation_subsystem
	_target_heading = target_heading.normalized()
	super._init([navigation_subsystem], interruptible)

func initialize() -> void:
	if _navigation_subsystem != null:
		_navigation_subsystem.turn_to_heading(_target_heading)

func is_finished() -> bool:
	if _navigation_subsystem == null:
		return true
	return _navigation_subsystem.is_navigation_finished()

func end(interrupted: bool) -> void:
	if interrupted and _navigation_subsystem != null:
		_navigation_subsystem.stop()
