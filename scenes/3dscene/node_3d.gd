extends Area3D

@onready var sprite = $Sprite3D
@onready var collision = $CollisionShape3D
@onready var player = get_tree().get_first_node_in_group("player")
@export var speed := 3.0
func _ready():
	pass

func on_hit():
	print("被击中")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		return
	
	var direction = player.global_position - global_position
	direction.y = 0
	direction = direction.normalized()
	global_position += direction * speed * delta
	pass

func _go_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/gameover/menu.tscn")
	




func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		call_deferred("_go_to_menu")
	pass # Replace with function body.
