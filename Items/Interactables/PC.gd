extends Interactable
var playercam
@onready var pccam = $Camera3D
@onready var screen = $Computer/Computer/RootNode/PC/Screen
@onready var sub_viewport = $SubViewport
var player
var toggle = false
var checkTransition = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_viewport_mat(screen,sub_viewport)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if toggle  && Input.is_action_just_pressed("interact"):
		pass
	if checkTransition:
		if CameraTransition.transitioning == false:
			(player as Player).lockmovement = false
			checkTransition = false

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
			checkTransition = true
			(body as Player).crosshair.visible = true
			GameState.state["enableMinigame"] = false
			sub_viewport.enableminigame = false
			toggle = false
func _set_viewport_mat(_display_mesh : MeshInstance3D, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = StandardMaterial3D.new()
	_mat.albedo_texture = _sub_viewport.get_texture()
	_display_mesh.set_surface_override_material(_surface_id, _mat)


