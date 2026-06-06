extends StaticBody3D

@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var bot_open = false

func interact() -> void:
	if !bot_open:
		anim_player.play("bottom_open")
		bot_open = true
	else:
		anim_player.play("bottom_close")
		bot_open = false
