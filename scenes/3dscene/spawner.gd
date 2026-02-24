extends Node3D

@export var kuma_scene: PackedScene
@export var spawn_radius: float = 14.0
@export var max_kuma: int = 5

func _ready():
	randomize()
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_kuma()

func spawn_kuma():
	if get_tree().get_nodes_in_group("kuma").size() >= max_kuma:
		return
	var kuma = kuma_scene.instantiate()
	kuma.add_to_group("kuma")

	get_tree().current_scene.add_child(kuma)
	# 生成随机圆内坐标
	var pos = random_point_in_circle(spawn_radius)

	kuma.global_position = global_position + pos
	
func random_point_in_circle(radius: float) -> Vector3:
	var angle = randf() * TAU
	var dist = sqrt(randf()) * radius

	var x = cos(angle) * dist
	var z = sin(angle) * dist

	return Vector3(x, 2.3, z)
