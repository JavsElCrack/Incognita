class_name Player extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
@export var hasFlashlight = false
var t_bob = 0.0
var initialHeadRot
var lockmovement = false
var isinDialogue = false
var blackScreenToggle = true
var playFootsteps = false
var pause = false
var resetMouse = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var head = $Head
@onready var mesh = $Mesh
@onready var lookat = $Head/Lookat
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/RayCast3D
@onready var maskui = $MaskUi
@onready var crosshair = $Head/Crosshair
@onready var anim_tree = $AnimationTree
@onready var pager = $CanvasLayer/pager/SubViewport
@onready var chromatic_chaos = $"CanvasLayer/chromatic chaos"
@onready var posterization = $CanvasLayer/Posterization
@onready var audio_stream_player = $AudioStreamPlayer
@onready var pause_menu = $"CanvasLayer/Pause Menu"
@onready var ps_1_post_processing = $CanvasLayer/PS1PostProcessing
@onready var flashlight = $Head/Camera3D/Flashlight

@export_category("Sound")
@export var footsteps : Array[Array]
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GameState.state["settings"]["ps1filter"]:
		ps_1_post_processing.visible = true

func _unhandled_input(event):
	if event is InputEventMouseMotion && !lockmovement &&!pause:
		head.rotate_y(-event.relative.x*GameState.state["settings"]["sensitivity"])
		camera.rotate_x(-event.relative.y*GameState.state["settings"]["sensitivity"])
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70),deg_to_rad(70))

func _physics_process(delta):
	playFootsteps = false
	if not is_on_floor():
		velocity.y -= gravity * delta
	

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() && !lockmovement:
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("flashlight") and hasFlashlight:
		toggleFlashlight()

	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction && !lockmovement:
		playFootsteps = true
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		

	t_bob += delta*velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	

	mesh.look_at(Vector3(lookat.global_position.x,global_position.y,lookat.global_position.z))
	
	anim_tree.set("parameters/conditions/idle",input_dir == Vector2.ZERO && is_on_floor() && !Input.is_action_pressed("emote"))
	anim_tree.set("parameters/conditions/walk",(input_dir.y == 1 || input_dir.y == -1) && is_on_floor())
	anim_tree.set("parameters/conditions/strafeLeft",input_dir.x == -1 && is_on_floor())
	anim_tree.set("parameters/conditions/strafeRight",input_dir.x == 1 && is_on_floor())
	anim_tree.set("parameters/conditions/dance",Input.is_action_pressed("emote") && is_on_floor())
	anim_tree.set("parameters/conditions/falling",!is_on_floor())
	anim_tree.set("parameters/conditions/landed",is_on_floor())
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin((time * BOB_FREQ)) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	if pos.y < -0.05 and !audio_stream_player.is_playing() && playFootsteps:  
		audio_stream_player.stream = footsteps[0].pick_random()
		audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
		audio_stream_player.play()
		
	return pos


	

func lockmovement_and_look(body :Object,rotateplayer : bool):
	initialHeadRot = $Head/Camera3D.rotation
	#$Head/Camera3D.look_at(body.position)
	#$Head/Camera3D.rotate_object_local(Vector3(0,1,0), 3.14)
	if rotateplayer:
		$Head/Camera3D.rotation.x = 0
	lockmovement = true
	isinDialogue = true
	raycast.isInDialogue = true

func lockmovementP():
	lockmovement = true
	isinDialogue = true
	raycast.isInDialogue = true

func unlockmovementP():
	lockmovement = false
	isinDialogue = false
	raycast.isInDialogue = false

func toggleFlashlight():
	if flashlight.visible == true:
		flashlight.visible = false
	else:
		flashlight.visible = true


func _on_text_box_dialogue_started():
	pass


func mask_dialogue(text : String):
	maskui.mask_dialogue(text)


func _on_text_box_dialogue_ended():
	lockmovement = false
	isinDialogue = false
	#$Head/Camera3D.rotation = initialHeadRot
	raycast.isInDialogue = false


func toggleBlackScreen():
	if blackScreenToggle:
		$CanvasLayer/Black.visible = true
		blackScreenToggle = false
	else:
		$CanvasLayer/Black.visible = false
		blackScreenToggle = true

#Pager Message


func pagerMessage(message : String):
	pager.updatePagerText(message)
	pager.slidein()
	chromatic_chaos.visible = true
	await get_tree().create_timer(5).timeout
	pager.slideout()
	chromatic_chaos.visible = false

func tween_effect_strength(duration: float) -> void:
	posterization.visible = true
	posterization.material.set_shader_parameter("effect_strength", 0.0)
	var tween = get_tree().create_tween()
	tween.tween_property(posterization.material, "shader_parameter/effect_strength",1 , duration)

func pauseMenu():
	if pause:
		pause_menu.visible = false
		Engine.time_scale = 1
		if resetMouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			resetMouse = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		pause_menu.visible = true
		Engine.time_scale = 0
	
	pause = !pause



func _on_pause_menu_ps_1_filter():
	if GameState.state["settings"]["ps1filter"]:
		ps_1_post_processing.visible = true
	else:
		ps_1_post_processing.visible = false
