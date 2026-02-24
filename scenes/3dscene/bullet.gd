extends Area3D

@export var speed: float = 20
var direction: Vector3

func _ready():
	body_entered.connect(_on_hit)
	area_entered.connect(_on_hit)
	$Timer.start()

func _on_hit(body):
	if body.has_method("on_hit"):
		body.on_hit()
	queue_free()

func _process(delta):
	translate(direction * speed * delta)

func _on_timer_timeout():
	explode()

func explode():
	$GPUParticles3D.emitting = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
