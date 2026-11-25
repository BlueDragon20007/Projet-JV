class_name Host
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray: RayCast2D = $Sprite2D/RayCast2D

@onready var interactable_component: Node2D = $InteractableComponent
@onready var state_machine: Node = $StateMachine
@onready var vision_area: VisionArea = $Sprite2D/VisionArea

@onready var scream_player: AudioStreamPlayer2D = $ScreamPlayer
@export var scream_sounds: Array[AudioStream] = []

@export var role: String = ""

var speed = randf_range(25.0, 35.0)
const POSSESSED_SPEED = 60.0
const JUMP_VELOCITY = -300.0

const PANIC_DECAY = 15.0
const PANIC_RATE_PARASITE = 80.0
const PANIC_SHOUT = 30.0
const PANIC_RADIUS = 250.0

var panic = 0.0
var panic_threshold = randf_range(80.0, 120.0)

var flee_pending = false
var flee_delay = 0.0
var flee_from_pos = Vector2.ZERO

func _ready():
	add_to_group("npc")
	interactable_component.interact.connect(_on_interacted)
	vision_area.target_spotted.connect(_on_target_spotted)
	_assign_random_scream()
	ray.target_position.x = randi_range(20, 40)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	update_facing_direction()

	move_and_slide()
	_update_panic(delta)
	_update_pending_flee(delta)

func update_facing_direction() -> void:
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif velocity.x < 0:
		sprite.scale.x = -abs(sprite.scale.x)

func _on_interacted(interactor) -> void:
	state_machine.on_child_transition(state_machine.current_state, "possessed")

func _assign_random_scream() -> void:
	if scream_sounds.is_empty():
		return
	scream_player.stream = scream_sounds.pick_random()

func _on_target_spotted(target) -> void:
	if target is Parasite and state_machine.current_state is HostFlee:
		var flee_state = state_machine.states.get("flee")
		if flee_state:
			flee_state.reverse_direction()

func _flee_from(pos: Vector2) -> void:
	flee_pending = false

	if state_machine.current_state is HostPossessed:
		return

	var flee_state = state_machine.states.get("flee")
	if flee_state:
		flee_state.flee_from = pos

	state_machine.on_child_transition(state_machine.current_state, "flee")

	if state_machine.current_state is HostFlee:
		shout_panic()


func _update_panic(delta: float) -> void:
	var current = state_machine.current_state
	if current is HostPossessed or current is HostFlee:
		return

	var parasite = _visible_parasite()

	if parasite != null:
		panic = min(panic_threshold, panic + PANIC_RATE_PARASITE * delta)
	else:
		panic = max(0.0, panic - PANIC_DECAY * delta)

	if panic >= panic_threshold and parasite != null:
		_flee_from(parasite.global_position)


func _visible_parasite() -> Parasite:
	for body in vision_area.get_overlapping_bodies():
		if body is Parasite:
			return body as Parasite

	return null


func shout_panic() -> void:
	get_tree().call_group("npc", "_on_panic_shout", global_position)
	scream()

func scream() -> void:
	if scream_player.stream != null and not scream_player.playing:
		scream_player.pitch_scale = randf_range(0.95, 1.05)
		scream_player.play()

func _on_panic_shout(shout_pos: Vector2) -> void:
	var current = state_machine.current_state
	if current is HostPossessed or current is HostFlee:
		return

	var dist = global_position.distance_to(shout_pos)
	if dist > PANIC_RADIUS:
		return

	panic = min(panic_threshold, panic + PANIC_SHOUT)

	if panic >= panic_threshold and not flee_pending:
		flee_pending = true
		flee_delay = (panic_threshold / 100.0) * randf_range(0.5, 1.0)
		flee_from_pos = shout_pos


func _update_pending_flee(delta: float) -> void:
	if not flee_pending:
		return

	var current = state_machine.current_state
	if current is HostPossessed or current is HostFlee:
		flee_pending = false
		return

	flee_delay -= delta
	if flee_delay <= 0.0:
		flee_pending = false
		_flee_from(flee_from_pos)


func leave_control() -> void:
	interactable_component.activated = true
	state_machine.on_child_transition(state_machine.current_state, "idle")
