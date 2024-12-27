extends StaticBody3D

signal player_entered
signal player_exited


func _on_area_3d_body_entered(_body: Node3D) -> void:
	player_entered.emit()


func _on_area_3d_body_exited(_body: Node3D) -> void:
	player_exited.emit()
