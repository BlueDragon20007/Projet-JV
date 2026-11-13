class_name VisionArea
extends Area2D

signal target_spotted(target: Node2D)

@export var targets_to_detect: Array[PackedScene]

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if _matches_target(body):
		target_spotted.emit(body)

func _matches_target(body: Node2D) -> bool:
	if body.scene_file_path.is_empty():
		return false
	
	for target_scene in targets_to_detect:
		if target_scene != null and body.scene_file_path == target_scene.resource_path:
			return true
	return false
