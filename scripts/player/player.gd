extends CharacterBody3D

const HIT_STAGGER = 15
const RESET_DELAY = 0.5

# export says we want to use it elsewhere
@export var max_speed = 5
@export var jump_acceleration = 5
@export var fall_acceleration = 25
@export var max_lives = 3
@onready var current_lives: int = max_lives
@onready var lizard_model = $Lizard

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var is_staggered = false
var jump_released = true


signal player_hit(current_lives)

# start function, awake function
func _ready():
	# initial to set up hearts correctly
	# call deferred because want to have everything intialized
	call_deferred("_emit_player_hit")

func _emit_player_hit():
	emit_signal("player_hit", current_lives)
	
func _physics_process(delta):
	if not is_staggered:
		direction = Vector3.ZERO

	if not is_staggered:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			direction.z += 1
		if Input.is_action_pressed("ui_up"):
			direction.z -= 1
		
		if Input.is_action_pressed("ui_accept") and is_on_floor() and jump_released:
			velocity.y = jump_acceleration
			jump_released = false
		
		if Input.is_action_just_released("ui_accept"):
			jump_released = true

	direction = direction.normalized()
	if direction != Vector3.ZERO:
		lizard_model.look_at(lizard_model.global_transform.origin + direction, Vector3.UP)

	velocity.x = direction.x * max_speed
	velocity.z = direction.z * max_speed
	# gravity
	velocity.y -= fall_acceleration * delta
		
	if direction == Vector3.ZERO:
		velocity.x = 0
		velocity.z = 0  # stop the movement

	move_and_slide()	

func _input(event):
	pass
			
func hit(dir):
	# decrease health
	current_lives -= 1
	emit_signal("player_hit", current_lives)
	
	if direction != Vector3.ZERO:
		direction += dir * HIT_STAGGER
	else:
		direction += Vector3(1,1,0) * HIT_STAGGER * dir
	is_staggered = true
	await get_tree().create_timer(RESET_DELAY).timeout
	is_staggered = false
	direction = Vector3.ZERO


func _on_player_hit(current_lives):
	pass # Replace with function body.
