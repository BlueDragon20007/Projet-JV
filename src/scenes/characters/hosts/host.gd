class_name Host
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray: RayCast2D = $Sprite2D/RayCast2D

@onready var interactable_component: Node2D = $InteractableComponent
@onready var state_machine: Node = $StateMachine
@onready var vision_area: VisionArea = $Sprite2D/VisionArea

@export var role: String = ""

const SPEED = 30.0
const POSSESSED_SPEED = 60.0
const JUMP_VELOCITY = -300.0

func _ready():
	interactable_component.interact.connect(_on_interacted)
	vision_area.target_spotted.connect(_on_target_spotted)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	update_facing_direction()
	
	move_and_slide()
	
func update_facing_direction() -> void:
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif velocity.x < 0:
		sprite.scale.x = -abs(sprite.scale.x)

func _on_interacted(interactor) -> void:
	state_machine.on_child_transition(state_machine.current_state, "possessed")
	
func _on_target_spotted(target) -> void:
	if target is Parasite:
		state_machine.on_child_transition(state_machine.current_state, "flee")

func leave_control() -> void:
	interactable_component.activated = true
	state_machine.on_child_transition(state_machine.current_state, "idle")
