extends Node3D

var _trigger: ActionTrigger


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: ActionTrigger clear bindings test")
	print("For first 3 seconds, pressing 'gommand_test_released' should print press/release logs.")
	print("After clear, pressing same action should print nothing from ActionTrigger bindings.")

	_trigger = (
		ActionTrigger
		. builder("gommand_test_released")
		. add_on_action_pressed(PrintCommand.new("ClearTest: on_action_pressed"))
		. add_on_action_released(PrintCommand.new("ClearTest: on_action_released"))
		. build()
	)

	await get_tree().create_timer(3.0).timeout
	_trigger.clear_all_bindings()
	print("ClearTest: bindings cleared. Press action again, no binding logs expected.")
