extends CharacterBody3D

@onready var main: Node3D = $".."

var speed
const WALK_SPEED = 3.7
const SPRINT_SPEED = 5.5
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

const BOB_FREQ = 2.4
const BOB_AMP = 0.08
const THROW_FORCE = 3
var t_bob = 0.0 # Time counter for head bob
var can_bob: bool = true

const BASE_FOV = 75.0 # Default field of view
const FOV_CHANGE = 1.5 # How much FOV changes when moving

var gravity = 9.8

@onready var head = $head
@onready var camera = $head/Camera3D
var base_camera_pos : Vector3

#picking up
@onready var raycast: RayCast3D = $head/Camera3D/RayCast3D
@onready var pickup_area: Marker3D = $head/Camera3D/pickup_area
var held_item: RigidBody3D
var picked: bool = false
var holding: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	base_camera_pos = camera.transform.origin

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Rotate head left/right based on mouse X movement
		head.rotate_y(-event.relative.x * SENSITIVITY)
		# Rotate camera up/down based on mouse Y movement
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		# Clamp vertical rotation so player can't look too far up or down
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# Apply gravity when not on floor
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jumping when jump button pressed and player is on floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle sprinting input
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	for collision in get_slide_collision_count():
		var collision_info = get_slide_collision(collision)
		var collider = collision_info.get_collider()
		if collider is RigidBody3D:
			var push_force = -collision_info.get_normal() * 2.0
			collider.apply_central_impulse(push_force)

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	# Convert input to world direction relative to head rotation
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle horizontal movement and smoothing based on whether on floor
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
		can_bob = false

	# Update head bob timer and control bob only on floor
	can_bob = is_on_floor()
	t_bob += delta * velocity.length() * float(can_bob)
	var bob_offset = _headbob(t_bob)
	camera.transform.origin = base_camera_pos + bob_offset

	# Adjust FOV based on movement speed for sprint effect
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3(0,0,0)
	if can_bob:
		pos.y = sin(time * BOB_FREQ) * BOB_AMP # Vertical bobbing
		pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP # Horizontal bobbing
	return pos

func _process(_delta: float) -> void:
	pickup()

func pickup():
	if holding and Input.is_action_just_pressed("interact"):
		drop()
		return
		
	if !holding and Input.is_action_just_pressed("interact") and raycast.is_colliding():
		var object = raycast.get_collider()
		if object is RigidBody3D and object.is_in_group("pickable"):
			picked = true
			holding = true
			held_item = object
			
			held_item.get_node("CollisionShape3D").disabled = true
			
			main.remove_child(held_item)
			camera.add_child(held_item)
			
	if picked and holding:
		held_item.global_position = pickup_area.global_position
		if held_item.is_in_group("pickable") and not held_item.is_in_group("usable"):
			#held_item.scale = Vector3(.5,.5,.5)
			held_item.look_at(head.global_position)
			#held_item.look_at(Vector3(global_position.x, held_item.global_position.y, global_position.z))
		elif held_item.is_in_group("usable"):
			if held_item and held_item.is_in_group("usable"):
				#var cam_rot = camera.rotation
				#held_item.rotation.y = 0
				#held_item.rotation.x = cam_rot.y
				#held_item.rotation.z = 0
				held_item.look_at(head.global_position)
				held_item.global_position = pickup_area.global_position
				#held_item.translate_object_local(Vector3(0.2, -0.2, -0.5))

func drop():
	picked = false
	holding = false
	#held_item.scale = Vector3(1,1,1)

	held_item.get_node("CollisionShape3D").disabled = false
	
	camera.remove_child(held_item)
	main.add_child(held_item)
	held_item.global_position = pickup_area.global_position - (head.global_basis.z*0.3)
	held_item.global_rotation = head.global_rotation
	held_item.linear_velocity = head.global_basis.z * -THROW_FORCE
	held_item.angular_velocity = Vector3(0,0,0)
