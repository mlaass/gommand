extends Node3D

func _ready() -> void:
	await get_tree().process_frame
	CommandScheduler.schedule(
		PrintCommand.new("EXPECT: Conditional_print -> should run TRUE branch")
	)
	CommandScheduler.schedule(
		ConditionalCommand.new(
			Callable(self, "_condition_true"),
			PrintCommand.new("Conditional: TRUE"),
			PrintCommand.new("Conditional: FALSE")
		)
	)


func _condition_true() -> bool:
	return true
