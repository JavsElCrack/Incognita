extends CharacterBody2D

@export var speed = 300

# _physics_process is called every physics frame with the delta time
func _physics_process(delta):
	move_and_slide()
