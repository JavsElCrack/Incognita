class_name PickUp extends Interactable

var firstTimePickup = true
@export var stateString: String
@export_multiline var PickUpDialogue: String

func _on_interacted(body):
	print("Interacted with", body)
	if body.is_in_group("player"):
		print("Body is player")
		if GameState.state.has(stateString):  # Ensure the key exists
			match typeof(GameState.state[stateString]):
				TYPE_BOOL:
					GameState.state[stateString] = not GameState.state[stateString]
				TYPE_INT:
					GameState.state[stateString] += 1
				TYPE_DICTIONARY:
					pass
				TYPE_NIL:
					pass
		else:
			print("Key does not exist in GameState.state:", stateString)
		if firstTimePickup:
			GameState.mask_dialogue(PickUpDialogue)
			firstTimePickup = false
	queue_free()
