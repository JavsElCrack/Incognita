extends Interactable
var playercam
@onready var pccam = $Camera3D
@onready var sub_viewport = $SubViewport
var player
var toggle = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if toggle  && Input.is_action_just_pressed("interact"):
		pass

func _on_interacted(body):
	if body.is_in_group("player"):
		playercam = (body as Player).camera
		player = body
		if toggle == false:
			print("Player to PC")
			CameraTransition.transition_camera(playercam,pccam,2)
			(body as Player).raycast.showPrompt = false
			(body as Player).lockmovement = true
			(body as Player).crosshair.visible = false
			GameState.state["enableMinigame"] = true
			sub_viewport.enableminigame = true
			toggle = true
		else:
			print("PC to Player")
			CameraTransition.transition_camera(pccam,playercam,2)
			(body as Player).raycast.showPrompt = true
			(body as Player).lockmovement = false
			(body as Player).crosshair.visible = true
			GameState.state["enableMinigame"] = false
			sub_viewport.enableminigame = false
			toggle = false


