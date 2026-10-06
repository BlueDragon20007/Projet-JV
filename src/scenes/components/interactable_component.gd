extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@export var max_distance := 100.0

signal interact

var activated := true

func _ready() -> void:
	sprite.visible = false

func _process(delta: float) -> void:
	pass

#func is_interactor_in_range():
	#var interactors = get_tree().get_nodes_in_group("interactor")
	#
	#for interactor in interactors:
		#var distance = global_position.distance_to(interactor.global_position)
		#if distance <= max_distance:
			#return true
	#
	#return false
