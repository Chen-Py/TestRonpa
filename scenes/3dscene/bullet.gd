extends Node3D

@export var speed: float = 20
var direction: Vector3

func _ready():
	$Timer.start()

func _process(delta):
	translate(direction * speed * delta)

func _on_timer_timeout():
	explode()

func explode():
	$GPUParticles3D.emitting = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
