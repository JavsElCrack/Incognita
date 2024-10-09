extends Node3D
var flag1 = true
var flag2 = true
var playerInArea = false
@onready var hallwaymarker = $TeleportHallway/hallwaymarker

func _ready():
	GameState.mask_dialogue("Use WASD to move
		 and E to interact")

func _on_ez_dialogue_custom_signal_received(value):
	match value:
		"neilFirstTime":
			GameState.state["flags"]["Neil"]["firsttime"] = false
		"removeGift":
			GameState.state["flags"]["Neil"]["gift"] = false




func _on_pass_word_viewport_correctpass():
	GameState.state["flags"]["John"]["readNeilEmail"] = true


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if flag1:
			GameState.mask_dialogue("This is your computer
			 the password is: password")
			flag1 = false
		playerInArea = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
		flag2 = true


func _on_teleport_hallway_body_entered(body):
	if body.is_in_group("player"):
		body.global_position.z = hallwaymarker.global_position.z
