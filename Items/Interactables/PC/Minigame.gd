extends SubViewport

@onready var player = $Player
@export var SPEED = 300
@export var object_to_spawn: PackedScene
@export var spawn_interval: float = 3.0
@onready var timer = $Timer
@onready var progress_bar = $ProgressBar

var enableminigame = false
		# Get the viewport size
var viewport_size 

var player_size = Vector2(64, 64)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the viewport size
	viewport_size = get_visible_rect().size
	# Start the spawn timer
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

# Function to spawn an object
func spawn_object():
	if object_to_spawn:
		var instance = object_to_spawn.instantiate()
		add_child(instance)

		# Set a random position within the viewport
		var position_x = randf_range(0, viewport_size.x)
		var position_y = randf_range(0, viewport_size.y)
		instance.position = Vector2(position_x, position_y)

func _unhandled_input(event):
	pass
