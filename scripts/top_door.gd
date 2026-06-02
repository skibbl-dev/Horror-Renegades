extends StaticBody3D

@onready var anim: AnimationPlayer = $"../AnimationPlayer"

var is_open: bool = false

func interact() -> void:
	if is_open:
		anim.play("top_close")
	else:
		anim.play("top_open")
		
	is_open = !is_open
