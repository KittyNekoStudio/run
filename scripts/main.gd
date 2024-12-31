extends Node

var level_1: PackedScene = preload("res://scenes/level_1.tscn")
var level_2: PackedScene = preload("res://scenes/level_2.tscn")
var death_screen: PackedScene = preload("res://scenes/death_screen.tscn")
var current_level: int = 0

var completion_times: Dictionary


func _ready() -> void:
	$Timer.set_process(false)
	SignalBus.finish_level.connect(finish_level)
	SignalBus.player_died.connect(player_died)
	SignalBus.restart_level.connect(restart_level)
	$TitleScreen/StartGame.pressed.connect(start_game)


func start_game() -> void:
	$TitleScreen.queue_free()
	current_level += 1
	load_level()
	$Timer.set_process(true)


func finish_level() -> void:
	completion_times["level_" + str(current_level)] = $Timer.reset()
	$Timer.set_process(false)
	current_level += 1
	if completion_times.has("level_1"):
		print(completion_times)
	load_level()
	$Timer.set_process(true)

func restart_level() -> void:
	load_level()
	
	$Timer.set_process(true)


func load_level() -> void:
	match current_level:
		1:
			var level_1_instance: Node = level_1.instantiate()
			add_child(level_1_instance)
		2:
			var level_2_instance: Node = level_2.instantiate()
			add_child(level_2_instance)


func player_died() -> void:
	$Timer.stop()
	$Timer.set_process(false)
	var death_screen_instance: Node = death_screen.instantiate()
	add_child(death_screen_instance)
