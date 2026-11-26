class_name VictoryMenu
extends Control

@onready var play_again_button: Button = %RetryButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	get_tree().paused = false
	play_again_button.pressed.connect(_on_play_again_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	play_again_button.grab_focus()

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
