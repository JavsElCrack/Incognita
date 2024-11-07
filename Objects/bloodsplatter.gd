@tool
class_name BloodSplatter extends MeshInstance3D
signal bloodsplatterEnd
@onready var mesh_instance_3d = $"."
@onready var sub_viewport = $SubViewport
@onready var video_stream_player = $SubViewport/Camera2D/VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_viewport_mat(mesh_instance_3d,sub_viewport)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _set_viewport_mat(_display_mesh : MeshInstance3D, _sub_viewport : SubViewport, _surface_id : int = 0):
	var _mat : StandardMaterial3D = StandardMaterial3D.new()
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.albedo_texture = _sub_viewport.get_texture()

	_display_mesh.set_surface_override_material(_surface_id, _mat)
	_display_mesh.get_surface_override_material(_surface_id).TRANSPARENCY_ALPHA

func play():
	video_stream_player.play()

#
func _on_video_stream_player_finished():
	bloodsplatterEnd.emit()
