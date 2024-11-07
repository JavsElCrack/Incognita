extends SubViewport
@onready var timer = $CanvasLayer/Timer
@onready var progress_bar = $CanvasLayer/ProgressBar
@onready var canvas_layer = $CanvasLayer
@onready var player = $CanvasLayer/Player
@export var SPEED = 300
@export var object_to_spawn: PackedScene
@export var spawn_interval: float = 3.0
@export var audioclips : Array[AudioStreamWAV]
@onready var audiosource = $AudioStreamPlayer
@onready var pickup = $Pickup
@onready var pager_timer = $PagerTimer
@export_multiline var pager_messages : Array[String]
var cooldown = 0.0  
const COOLDOWN_TIME = 5.0  
const MIN_PITCH = 0.2
const MAX_PITCH = 3

var enableminigame = false
var viewport_size 

var player_size = Vector2(64, 64)

func _ready():
	viewport_size = get_visible_rect().size
	viewport_size.x -= 10
	viewport_size.y -= 10
	# Start the spawn timer
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()
	


func _physics_process(delta):
	if GameState.state["MinigameProgress"] > 0:
		if GameState.state["doJob"]:
			GameState.state["MinigameProgress"] -= 0.2 * get_physics_process_delta_time()
		if GameState.state["MinigameProgress"] <= 35 && pager_timer.is_stopped():
			pagerMessages()
		elif GameState.state["MinigameProgress"] > 35:
			if pager_timer.is_stopped() == false:
				pager_timer.stop()
	if cooldown > 0:
		cooldown -= delta
	else:
		if GameState.state["MinigameProgress"] == 30:
			trigger_event()
			cooldown = COOLDOWN_TIME
	
	progress_bar.value = GameState.state["MinigameProgress"]
	if enableminigame:
		var velocity = Vector2.ZERO

		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_just_pressed("move_down") || Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right") || Input.is_action_just_pressed("move_up"):
			play_keyboard()
		if velocity != Vector2.ZERO:
			velocity = velocity.normalized() * SPEED
		player.position += velocity * delta
		var player_size = Vector2(64, 64)
		player.position.x = clamp(player.position.x, 0, viewport_size.x - player_size.x)
		player.position.y = clamp(player.position.y, 0, viewport_size.y - player_size.y)


func _on_Timer_timeout():
	if enableminigame:
		spawn_object()
func play_keyboard():
	if audiosource.playing == true:
		audiosource.stop()
	audiosource.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
	var randomIndex = randi_range(0, audioclips.size() - 1)
	audiosource.stream = audioclips[randomIndex]
	audiosource.play()



func spawn_object():
	if object_to_spawn:
		var instance = object_to_spawn.instantiate()
		canvas_layer.add_child(instance)

		var position_x = randf_range(0, viewport_size.x)
		var position_y = randf_range(0, viewport_size.y)
		instance.position = Vector2(position_x, position_y)
		instance.connect("pickup",play_pickup_sound)


func play_pickup_sound():
	pickup.play()

func trigger_event():
	GameState.mask_dialogue("Better get back to work!")


func pagerMessages():
	if pager_timer.is_stopped() == true:
		pager_timer.start()
func _unhandled_input(event):
	pass


func _on_pager_timer_timeout():
	GameState.pagerMessage(pager_messages.pick_random())
	print("JobProgress%: ",GameState.state["MinigameProgress"] )
