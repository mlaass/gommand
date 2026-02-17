class_name ActionTrigger
extends RefCounted

const FunctionalTools = preload("../scripts/functional_tools.gd")
const Guard = preload("../scripts/guard.gd")

var action_name: String = ""
var previously_pressed: bool = false

var commands_on_action_pressed: Array = []
var commands_on_action_released: Array = []
var commands_while_action_pressed: Array = []
var toggle_states: Dictionary = {}

class Builder:
	var action_name: String = ""
	var commands_on_action_pressed: Array = []
	var commands_on_action_released: Array = []
	var commands_while_action_pressed: Array = []
	var toggle_states: Dictionary = {}

	func _init(action_name_value: String) -> void:
		action_name = action_name_value

	func add_on_action_pressed(command: Command) -> Builder:
		if command == null:
			return self
		commands_on_action_pressed.append(command)
		return self

	func add_on_action_released(command: Command) -> Builder:
		if command == null:
			return self
		commands_on_action_released.append(command)
		return self

	func add_while_action_pressed(command: Command) -> Builder:
		if command == null:
			return self
		commands_while_action_pressed.append(command)
		return self

	func add_toggle_on_action_pressed(command: Command) -> Builder:
		if command == null:
			return self
		toggle_states[command] = false
		return self

	func build() -> ActionTrigger:
		return ActionTrigger.new(self)





static func builder(action_name_value: String) -> Builder:
	return Builder.new(action_name_value)


func _init(builder: Builder) -> void:
	Guard.against_null(builder, "ActionTrigger requires a Builder.")
	if builder == null:
		return
	Guard.against_empty_string(builder.action_name, "ActionTrigger requires a non-empty action name.")
	action_name = builder.action_name
	commands_on_action_pressed = builder.commands_on_action_pressed.duplicate(true)
	commands_on_action_released = builder.commands_on_action_released.duplicate(true)
	commands_while_action_pressed = builder.commands_while_action_pressed.duplicate(true)
	toggle_states = builder.toggle_states.duplicate(true)
	previously_pressed = false
	CommandScheduler.register_action_trigger(self)


func clear_all_bindings() -> void:
	commands_on_action_pressed.clear()
	commands_on_action_released.clear()
	commands_while_action_pressed.clear()
	toggle_states.clear()


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		clear_all_bindings()
		CommandScheduler.unregister_action_trigger(self)


func _update() -> void:
	var currently_pressed := Input.is_action_pressed(action_name)
	var rising_edge := currently_pressed and not previously_pressed
	var falling_edge := not currently_pressed and previously_pressed

	if rising_edge:
		_on_press()
	if falling_edge:
		_on_release()

	previously_pressed = currently_pressed


func _on_press() -> void:
	FunctionalTools.for_each(
		commands_on_action_pressed,
		func(command): CommandScheduler.schedule(command)
	)
	FunctionalTools.for_each(
		FunctionalTools.filter(commands_while_action_pressed, func(command): return not CommandScheduler.is_scheduled(command)),
		func(command): CommandScheduler.schedule(command)
	)
	FunctionalTools.for_each(toggle_states.keys(), _process_toggle)


func _on_release() -> void:
	FunctionalTools.for_each(
		commands_on_action_released,
		func(command): CommandScheduler.schedule(command)
	)
	FunctionalTools.for_each(
		FunctionalTools.filter(commands_while_action_pressed, func(command): return CommandScheduler.is_scheduled(command)),
		func(command): CommandScheduler.cancel(command)
	)


func _process_toggle(command: Command) -> void:
	var is_toggled_on: bool = toggle_states[command]
	if is_toggled_on:
		CommandScheduler.cancel(command)
		toggle_states[command] = false
	elif CommandScheduler.schedule(command):
		toggle_states[command] = true
