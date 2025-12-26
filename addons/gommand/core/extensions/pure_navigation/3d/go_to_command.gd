class_name GoToCommand
extends Command

# Command that moves a navigation subsystem to a target position.
# The command finishes when the navigation agent reaches the target.

var _navigation_subsystem: PureNavigationSubsystem = null
var _target_position: Vector3 = Vector3.ZERO

func _init(navigation_subsystem: PureNavigationSubsystem, target_position: Vector3, interruptible: bool = true) -> void:
	_navigation_subsystem = navigation_subsystem
	_target_position = target_position
	super._init([navigation_subsystem], interruptible)

func initialize() -> void:
	if _navigation_subsystem != null:
		_navigation_subsystem.go_to_position(_target_position)

func is_finished() -> bool:
	if _navigation_subsystem == null:
		return true
	return _navigation_subsystem.is_navigation_finished()

func end(interrupted: bool) -> void:
	if interrupted and _navigation_subsystem != null:
		_navigation_subsystem.stop()
