extends StaticBody3D




func _on_area_3d_body_entered(_body: Node3D) -> void:
	SignalBus.player_entered.emit()


func _on_area_3d_body_exited(_body: Node3D) -> void:
	SignalBus.player_exited.emit()
