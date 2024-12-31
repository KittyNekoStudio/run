extends Area3D


func _on_body_entered(_body: Node3D) -> void:
	SignalBus.finish_level.emit()
	get_parent().queue_free()
