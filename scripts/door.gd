extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var open = false

func interact() -> void:
	if open == false:
		animation_player.play("open")
		open = true
	else:
		animation_player.play("close")
		open = false
