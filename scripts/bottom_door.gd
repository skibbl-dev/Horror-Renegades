extends StaticBody3D

@onready var anim: AnimationPlayer = $"../AnimationPlayer"

var is_open: bool = false

func interact() -> void:
	if is_open:
		anim.play("bottom_close")
	else:
		anim.play("bottom_open")
		
	is_open = !is_open
