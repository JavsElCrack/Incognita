extends Node3D

var flag1 = true
var flag2 = true
var playerInArea = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SubViewport/Camera3D.transform = transform
	if playerInArea && Input.is_action_just_pressed("emote") && flag2 == true:
		GameState.mask_dialogue("Too much FLOWWW")
		flag2 = false
		await get_tree().create_timer(4.0).timeout
		if Input.is_action_pressed("emote"):
			GameState.mask_dialogue("Ohhhh YEAHHH!")
			await get_tree().create_timer(4.0).timeout
			if Input.is_action_pressed("emote"):
				GameState.mask_dialogue("Kill Em!")

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if flag1:
			GameState.mask_dialogue("Looking Sharp")
			flag1 = false
		playerInArea = true
	


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
		flag2 = true
