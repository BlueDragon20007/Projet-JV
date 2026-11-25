class_name HostFlee
extends HostBaseState


var flee_from = Vector2.ZERO
var target_x = 0.0

const FLEE_DISTANCE = 200.0
const ARRIVAL_DIST = 4.0
const FLEE_SPEED_MOD = 2.0
const SAFE_DISTANCE = 300.0


func enter() -> void:
	host.animation_player.play("run")

	pick_flee_target()


func pick_flee_target() -> void:
	var away_dir = 1.0

	if flee_from != Vector2.ZERO:
		away_dir = sign(host.global_position.x - flee_from.x)
		if away_dir == 0.0:
			away_dir = 1.0
	else:
		away_dir = 1.0 if randf() > 0.5 else -1.0

	host.sprite.scale.x = abs(host.sprite.scale.x) * away_dir
	host.ray.force_raycast_update()

	if host.ray.is_colliding():
		away_dir = -away_dir
		host.sprite.scale.x = abs(host.sprite.scale.x) * away_dir

	target_x = host.global_position.x + away_dir * FLEE_DISTANCE


func physics_update(_delta: float) -> void:
	if flee_from != Vector2.ZERO and host.global_position.distance_to(flee_from) >= SAFE_DISTANCE:
		host.velocity.x = 0.0
		host.panic = 0.0
		Transitioned.emit(self, "idle")
		return

	if host.ray.is_colliding():
		host.velocity.x = 0.0
		host.panic = 0.0
		Transitioned.emit(self, "idle")
		return

	var distance_x = target_x - host.global_position.x
	if abs(distance_x) <= ARRIVAL_DIST:
		pick_flee_target()
		return

	var direction = sign(distance_x)
	apply_horizontal_movement(direction, FLEE_SPEED_MOD)

func reverse_direction() -> void:
	var current_dir = sign(target_x - host.global_position.x)
	if current_dir == 0.0:
		current_dir = 1.0

	var new_dir = -current_dir
	host.sprite.scale.x = abs(host.sprite.scale.x) * new_dir
	host.ray.force_raycast_update()

	if host.ray.is_colliding():
		host.velocity.x = 0.0
		host.panic = 0.0
		Transitioned.emit(self, "idle")
		return

	target_x = host.global_position.x + new_dir * FLEE_DISTANCE
