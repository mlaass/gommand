class_name PureNavigationSubsystem
extends Subsystem

# Abstract base class for navigation subsystems.
# Subclasses should implement navigation logic for 2D or 3D navigation.

# Called to move the agent to a target position
func go_to_position(target_position: Variant) -> void:
	push_error("go_to_position() must be implemented by subclass")

# Called to turn/face a specific heading/direction
func turn_to_heading(target_heading: Variant) -> void:
	push_error("turn_to_heading() must be implemented by subclass")

# Called to turn by a relative amount
func turn_by_amount(delta_heading: Variant) -> void:
	push_error("turn_by_amount() must be implemented by subclass")

# Returns true if the agent has reached the target position
func is_navigation_finished() -> bool:
	push_error("is_navigation_finished() must be implemented by subclass")
	return false

# Returns the current velocity of the agent
func get_current_velocity() -> Variant:
	push_error("get_current_velocity() must be implemented by subclass")
	return null

# Stops the agent's movement
func stop() -> void:
	push_error("stop() must be implemented by subclass")
