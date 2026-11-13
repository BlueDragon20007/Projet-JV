class_name ButtonMinigame
extends Node2D

@onready var hand: Sprite2D = $Hand
@onready var hand_position := hand.position

var end_position := 110.0

var max_shake := 0.5

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	apply_hand_shake()
	if Input.is_action_just_pressed("interact"):
		hand_position.y += 4
	hand_position.y -= 0.1
	if hand_position.y >= end_position:
		get_tree().change_scene_to_file("res://scenes/levels/end_scene.tscn")

func apply_hand_shake():
	hand.position = Vector2(hand_position.x + randf_range(-max_shake, max_shake), hand_position.y + randf_range(-max_shake, max_shake))
