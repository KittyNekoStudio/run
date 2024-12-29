extends CharacterBody3D

@export var walking_speed: int = 10
@export var running_speed: int = 20
@export var sliding_speed: int = 25
@export var fall_acceleration: int = 60
@export var jump_acceleration: int = 10
@export var climbing_speed: int = 5

var target_velocity := Vector3.ZERO
var running: bool = false
var sliding: bool = false
var slide_timer: float = 0.0
var slide_timer_max: float = 1.0
var slide_vector := Vector2.ZERO

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivot.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (pivot.transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
		
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			sliding = false
	
	if Input.is_action_pressed("run") and not sliding:
		sliding = false
		running = true

	else:
		running = false

	# Can only slide facing forward
	if Input.is_action_just_pressed("slide") and input_direction == Vector2(0, -1):
		running = false
		sliding = true
		slide_timer = slide_timer_max

	if running and input_direction != Vector2.ZERO:
		target_velocity.x = direction.x * running_speed
		target_velocity.z = direction.z * running_speed
		
	elif sliding:
		target_velocity.x = direction.x * slide_timer * sliding_speed
		target_velocity.z = direction.z * slide_timer * sliding_speed
	else:
		target_velocity.x = direction.x * walking_speed
		target_velocity.z = direction.z * walking_speed
	
	velocity = target_velocity
	move_and_slide()


func _on_climbable_wall_player_entered() -> void:
	Global.touching_climbable_wall = true


func _on_climbable_wall_player_exited() -> void:
	Global.touching_climbable_wall = false
