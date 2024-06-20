extends CollisionObject3D
class_name Interactable

signal interacted(_body)
@export var enabled := true
@export var prompt_message = "Interact"
@export var prompt_input = "interact"

func get_prompt():
	if not enabled:
		return ""
	var key_name = ""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break
	return prompt_message + "\n[" + key_name + "]"

func interact(_body):
	if not enabled:
		return
	print("Interacting with", _body)
	interacted.emit(_body)
