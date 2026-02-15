extends Node3D

var _use_fast_branch: bool = true


func _ready() -> void:
	await get_tree().process_frame
	print("EXPECT: SelectCommand branching test")
	print("Run 1 (fast=true): should print 'Select: FAST path'.")
	print("Run 2 (fast=false): should print 'Select: SLOW path'.")

	_schedule_select_run()
	await get_tree().create_timer(0.5).timeout
	_use_fast_branch = false
	_schedule_select_run()


func _schedule_select_run() -> void:
	var selector := Callable(self, "_select_key")
	var command_map: Dictionary = {}
	command_map["fast"] = PrintCommand.new("Select: FAST path")
	command_map["slow"] = SequentialCommandGroup.new(
		[WaitCommand.new(0.3), PrintCommand.new("Select: SLOW path")]
	)
	CommandScheduler.schedule(SelectCommand.new(selector, command_map))


func _select_key() -> String:
	return "fast" if _use_fast_branch else "slow"
