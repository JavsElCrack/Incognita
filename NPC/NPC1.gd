class_name NPC extends Interactable
const SPEED = 3.0
@onready var npc = $"."
@export_category("Dialogue")
@export var textbox : Textbox
@export var dialogue_json : JSON
@export var voiceID : int
@export_category("Navigation")
@export var follow_target = false
@export var lookatPos : Node3D
@export var target : Node3D
@onready var nav_agent = $NavigationAgent3D
@onready var state= {}
@onready var statemachine = $AnimationTree
var isInDialogue = false
func _ready():
	connect("interacted",_on_interacted)

func _physics_process(delta):
	if follow_target:
		update_target_location(target)
	if npc.velocity == Vector3.ZERO:
		statemachine.set("parameters/conditions/notwalk",true)
		statemachine.set("parameters/conditions/walk",false)
	else:
		statemachine.set("parameters/conditions/notwalk",false)
		statemachine.set("parameters/conditions/walk",true)
	if !isInDialogue:
		var current_location = global_transform.origin
		var next_location = (nav_agent as NavigationAgent3D).get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		rotation.y = lerp_angle(rotation.y,atan2(-npc.velocity.x,-npc.velocity.z),delta*10)
		npc.velocity = npc.velocity.move_toward(new_velocity,0.25)
	else:
		statemachine.set("parameters/conditions/notwalk",true)
		statemachine.set("parameters/conditions/walk",false)
	npc.move_and_slide()

func _on_interacted(body):
	isInDialogue = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	textbox.visible = true
	if body.is_in_group("player"):
		(textbox as Textbox).voiceid = voiceID
		(textbox.get_child(4) as EzDialogue).start_dialogue(dialogue_json,GameState.state)
		(body as Player).lockmovement_and_look(lookatPos)
		var initialrot = self.rotation
		var lookatRot
		self.look_at(body.position)
		lookatRot = self.rotation
		self.rotation = initialrot
		self.rotation.y = lookatRot.y
		print("Dialogue Started")

func update_target_location(target_location:Node3D):
	(nav_agent as NavigationAgent3D).target_position = target_location.global_position
	
