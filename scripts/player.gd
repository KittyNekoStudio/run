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
var climbing: bool = false
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
			$Character.rotation.y = pivot.rotation.y


func _ready() -> void:
	SignalBus.connect("player_entered", _on_climbable_wall_entered)
	SignalBus.connect("player_exited", _on_climbable_wall_exited)


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (pivot.transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
		
	if sliding:
		slide_timer -= delta
		# TODO! make player lower to the ground while sliding
		if slide_timer <= 0:
			sliding = false
	
	if Input.is_action_pressed("run") and not sliding and not climbing:
		sliding = false
		running = true
	else:
		running = false

	# Can only slide facing forward while running
	if Input.is_action_just_pressed("slide") and input_direction == Vector2(0, -1) and running:
		running = false
		sliding = true
		slide_timer = slide_timer_max

	if running and input_direction != Vector2.ZERO:
		target_velocity.x = direction.x * running_speed
		target_velocity.z = direction.z * running_speed
	elif sliding:
		target_velocity.x = direction.x * slide_timer * sliding_speed
		target_velocity.z = direction.z * slide_timer * sliding_speed
	elif climbing and input_direction == Vector2(0, -1):
		if Input.is_action_pressed("run"):
			target_velocity.y = direction.y + climbing_speed * 2
		else:
			target_velocity.y = direction.y + climbing_speed
	else:
		target_velocity.x = direction.x * walking_speed
		target_velocity.z = direction.z * walking_speed
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if running:
			target_velocity.y = jump_acceleration * 1.5
		else:
			target_velocity.y = jump_acceleration
	
	velocity = target_velocity
	move_and_slide()


func _on_climbable_wall_entered() -> void:
	climbing = true


func _on_climbable_wall_exited() -> void:
	climbing = false
