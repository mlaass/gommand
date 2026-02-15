extends Node3D

var _while_elapsed: float = 0.0
var _trigger: ActionTrigger


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: ActionTrigger press/release/toggle/while")
	print("Use action 'gommand_test_pressed' (mapped in project input).")
	print("Press once -> on_press + toggle START. Hold -> while messages every ~0.25s. Release -> on_release.")
	print("Press again -> toggle END.")

	var while_command := RunCommand.new(Callable(self, "_on_while_pressed"))
	var toggle_command := StartEndCommand.new(
		Callable(self, "_on_toggle_started"),
		Callable(self, "_on_toggle_ended")
	)
	_trigger = (
		ActionTrigger
		. builder("gommand_test_pressed")
		. add_on_action_pressed(PrintCommand.new("ActionTrigger: on_action_pressed"))
		. add_on_action_released(PrintCommand.new("ActionTrigger: on_action_released"))
		. add_while_action_pressed(while_command)
		. add_toggle_on_action_pressed(toggle_command)
		. build()
	)


func _on_while_pressed(delta_time: float) -> void:
	_while_elapsed += delta_time
	if _while_elapsed >= 0.25:
		_while_elapsed = 0.0
		print("ActionTrigger: while_action_pressed tick")


func _on_toggle_started() -> void:
	print("ActionTrigger: toggle START")


func _on_toggle_ended() -> void:
	print("ActionTrigger: toggle END")
