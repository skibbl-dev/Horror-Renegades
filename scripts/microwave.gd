extends StaticBody3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"


var open = false

func interact() -> void:
	if open == false:
		anim_player.play("open")
		open = true
