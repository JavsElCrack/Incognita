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
# Called every frame. 'delta' is the elapsed time since the previous frame.
var cooldown = 0.0  # Variable to track cooldown time
const COOLDOWN_TIME = 5.0  # 5 seconds cooldown

const MIN_PITCH = 0.2
const MAX_PITCH = 3

var enableminigame = false
		# Get the viewport size
var viewport_size 

var player_size = Vector2(64, 64)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the viewport size
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
		GameState.state["MinigameProgress"] -= 0.4 * get_physics_process_delta_time()
	# Decrease cooldown over time
	if cooldown > 0:
		cooldown -= delta
	else:
		# Check if the MinigameProgress is 0.3 and cooldown has elapsed
		if GameState.state["MinigameProgress"] == 30:
			# Call your custom function and reset the cooldown
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

		# Update player position
		player.position += velocity * delta

		# Assuming the player has a defined size (e.g., 64x64 pixels)
		var player_size = Vector2(64, 64)

		# Clamp the player position to stay within the viewport boundaries
		player.position.x = clamp(player.position.x, 0, viewport_size.x - player_size.x)
		player.position.y = clamp(player.position.y, 0, viewport_size.y - player_size.y)

# Called every time the timer times out
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


# Function to spawn an object
func spawn_object():
	if object_to_spawn:
		var instance = object_to_spawn.instantiate()
		canvas_layer.add_child(instance)

		# Set a random position within the viewport
		var position_x = randf_range(0, viewport_size.x)
		var position_y = randf_range(0, viewport_size.y)
		instance.position = Vector2(position_x, position_y)
		instance.connect("pickup",play_pickup_sound)
func play_pickup_sound():
	pickup.play()

func trigger_event():
	GameState.mask_dialogue("Better get back to work!")

func _unhandled_input(event):
	pass
