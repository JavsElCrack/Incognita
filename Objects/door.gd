extends Interactable
@onready var animation_tree = $AnimationTree
@onready var label = $MeshInstance3D/SubViewport/Label
@onready var mesh_instance_3d = $MeshInstance3D
@onready var sub_viewport = $MeshInstance3D/SubViewport
@export var checkFlag = false
@export var flagString : String
@export var doorNumber : String
var doorOpen = false

func _ready():
	print("Label reference for doorNumber:", doorNumber, label)
#	label.text = doorNumber
	_set_viewport_mat(mesh_instance_3d, sub_viewport)

func _on_interacted(_body):
	if checkFlag:
		if GameState.state["flags"]["Door"][flagString] == true:
			toggleDoor()
		else:
			GameState.mask_dialogue("It's Locked")
	else:
		toggleDoor()


func _set_viewport_mat(_display_mesh : MeshInstance3D, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = mesh_instance_3d.get_active_material(0)
	_mat.albedo_texture = _sub_viewport.get_texture()
	_display_mesh.set_surface_override_material(_surface_id, _mat)



func toggleDoor():
	if doorOpen:
		animation_tree.set("parameters/conditions/open",false)
		animation_tree.set("parameters/conditions/closed",true)
		doorOpen = false
	else:
		animation_tree.set("parameters/conditions/open",true)
		animation_tree.set("parameters/conditions/closed",false)
		doorOpen = true
