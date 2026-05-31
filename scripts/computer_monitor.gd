extends Node3D

@export var viewport:SubViewport
@onready var screen_mesh: MeshInstance3D = $Screen

func _ready() -> void:
	screen_mesh.get_mesh().get_material().albedo_texture = viewport.get_texture()
