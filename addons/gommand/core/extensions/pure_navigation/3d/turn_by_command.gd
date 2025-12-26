class_name TurnByCommand
extends Command

# Command that rotates a navigation subsystem by a relative amount (in radians).
# Positive values turn counter-clockwise (left), negative values turn clockwise (right).
# The command finishes when the rotation is complete.

var _navigation_subsystem: PureNavigationSubsystem = null
var _delta_heading: float = 0.0

func _init(navigation_subsystem: PureNavigationSubsystem, delta_heading_radians: float, interruptible: bool = true) -> void:
	_navigation_subsystem = navigation_subsystem
	_delta_heading = delta_heading_radians
	super._init([navigation_subsystem], interruptible)

func initialize() -> void:
	if _navigation_subsystem != null:
		_navigation_subsystem.turn_by_amount(_delta_heading)

func is_finished() -> bool:
	if _navigation_subsystem == null:
		return true
	return _navigation_subsystem.is_navigation_finished()

func end(interrupted: bool) -> void:
	if interrupted and _navigation_subsystem != null:
		_navigation_subsystem.stop()
