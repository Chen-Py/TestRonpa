extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const mouse_sensitivity = 0.1
@export var camera: Camera3D
@export var bullet_scene: PackedScene

@onready var joystick: VirtualJoystickPlus = $"../CanvasLayer/VirtualJoystickPlus"
@onready var spring_arm: SpringArm3D = $SpringArm3D
var drag_distance = 0.0

func _rotate_camera(relative: Vector2) -> void:
	# 左右旋转 SpringArm (Y轴)
	spring_arm.rotation_degrees.y -= relative.x * mouse_sensitivity
	
	# 上下旋转 SpringArm (X轴)，并限制角度防止翻转
	spring_arm.rotation_degrees.x -= relative.y * mouse_sensitivity
	spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -70, 30)


#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventScreenDrag:
	## 1. 处理拖拽 (视角旋转)
		#var screen_half = get_viewport().get_visible_rect().size.x / 2.0
		#if event.position.x < screen_half:
			#return
		#drag_distance += event.relative.length()
		#_rotate_camera(event.relative)
		#return # 既然是拖拽，就不再往下执行点击判断
#
	## 2. 处理点击 (发射) - 注意：这个 if 必须和上面的 ScreenDrag 平级！
	#if event is InputEventScreenTouch:
		#var screen_half = get_viewport().get_visible_rect().size.x / 2.0
		#if event.position.x < screen_half:
			#return
		## 同样限制在右半屏，避免干扰左手摇杆
		#if event.pressed:
			#drag_distance = 0.0
		#else:
				## 手指抬起时，如果移动距离很小，判断为点击
			#if drag_distance < 15.0: 
				#shoot()

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
