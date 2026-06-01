extends Node3D

@export var viewport:SubViewport
@onready var screen_mesh: MeshInstance3D = $Screen
@onready var player_ray: RayCast3D = get_tree().get_nodes_in_group("player")[0].raycast
@onready var cursor: Marker3D = $Cursor
@onready var screen_area: Area3D = $ScreenArea

func _ready() -> void:
	screen_mesh.get_mesh().get_material().albedo_texture = viewport.get_texture()

func _process(_delta: float) -> void:
	if player_ray.is_colliding():
		if(player_ray.get_collider() == screen_area):
			var collision_point = player_ray.get_collision_point()
			cursor.global_position = cursor.global_position.lerp(collision_point, 0.3)
