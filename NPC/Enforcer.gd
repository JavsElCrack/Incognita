extends CharacterBody3D
@onready var animation_tree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
@export var target : Node3D
@export var wanderArea : Area3D
@onready var ray_cast_3d = $RayCast3D
@onready var raycast_break_timer = $RaycastBreakTimer
var playerInDetect = false
var raycastPlayer = false
var player : Player
var last_seen_location: Vector3
var last_seen_node := Node3D.new()
const chaseSPEED = 4
const walkSpeed = 2
enum states {
	IDLE,
	WANDER,
	ENRAGE,
	SEARCH,
	CHASE,
}
@export var  state = states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(last_seen_node)
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		states.IDLE:
			idle()
		states.WANDER:
			wander(delta)
		states.ENRAGE:
			enrage(delta)
		states.SEARCH:
			search(delta)
		states.CHASE:
			chase(delta)
	if ray_cast_3d.is_colliding():
		var body = ray_cast_3d.get_collider()
		if body.is_in_group("player"):
			raycastPlayer = true
			last_seen_location = body.global_position
			last_seen_location.y = global_transform.origin.y
			last_seen_node.global_position = last_seen_location
		else:
			raycastPlayer = false
	else :
		raycastPlayer = false




func idle():
#	print("IDLE")
	animation_tree.set("parameters/conditions/notRun",true)
	animation_tree.set("parameters/conditions/notwalk",true)
	animation_tree.set("parameters/conditions/walk",false)
	animation_tree.set("parameters/conditions/run",false)

func enrage(delta):
#	print("ENRAGE")
	update_target_location(target)
	animation_tree.set("parameters/conditions/scream", true)
	await get_tree().create_timer(2).timeout
	animation_tree.set("parameters/conditions/scream", false)
	animation_tree.set("parameters/conditions/walk", true)
	animation_tree.set("parameters/conditions/run", true)
	animation_tree.set("parameters/conditions/notRun", false)
	animation_tree.set("parameters/conditions/notwalk", false)
	var current_location = global_transform.origin
	var next_location = (nav_agent as NavigationAgent3D).get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * chaseSPEED
	lookatPlayer()
	velocity = velocity.move_toward(new_velocity, 0.25)
	move_and_slide()
	state = states.CHASE

func wander(delta):
	pass


func search(delta):
#	print("SEARCH")
	if global_transform.origin.distance_to(last_seen_location) > 1.0:
		rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 10)
		update_target_location(last_seen_node)
		animation_tree.set("parameters/conditions/walk", true)
		animation_tree.set("parameters/conditions/run", false)
		animation_tree.set("parameters/conditions/notRun", true)
		animation_tree.set("parameters/conditions/notwalk", false)
		var current_location = global_transform.origin
		var new_velocity = (last_seen_location - current_location).normalized() * walkSpeed
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()
	else:
		state = states.IDLE

func chase(delta):
	print("CHASE")
	if raycastPlayer:
		chaseMovement()
		raycast_break_timer.stop()
	else:
		chaseMovement()
		if raycast_break_timer.is_stopped():
			raycast_break_timer.start()
			print("TIMERSTARTED")


func chaseMovement():
	animation_tree.set("parameters/conditions/scream", false)
	animation_tree.set("parameters/conditions/walk", true)
	animation_tree.set("parameters/conditions/run", true)
	animation_tree.set("parameters/conditions/notRun", false)
	animation_tree.set("parameters/conditions/notwalk", false)
	lookatPlayer()
	update_target_location(target)
	var current_location = global_transform.origin
	var next_location = (nav_agent as NavigationAgent3D).get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * chaseSPEED
	velocity = velocity.move_toward(new_velocity, 0.25)
	move_and_slide()

func update_target_location(target_location:Node3D):
	(nav_agent as NavigationAgent3D).target_position = target_location.global_position
	
func lookatPlayer():
	var target_position = player.global_transform.origin
	target_position.y = global_transform.origin.y  
	look_at(global_transform.origin - (target_position - global_transform.origin), Vector3.UP)



func _on_detect_area_body_entered(body):
	if body.is_in_group("player") && state != states.CHASE:
		playerInDetect = true
		target = body
		last_seen_location = body.global_position
		last_seen_location.y = global_transform.origin.y
		last_seen_node.global_position = last_seen_location
		state = states.ENRAGE


func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		state = states.IDLE



func _on_raycast_break_timer_timeout():
	print("TIMER EXPIRED")
	raycast_break_timer.stop()
	if !raycastPlayer && !playerInDetect:
		state = states.SEARCH
	


func _on_detect_area_body_exited(body):
	if body.is_in_group("player"):
		playerInDetect = false
