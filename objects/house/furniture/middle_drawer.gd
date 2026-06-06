extends StaticBody3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var mid_open = false

func interact() -> void:
	if !mid_open:
		anim_player.play("mid_open")
		mid_open = true
	else:
		anim_player.play("mid_close")
		mid_open = false
