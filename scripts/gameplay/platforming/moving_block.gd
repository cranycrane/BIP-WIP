extends CharacterBody3D

@export var signal_emitter_path: NodePath
@export var moving_time: float = 2.0
@export var move_speed = 0.5
@export var moving_limit = 1

enum Directions {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	FORWARD,
	BACKWARD
}

var default_velocity = Vector3.ZERO
var current_move_num = 0
var is_moving = false

func _ready():
	$MoveTimer.wait_time = moving_time
	var signal_emitter = get_node(signal_emitter_path)
	if signal_emitter:
		signal_emitter.connect("move_signal", move_block)

func _physics_process(delta):
	if not $MoveTimer.is_stopped() and is_moving:
		move_and_slide()

func move_block(direction: int):
	is_moving = true
	if current_move_num == moving_limit:
		return
	match direction:
		Directions.UP:
			velocity.y = move_speed
		Directions.DOWN:
			velocity.y = -move_speed
		Directions.LEFT:
			velocity.x = -move_speed
		Directions.RIGHT:
			velocity.x = move_speed
		Directions.FORWARD:
			velocity.z = -move_speed
		Directions.BACKWARD:
			velocity.z = move_speed
	
	$MoveTimer.start()
	current_move_num += 1

func stop_block():
	is_moving = false
	velocity = Vector3.ZERO

func _on_move_timer_timeout():
	stop_block()
