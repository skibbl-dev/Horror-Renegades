extends StaticBody3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var top_open = false

func interact() -> void:
	if !top_open:
		anim_player.play("top_open")
		top_open = true
	else:
		anim_player.play("top_close")
		top_open = false
