extends CharacterBody3D

const ATTACK_RANGE = 1

@export var speed = 4.0
@export var player_path : NodePath

@export var follow_distance: float = 12.0
@export var return_distance: float = 10.0
@onready var nav_agent = $NavigationAgent3D
@onready var hit_timer = $HitTimer  # Reference to the Timer node

var original_position: Vector3
var player = null

func _ready():
	player = get_node(player_path)
	original_position = global_transform.origin
	hit_timer.wait_time = 1.0

func _process(delta):
	if not hit_timer.is_stopped():
		return
		
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	
	velocity = Vector3.ZERO
	
	if distance_to_player < follow_distance:
		follow_player()
	elif distance_to_player > return_distance:
		return_to_position()
	
	# which way is enemy looking at player
	# uncomment when enemy model ready
	# look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# @todo animation running etc
	
	if _target_in_range():
		_hit_finished()
	
	move_along_path(delta)
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func follow_player():
	nav_agent.set_target_position(player.global_transform.origin)

func return_to_position():
	nav_agent.set_target_position(original_position)
	
func move_along_path(delta: float):
	# Navigation
	# nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
func _hit_finished():
	if hit_timer.is_stopped():
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
		hit_timer.start()
