extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: Node2D = $InteractableComponent

enum State {
	IDLE,
	WALK,
	POSSESSED
}

var current_state: State

const SPEED = 30.0
const POSSESSED_SPEED = 60.0
const JUMP_VELOCITY = -300.0

func _ready():
	change_state(State.WALK)
	interactable_component.interact.connect(_interacted)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match current_state:
		State.IDLE:
			idle()
		State.WALK:
			walk()
		State.POSSESSED:
			possessed()
			
	animate_player()

func change_state(new_state: State):
	current_state = new_state
	
func animate_player():
	if velocity.x != 0:
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = velocity.x < 0
	else:
		animated_sprite_2d.play("idle")

func idle():
	velocity.x = 0
	move_and_slide()
	
	
func walk():
	velocity.x = SPEED
	move_and_slide()

func possessed():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * POSSESSED_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, POSSESSED_SPEED)
	move_and_slide()
		
func _interacted():
	interactable_component.activated = false
	change_state(State.POSSESSED)
	
func leave_control():
	change_state(State.WALK)
	interactable_component.activated = true
