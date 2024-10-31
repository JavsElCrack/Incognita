extends Sprite2D
@onready var sub_viewport = $Node3D/SubViewport
@onready var sub_viewport2 = $"Node3D/Gold Apollo AR924/MeshInstance3D/SubViewport"
@onready var mesh_instance_3d = $"Node3D/Gold Apollo AR924/MeshInstance3D"
@onready var pager = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_viewport_mat(mesh_instance_3d,sub_viewport2)
	_set_viewport_material(pager,sub_viewport)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _set_viewport_mat(_display_mesh : MeshInstance3D, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = StandardMaterial3D.new()
	_mat.albedo_texture = _sub_viewport.get_texture()
	_display_mesh.set_surface_override_material(_surface_id, _mat)

func _set_viewport_material(_display_mesh : Object, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = StandardMaterial3D.new()
	_mat.albedo_texture = _sub_viewport.get_texture()
	_display_mesh = _display_mesh as Sprite2D
	_display_mesh.texture = _mat
