class_name Rock
extends RigidBody2D

@onready var interactable_component: Node2D = $InteractableComponent
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	interactable_component.interact.connect(_on_interacted)

func _process(delta: float) -> void:
	pass

func _on_interacted(interactor):
	if interactor:
		if interactor.current_host:
			if interactor.current_host.role == "muscular":
				throw()
	

func throw():
	collision_shape.disabled = true
	apply_impulse(Vector2(200, -600), Vector2(-10, 0))
	await get_tree().create_timer(2).timeout
	queue_free()
