extends CharacterBody3D

const HIT_STAGGER = 15
const RESET_DELAY = 0.5

# export says we want to use it elsewhere
@export var max_lives = 3
@export var max_speed = 2

@export var jump_acceleration = 5
@export var fall_acceleration = 25
@export var attack_rotate_speed = 5
@export var attack_damage = 1
@export var attack_knockback = 10
@export var attack_cooldown = 2


@onready var current_lives: int = max_lives
@onready var lizard_model = $Lizard
@onready var attack_timer = $AttackTimer

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO

var is_staggered = false
var jump_released = true
var is_attacking = false
var can_attack = false
var enemy_attack_cooldown = false
var enemies_in_range = []

signal player_hit(current_lives)

# start function, awake function
func _ready():
	# initial to set up hearts correctly
	# call deferred because want to have everything intialized
	call_deferred("_emit_player_hit")
	attack_timer.wait_time = attack_cooldown

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
		
		if Input.is_action_pressed("ui_jump") and is_on_floor() and jump_released:
			velocity.y = jump_acceleration
			jump_released = false
		
		if Input.is_action_just_released("ui_jump"):
			jump_released = true
			
		if Input.is_action_pressed("ui_attack") and attack_timer.is_stopped() and not is_attacking:
			is_attacking = true
			print("ATTACKING")
			if len(enemies_in_range) > 0:
				print("DEALING DAMAGE TO ENEMY")
				attack()
			attack_timer.start()
				
		if Input.is_action_just_released("ui_attack"):
			is_attacking = false

	direction = direction.normalized()
	if direction != Vector3.ZERO:
		lizard_model.look_at(lizard_model.global_transform.origin + direction, Vector3.UP)
	
	# gravity
	velocity.y -= fall_acceleration * delta
		
	if direction == Vector3.ZERO:
		velocity.x = 0
		velocity.z = 0  # stop the movement
	else:
		velocity.x = direction.x * max_speed
		velocity.z = direction.z * max_speed
		

	move_and_slide()	

func attack():
	for enemy in enemies_in_range:
		var dir = global_position.direction_to(enemy.global_position)
		enemy.hit(direction, attack_damage, attack_knockback)
		
func hit(dir):
	print("GETTING HIT")
	return
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

func player():
	pass

func _on_player_hit(current_lives):
	pass # Replace with function body.

func _on_player_hit_box_body_entered(body):		
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)

func _on_player_hit_box_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)

func _on_attack_timer_timeout():
	print("TIMER TIMEOUT")
