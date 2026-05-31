extends MeshInstance3D

# Billboarding
func _process(_delta: float) -> void:
	look_at_from_position(global_position, get_viewport().get_camera_3d().global_position)
	rotation.x = 0
	rotation.z = 0
