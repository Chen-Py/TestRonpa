extends Area3D

@onready var sprite = $Sprite3D
@onready var collision = $CollisionShape3D

func _ready():
	pass

func on_hit():
	print("被击中")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
