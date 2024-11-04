extends Area2D

signal pickup

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the "body_entered" signal to a function
	connect("body_entered",_on_body_entered)

# Called when another body enters the StaticBody2D's collision area
func _on_body_entered(body):
	# Check if the body is the player
	if body.is_in_group("2dplayer"):
		if GameState.state["MinigameProgress"]+20 >= 100:
			GameState.state["MinigameProgress"]= 100
		else:
			GameState.state["MinigameProgress"]+=20
		
		pickup.emit()
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
