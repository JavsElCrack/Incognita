extends Node3D
var creditsToggle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_play_button_down():
	get_tree().change_scene_to_file("res://Scenes/Intro.tscn") # Replace with function body.


func _on_credits_button_down():
	if creditsToggle:
		$Camera3D/Control/ScrollContainer.visible = false
		creditsToggle = false
	else:
		$Camera3D/Control/ScrollContainer.visible = true
		creditsToggle = true


func _on_quit_button_down():
	get_tree().quit()
