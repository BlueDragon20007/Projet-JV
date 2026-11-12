extends Node2D

@export var target_scene: String = "res://scenes/levels/world.tscn"
@export var required_role: String = "president"
@export var max_distance := 100.0

@onready var interactable_component: Node2D = $InteractableComponent

func _ready() -> void:
	interactable_component.interact.connect(_on_interacted)
	interactable_component.max_distance = max_distance

func _on_interacted(interactor) -> void:
	if not interactor or not interactor.current_host:
		return
		
	if interactor.current_host.role == required_role:
		get_tree().change_scene_to_file(target_scene)
