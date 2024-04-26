extends CharacterBody3D

const HIT_STAGGER = 8.0
const RESET_DELAY = 0.5

# export says we want to use it elsewhere
@export var max_speed = 5
@export var jump_speed = 15
@export var fall_acceleration = 25

var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var is_staggered = false


signal player_hit

# start function, awake function
func _ready():
	pass
	
# 
func _physics_process(delta):
	if not is_staggered:
		direction = Vector3.ZERO  # Resetujeme směr na začátku každého cyklu

	# Zpracování vstupu pro pohyb
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()  # Normalizace pro konzistentní rychlost

	# Nastavení cílové rychlosti pouze pokud je aktivní pohyb
	target_velocity.x = direction.x * max_speed
	target_velocity.z = direction.z * max_speed
	
	# Skákání
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		target_velocity.y = jump_speed

	# Pohyb na zemi
	if not is_on_floor():  # Aplikace gravitace
		target_velocity.y -= fall_acceleration * delta

	# Aplikace pohybu
	if direction != Vector3.ZERO or not is_on_floor():
		velocity = target_velocity
	else:
		velocity.x = 0
		velocity.z = 0  # Zastavení pohybu pokud nejsou stisknuta tlačítka pohybu

	move_and_slide()

	

func _input(event):
	pass
			
func hit(dir):
	emit_signal("player_hit")
	direction += dir * HIT_STAGGER
	is_staggered = true
	await get_tree().create_timer(RESET_DELAY).timeout
	is_staggered = false
	direction = Vector3.ZERO
	
