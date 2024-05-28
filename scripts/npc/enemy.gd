extends CharacterBody3D

var player = null

const SPEED = 4.0
const ATTACK_RANGE = 1.5

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var hit_timer = $HitTimer  # Reference to the Timer node

func _ready():
	player = get_node(player_path)
	hit_timer.wait_time = 1.0  # Set the timer to 2 seconds
	#hit_timer.one_shot = false  # Make sure the timer repeats
	#hit_timer.start()

func _process(delta):
	if not hit_timer.is_stopped():
		return
	
	velocity = Vector3.ZERO
	
	# Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	# which way is enemy looking at player
	# uncomment when enemy model ready
	# look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# @todo animation running etc
	
	if _target_in_range():
		_hit_finished()
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _hit_finished():
	if hit_timer.is_stopped():
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
		hit_timer.start()
