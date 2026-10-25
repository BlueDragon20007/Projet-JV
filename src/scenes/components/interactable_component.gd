extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@export var max_distance := 100.0

signal interact

var activated := true

func _ready() -> void:
	sprite.visible = false
