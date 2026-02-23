extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var camera: Camera3D
@export var bullet_scene: PackedScene

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	if Input.is_action_just_pressed("SHOOT"):
		shoot()
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func shoot():
	#print("SHOOT!")
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	var position = global_transform.origin
	position += Vector3(0,2.5,0)
	bullet.global_transform.origin = position + (-$SpringArm3D/Camera3D.global_transform.basis.z) * 0.0
	bullet.direction = -$SpringArm3D/Camera3D.global_transform.basis.z
