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

func move_block(body):
	if body.name == "Player" and not player:
		player = body
		original_parent = player.get_parent()
		player.get_parent().remove_child(player)
		add_child(player)
		var tween = get_tree().create_tween()
		if at_start:
			tween.tween_property(self, "global_position", global_position + vector3, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT) #last value are seconds
			at_start = false
		else:
			tween.tween_property(self, "global_position", global_position - vector3, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
			at_start = true


func _on_body_exited(body):
	if body.name == "Player" and player:
		if original_parent != null:
			call_deferred("_reparent_player", original_parent)
			player = null

func _reparent_player(parent_node):
	if player and parent_node:
		remove_child(player)
		#player.position += position  # Adjust position back to the original
		parent_node.add_child(player)
