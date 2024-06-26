extends Node3D

var flag1 = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameState.state["TestPickup"] > 0 && flag1 == true:
		mask_dialogue("That could be useful")
		flag1 = false
	


func mask_dialogue(text: String):
	$Control/TextureRect/TextBox.display_text(text)
