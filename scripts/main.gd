extends Node

var completion_times: Dictionary
var level_number: int = 1


func _ready() -> void:
	SignalBus.finish_level.connect(finish_level)


func finish_level() -> void:
	completion_times["level_" + str(level_number)] = $Timer.reset()
	level_number += 1
	if completion_times.has("level_1"):
		print(completion_times)
