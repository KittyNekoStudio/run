extends Node

var level_1: PackedScene = preload("res://scenes/level_1.tscn")
var death_screen: PackedScene = preload("res://scenes/death_screen.tscn")
var current_level: String

var completion_times: Dictionary
var level_number: int = 1


func _ready() -> void:
	$Timer.set_process(false)
	SignalBus.finish_level.connect(finish_level)
	SignalBus.connect("player_died", player_died)
	SignalBus.connect("restart_level", restart_level)
	$TitleScreen/StartGame.pressed.connect(start_game)


func start_game() -> void:
	$TitleScreen.queue_free()
	var level_1_instance: Node = level_1.instantiate()
	add_child(level_1_instance)
	current_level = "level_1"
	$Timer.set_process(true)


func finish_level() -> void:
	completion_times["level_" + str(level_number)] = $Timer.reset()
	level_number += 1
	if completion_times.has("level_1"):
		print(completion_times)


func restart_level() -> void:
	match current_level:
		"level_1":
			var level_1_instance: Node = level_1.instantiate()
			add_child(level_1_instance)
	
	$Timer.set_process(true)


func player_died() -> void:
	$Timer.stop()
	$Timer.set_process(false)
	var death_screen_instance: Node = death_screen.instantiate()
	add_child(death_screen_instance)
