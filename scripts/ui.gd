extends Control

@onready var player = get_parent().get_node("Player")

func _process(_delta: float) -> void:
	if player.raycast.is_colliding():
		var target = player.raycast.get_collider()
		
		if target.is_in_group("pickable") or target.is_in_group("interactable"):
			$crosshair.hide()
			$crosshair_select.show()
		else:
			$crosshair_select.hide()
			$crosshair.show()
	else:
		$crosshair_select.hide()
		$crosshair.show()
