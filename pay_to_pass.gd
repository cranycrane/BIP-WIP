extends Node3D

@export var coins_to_pay = 1
@export var hud_path : NodePath

@onready var pay_hint = $InteractHint/Pay
@onready var no_coins_hint = $InteractHint/NoCoins
@onready var payed_hint = $InteractHint/Payed

var player_in_area = false
var hud = null
var can_show = false

func _ready():
	hud = get_node(hud_path)

func _process(delta):
	if player_in_area and hud.coins_collected >= coins_to_pay and can_show:
		pay_hint.visible = true
		if Input.is_action_just_pressed("ui_pay"):
			payed_hint.visible = true
			hud.allowed_pasage = true

	elif player_in_area and can_show:
		no_coins_hint.visible = true

func can_be_shown():
	can_show = true

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		player_in_area = body


func _on_area_3d_body_exited(body):
	if body.name == "Player":
		pay_hint.visible = false
		payed_hint.visible = false
		no_coins_hint.visible = false
		player_in_area = null


