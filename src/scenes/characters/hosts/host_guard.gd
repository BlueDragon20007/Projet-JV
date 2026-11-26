class_name HostGuard
extends Host

func _ready():
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	_update_shoot_target()

func _update_shoot_target() -> void:
	var current = state_machine.current_state
	
	if current is HostPossessed or current is HostShoot:
		return

	if _visible_parasite() != null:
		state_machine.on_child_transition(current, "shoot")

func _update_panic(_delta: float) -> void:
	return

func _flee_from(_pos: Vector2) -> void:
	return

func _on_panic_shout(_shout_pos: Vector2) -> void:
	return
