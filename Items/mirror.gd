extends Node3D

var flag1 = true
var flag2 = true
var playerInArea = false
@onready var mesh_instance_3d = $MeshInstance3D
@onready var sub_viewport = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_viewport_mat(mesh_instance_3d,sub_viewport)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	if playerInArea && Input.is_action_just_pressed("emote") && flag2 == true:
#		GameState.mask_dialogue("Too much FLOWWW")
#		flag2 = false
#		await get_tree().create_timer(4.0).timeout
#		if Input.is_action_pressed("emote"):
#			GameState.mask_dialogue("Ohhhh YEAHHH!")
#			await get_tree().create_timer(4.0).timeout
#			if Input.is_action_pressed("emote"):
#				GameState.mask_dialogue("Kill Em!")

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		if flag1:
			GameState.mask_dialogue("Looking Sharp")
			flag1 = false
		playerInArea = true
	
func _set_viewport_mat(_display_mesh : MeshInstance3D, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = StandardMaterial3D.new()
	_mat.albedo_texture = _sub_viewport.get_texture()
	_display_mesh.set_surface_override_material(_surface_id, _mat)



func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
		flag2 = true
