extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _input(event):
	if event is InputEventScreenTouch:
		# 检查触摸点是否在按钮范围内
		if get_global_rect().has_point(event.position):
			if event.pressed:
				# 发送按下信号，触发你在编辑器里连好的逻辑
				emit_signal("pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
