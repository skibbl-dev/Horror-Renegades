extends Control

@onready var player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	if player.raycast.is_colliding():
		if player.raycast.get_collider().is_in_group("pickable"):
			$crosshair.hide()
			$crosshair_select.show()
	else: 
		$crosshair_select.hide()
		$crosshair.show()
