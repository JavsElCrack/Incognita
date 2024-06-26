extends Node3D

@onready var pivot_point = $SubViewport/PivotPoint
@onready var camera =$SubViewport/PivotPoint/MeshInstance3D/Camera3D
@onready var meshinstance  = $SubViewport/PivotPoint/MeshInstance3D
var rotation_speed : float = 0.04  # Adjust this value to change the rotation speed
var rotation_limit : float = 15.0  # Adjust this value to change the rotation limit
var rotation_direction_y : int = 1  # Initial rotation direction for Y-axis: 1 or -1
var rotation_direction_x : int = 1  # Initial rotation direction for X-axis: 1 or -1

func _ready():
	# Randomly set initial rotation directions
	if randi_range(0, 1) == 0:
		rotation_direction_y = 1
	else:
		rotation_direction_y = -1
	
	if randi_range(0, 1) == 0:
		rotation_direction_x = 1
	else:
		rotation_direction_x = -1

func _process(delta):
	# Rotate the pivot point around the Y-axis
	pivot_point.rotate_y(rotation_direction_y * rotation_speed * delta)
	
	# Rotate the pivot point around the X-axis
	pivot_point.rotate_x(rotation_direction_x * rotation_speed * delta)
	
	# Clamp Y-axis rotation
	var current_rotation_y = rad_to_deg(pivot_point.rotation.y)
	current_rotation_y = clamp(current_rotation_y, -rotation_limit, rotation_limit)
	pivot_point.rotation.y = deg_to_rad(current_rotation_y)
	
	# Clamp X-axis rotation
	var current_rotation_x = rad_to_deg(pivot_point.rotation.x)
	current_rotation_x = clamp(current_rotation_x, -rotation_limit, rotation_limit)
	pivot_point.rotation.x = deg_to_rad(current_rotation_x)
	
	# Check if Y-axis rotation limit is reached
	if abs(current_rotation_y) >= rotation_limit:
		rotation_direction_y *= -1  # Reverse direction
	
	# Check if X-axis rotation limit is reached
	if abs(current_rotation_x) >= rotation_limit:
		rotation_direction_x *= -1  # Reverse direction
