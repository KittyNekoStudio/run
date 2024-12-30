extends Timer

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	if !is_stopped():
		time_elapsed += delta
		$Label.text = str(time_elapsed).pad_decimals(2)
	else:
		time_elapsed = 0.0
		start()

func reset() -> float:
	stop()
	return snapped(time_elapsed, 0.01)
