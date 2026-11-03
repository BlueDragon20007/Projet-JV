extends Node2D

@onready var main_music = $MainTheme

@export var transtition_time := .5
@export var min_volume = -55
@export var max_volume = -15

func _ready():
	main_music.play()
	main_music.volume_db = max_volume

#func main_theme():
	#var tween = create_tween()
	#tween.tween_property(main_music, "volume_db", max_volume, transtition_time)
