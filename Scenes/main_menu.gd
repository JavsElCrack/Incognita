extends Node3D
var creditsToggle = false
var filterToggle = true
var settingToggle = true
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


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


func _on_settings_button_down():
	if settingToggle:
		$Camera3D/Control/Settings.visible = true
		settingToggle = false
	else:
		$Camera3D/Control/Settings.visible = false
		settingToggle = true


func _on_ps_1_filter_button_down():
	if filterToggle:
		GameState.state["settings"]["ps1filter"] = true
		filterToggle = false
		$"Camera3D/Control/Settings/ps1 filter".text = " ps1 filter [on]"
	else:
		GameState.state["settings"]["ps1filter"] = false
		filterToggle = true
		$"Camera3D/Control/Settings/ps1 filter".text = " ps1 filter [off]"



	


func _on_h_slider_value_changed(value):
	GameState.state["settings"]["sensitivity"] = value
