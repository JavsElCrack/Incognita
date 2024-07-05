extends Node

@onready var camera3D: Camera3D = null
var transitioning: bool = false
var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	find_or_create_camera3D()
	pass

func find_or_create_camera3D():
	camera3D = $Camera3D
	if camera3D == null:
		# Camera3D node not found, create a new one
		camera3D = Camera3D.new()
		# Optionally, you can add it to the scene tree
		add_child(camera3D)
		print("Created new Camera3D node.")
	else:
		print("Camera3D node found: ", camera3D)

func transition_camera(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning:
		return

	# Ensure the camera3D is valid before proceeding
	if camera3D == null:
		find_or_create_camera3D()


	# Copy the parameters of the first camera
	camera3D.fov = from.fov
	camera3D.cull_mask = from.cull_mask
	

	# Move our transition camera to the first camera position
	camera3D.global_transform = from.global_transform

	# Make our transition camera current
	camera3D.current = true

	transitioning = true
	tween = create_tween()

	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(camera3D, "global_transform", to.global_transform, duration).from(camera3D.global_transform)
	tween.tween_property(camera3D, "fov", to.fov, duration).from(camera3D.fov)

	# Wait for the tween to complete
	await tween.finished

	# Make the second camera current
	to.current = true
	transitioning = false
