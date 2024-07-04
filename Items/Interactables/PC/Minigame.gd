extends Node

@onready var player = $Player
@export var SPEED = 300
var enableminigame = true
var velocity = Vector2.ZERO
var click_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	click_pos = Vector2(player.position.x, player.position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enableminigame:
		if Input.is_action_just_pressed("left_click"):
			click_pos = get_viewport().get_mouse_position()
			var target_pos = (click_pos - player.position).normalized()
			velocity = target_pos * SPEED
		
		# Move the player and stop when close to the target position
		if player.position.distance_to(click_pos) > 3:
			player.velocity = velocity
		else:
			player.velocity = Vector2.ZERO

		player.move_and_slide()

func _unhandled_input(event):
	pass
