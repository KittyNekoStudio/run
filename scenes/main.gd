extends Node

var completion_times: Dictionary
var level_number: int = 1

func _on_finish_level_body_entered(_body: Node3D) -> void:
	completion_times["level_" + str(level_number)] = $Timer.reset()
	level_number += 1
	print(completion_times)
