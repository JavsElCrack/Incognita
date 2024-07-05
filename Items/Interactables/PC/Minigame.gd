extends SubViewport

@onready var player =$Player
@export var SPEED = 300
var enableminigame = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enableminigame:
		var velocity = Vector2.ZERO

		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1

		if velocity != Vector2.ZERO:
			velocity = velocity.normalized() * SPEED
		player.velocity = velocity

func _unhandled_input(event):
	pass
