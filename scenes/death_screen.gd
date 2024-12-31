extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart_level"):
		SignalBus.restart_level.emit()
		queue_free()
