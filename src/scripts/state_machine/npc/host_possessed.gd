class_name HostPossessed
extends HostBaseState

func enter() -> void:
	host.interactable_component.activated = false
	host.velocity.x = 0.0

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and host.is_on_floor():
		host.velocity.y = host.JUMP_VELOCITY

	var direction := get_movement_direction()
	if direction != 0.0:
		host.velocity.x = direction * host.POSSESSED_SPEED
		host.animation_player.play("walk")
	else:
		host.velocity.x = move_toward(host.velocity.x, 0.0, host.POSSESSED_SPEED)
		host.animation_player.play("idle")

func exit() -> void:
	host.velocity.x = 0.0
