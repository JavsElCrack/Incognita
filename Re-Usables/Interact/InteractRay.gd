extends RayCast3D

@export var isInDialogue = false
@export var showPrompt = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Prompt.text = ""
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable and isInDialogue == false:
			if showPrompt:
				$Prompt.text =collider.get_prompt()
			if Input.is_action_just_pressed(collider.prompt_input):
				collider.interact(owner)
