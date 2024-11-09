extends CanvasLayer
signal ps1filter
var creditsToggle = false
var filterToggle = true
var settingToggle = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_quit_button_down():
	get_tree().quit()


func _on_settings_button_down():
	if settingToggle:
		$Settings.visible = true
		settingToggle = false
	else:
		$Settings.visible = false
		settingToggle = true


func _on_ps_1_filter_button_down():
	if filterToggle:
		GameState.state["settings"]["ps1filter"] = true
		filterToggle = false
		$"Settings/ps1 filter".text = " ps1 filter [on]"
		ps1filter.emit()
	else:
		GameState.state["settings"]["ps1filter"] = false
		filterToggle = true
		$"Settings/ps1 filter".text = " ps1 filter [off]"
		ps1filter.emit()



	


func _on_h_slider_value_changed(value):
	GameState.state["settings"]["sensitivity"] = value
