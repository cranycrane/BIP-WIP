extends AnimatableBody3D

@export var signal_emitter_path: NodePath
@export var time = 3
@export var moving_limit = 1
@export var vector3: Vector3 #distance to travel to

var default_velocity = Vector3.ZERO
var current_move_num = 0
var at_start = true
var player = null
var original_parent = null

var moving = false
@onready var allowed = get_node("HUD")


func move_block(body):
	if body.name == "Player":
		if allowed:
			moving = true
			var tween = get_tree().create_tween()
			if at_start:
				tween.tween_property(self, "global_position", global_position + vector3, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT) #last value are seconds
				at_start = false
			else:
				tween.tween_property(self, "global_position", global_position - vector3, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
				at_start = true
