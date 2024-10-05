extends Interactable
@onready var animation_tree = $AnimationTree
@export var checkFlag = false
@export var flagString : String
var doorOpen = false




func _on_interacted(_body):
	if checkFlag:
		if GameState.state["flags"]["Door"][flagString] == true:
			toggleDoor()
		else:
			GameState.mask_dialogue("It's Locked")
	else:
		toggleDoor()




func toggleDoor():
	if doorOpen:
		animation_tree.set("parameters/conditions/open",false)
		animation_tree.set("parameters/conditions/closed",true)
		doorOpen = false
	else:
		animation_tree.set("parameters/conditions/open",true)
		animation_tree.set("parameters/conditions/closed",false)
		doorOpen = true
