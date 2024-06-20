extends Interactable
class_name PickUp

@export var stateString: String

func _on_interacted(body):
	print("Interacted with", body)
	if body.is_in_group("player"):
		print("Body is player")
		(body as Player).state[stateString] += 1
	queue_free()
