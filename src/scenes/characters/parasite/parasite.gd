extends CharacterBody2D

@onready var interactor_component: Node2D = $InteractorComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

enum State {
	NORMAL,
	POSSESSING
}

var current_state: State

var current_host = null

func _ready():
	interactor_component.interact.connect(_interacted)

func _physics_process(delta: float) -> void:
	manage_movement(delta)
	if Input.is_action_just_pressed("exit"):
		leave_host()
	
func manage_movement(delta: float):
	if current_host:
		follow_host()
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func follow_host():
	global_position = current_host.global_position
	
func leave_host():
	if current_host == null: return
	
	current_host.leave_control()
	current_host = null
	sprite.visible = true
	global_position += Vector2(-20, 0)
	collision_shape.set_deferred("disabled", false)

func _interacted(interactable):
	if interactable:
		if current_host: current_host.leave_control()
		
		current_host = interactable.get_parent()
		sprite.visible = false
		collision_shape.set_deferred("disabled", true)
