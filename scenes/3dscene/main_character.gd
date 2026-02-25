extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const mouse_sensitivity = 0.1
@export var camera: Camera3D
@export var bullet_scene: PackedScene

@onready var joystick: VirtualJoystickPlus = $"../CanvasLayer/VirtualJoystickPlus"
@onready var spring_arm: SpringArm3D = $SpringArm3D
var drag_distance = 0.0

func _ready():
	add_to_group("player")

func _rotate_camera(relative: Vector2) -> void:
	spring_arm.rotation_degrees.y -= relative.x * mouse_sensitivity
	spring_arm.rotation_degrees.x -= relative.y * mouse_sensitivity
	spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -70, 30)

var rotate_finger_index = -1
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventScreenDrag:
		#var screen_half = get_viewport().get_visible_rect().size.x / 2.0
		#if event.position.x < screen_half:
			#return
		#drag_distance += event.relative.length()
		#_rotate_camera(event.relative)
#
	#if event is InputEventScreenTouch:
		#var screen_half = get_viewport().get_visible_rect().size.x / 2.0
		#if event.position.x < screen_half:
			#return
		#if event.pressed:
			#drag_distance = 0.0
		#else:
			#if drag_distance < 15.0: 
				#shoot()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var is_right_side = event.position.x > get_viewport().get_visible_rect().size.x / 2.0
		
		if event.pressed and is_right_side and rotate_finger_index == -1:
			rotate_finger_index = event.index
			drag_distance = 0.0
		elif event.index == rotate_finger_index and not event.pressed:
			if drag_distance < 15.0:
				shoot()
			rotate_finger_index = -1

	if event is InputEventScreenDrag:
		if event.index == rotate_finger_index and event.index != joystick._touch_index:
			if event.relative.length() > 200 : return
			drag_distance += event.relative.length()
			_rotate_camera(event.relative)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
	var input = joystick.get_value()

	# Handle jump.
	
	if Input.is_action_just_pressed("SHOOT"):
		shoot()
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x + input.x, 0, input_dir.y + input.y)).normalized()
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
