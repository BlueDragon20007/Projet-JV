@abstract class_name HostBaseState
extends BaseState

var host : Host

const SPEED = 150.0

func _ready() -> void:
	host = get_parent().get_parent() as Host

func _input(event: InputEvent) -> void:
	handle_inputs(event)

func handle_inputs(_input_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func get_movement_direction() -> float:
	return Input.get_axis("move_left", "move_right")

func apply_horizontal_movement(direction):
	host.velocity.x = direction * host.SPEED
