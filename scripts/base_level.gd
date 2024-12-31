extends Node


func _on_death_box_body_entered(_body: Node3D) -> void:
	SignalBus.player_died.emit()
	queue_free()
