extends CharacterBody3D

@export var signal_emitter_path: NodePath
@export var moving_time: float = 2.0

enum Directions {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	FORWARD,
	BACKWARD
}

var move_speed = 5.0
var default_velocity = Vector3.ZERO


func _ready():
	$MoveTimer.wait_time = moving_time
	var signal_emitter = get_node(signal_emitter_path)
	if signal_emitter:
		signal_emitter.connect("move_signal", move_block)

func _physics_process(delta):
	move_and_slide()

func move_block(direction: int):
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

func stop_block():
	velocity = Vector3.ZERO

func _on_move_timer_timeout():
	stop_block()
