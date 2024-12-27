extends CharacterBody3D

@export var speed: int = 10
@export var fall_acceleration: int = 20
@export var jump_acceleration: int = 5
@export var climbing_speed: int = 5

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera

var target_velocity := Vector3.ZERO


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
	var direction := Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = (pivot.basis * direction).normalized()
		$Character.basis = Basis.looking_at(direction)
	
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	
	if Input.is_action_pressed("run") and is_on_floor():
		direction *= 2
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_acceleration
	
	if Global.touching_climbable_wall:
		target_velocity.y = climbing_speed
	
	velocity = target_velocity
	move_and_slide()


func _on_climbable_wall_player_entered() -> void:
	Global.touching_climbable_wall = true


func _on_climbable_wall_player_exited() -> void:
	Global.touching_climbable_wall = false
