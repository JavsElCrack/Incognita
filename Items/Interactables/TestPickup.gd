extends Interactable
class_name PickUp

@export var stateString: String
@export var PickUpDialogue: String
func _on_interacted(body):
	print("Interacted with", body)
	if body.is_in_group("player"):
		print("Body is player")
		GameState.state[stateString] += 1
		if GameState.state[stateString] == 1:
			GameState.mask_dialogue(PickUpDialogue)
	queue_free()
