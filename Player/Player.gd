class_name Player extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0
var initialHeadRot
var lockmovement = false
var isinDialogue = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var head = $Head
@onready var mesh = $Mesh
@onready var lookat = $Head/Lookat
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/RayCast3D
@onready var maskui = $MaskUi
@onready var crosshair = $Head/Crosshair
@onready var anim_tree = $AnimationTree
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion && !lockmovement:
		head.rotate_y(-event.relative.x*SENSITIVITY)
		camera.rotate_x(-event.relative.y*SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70),deg_to_rad(70))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() && !lockmovement:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction && !lockmovement:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#Head bob
	t_bob += delta*velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#Animation
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
	pos.y = sin((time*BOB_FREQ))*BOB_AMP
	pos.x = cos(time*BOB_FREQ/2)*BOB_AMP
	return pos

func lockmovement_and_look(body :Object):
	initialHeadRot = $Head/Camera3D.rotation
	#$Head/Camera3D.look_at(body.position)
	#$Head/Camera3D.rotate_object_local(Vector3(0,1,0), 3.14)
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


func _on_text_box_dialogue_started():
	pass


func mask_dialogue(text : String):
	maskui.mask_dialogue(text)


func _on_text_box_dialogue_ended():
	lockmovement = false
	isinDialogue = false
	#$Head/Camera3D.rotation = initialHeadRot
	raycast.isInDialogue = false
