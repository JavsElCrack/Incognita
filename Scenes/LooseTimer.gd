extends Timer
@export var ignoreWork : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameState.state["MinigameProgress"] <= 0 && self.is_stopped() == true:
		self.start()
		GameState.mask_dialogue("We should get 
	back to work")


func _on_timeout():
	if GameState.state["MinigameProgress"] <= 0 && !ignoreWork:
		get_tree().change_scene_to_file("res://Scenes/Loosemenu.tscn")
	else:
		self.stop()
