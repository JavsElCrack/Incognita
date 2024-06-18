extends CollisionObject3D
class_name Interactable

signal interacted(body)
@export var enabled := true
@export var prompt_message = "Interact"
@export var prompt_input = "interact"
# Called when the node enters the scene tree for the first time.

func get_prompt():
	if not enabled:
		return ""
	var key_name = ""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break
	return prompt_message + "\n[" + key_name + "]"

func _interact(body):
	if not enabled:
		return
	interacted.emit(body)
