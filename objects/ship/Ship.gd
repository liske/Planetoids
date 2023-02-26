extends RigidBody2D

onready var Bullet = preload("res://objects/weapon/Laser.tscn")

var velocity : Vector2

export (int) var max_linear_velocity = 400
export (Vector2) var linear_thrust = Vector2(30, 0)

export (int) var max_angular_velocity = 4
export (int) var torque_impulse = 300

onready var viewport_size = get_viewport_rect().size

signal laser_has_hit

func _on_Laser_body_entered(body : Node, bullet):
	# do not react when hitting the ship
	if body != self:
		bullet.queue_free()
		emit_signal("laser_has_hit", body)

func _integrate_forces(state):
	if Input.is_action_pressed("boost"):
		$Sprite/CPUParticles2D.emitting = true
		if linear_velocity.length() < max_linear_velocity:
			state.apply_central_impulse(linear_thrust.rotated(rotation))
	else:
		$Sprite/CPUParticles2D.emitting = false

	var rotation_direction = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1

	if rotation_direction < 0 and angular_velocity > -max_angular_velocity:
		state.apply_torque_impulse(-torque_impulse)
	if rotation_direction > 0 and angular_velocity < max_angular_velocity:
		state.apply_torque_impulse(torque_impulse)

func _physics_process(_delta):
	# wrap around screen edges
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)

	if Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instance()
		get_parent().add_child(bullet)
		bullet.global_rotation = $Position2D_Gun.global_rotation
		bullet.global_position = $Position2D_Gun.global_position
		bullet.apply_central_impulse(Vector2.RIGHT.rotated(rotation) * 600)
		bullet.connect("body_entered", self, "_on_Laser_body_entered", [bullet])
