extends Node2D

var activated := true
var current_interactable = null

signal interact

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if activated: current_interactable = get_closest_interactable()
	if Input.is_action_just_pressed("interact") and current_interactable:
		activate_interact()
	

func get_closest_interactable():
	var interactables = get_tree().get_nodes_in_group("interactable")
	var closest_distance = 1000.0
	var closest_interactable = null
	
	for interactable in interactables:
		var distance = global_position.distance_to(interactable.global_position)
		if distance <= interactable.max_distance and distance <= closest_distance and interactable.activated:
			closest_distance = distance
			if closest_interactable:
				closest_interactable.sprite.visible = false
			closest_interactable = interactable
		else:
			interactable.sprite.visible = false
			
	if closest_interactable:
		closest_interactable.sprite.visible = true
		
	return closest_interactable
	
func activate_interact():
	interact.emit(current_interactable)
	current_interactable.interact.emit()
