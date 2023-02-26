extends RigidBody2D

onready var Bullet = preload("res://objects/weapon/Laser.tscn")

var velocity : Vector2
export (int) var acceleration = 300
export (int) var max_speed = 500

export (float) var rotation_speed = 3.5

export (float) var slow_down = 0.005

onready var viewport_size = get_viewport_rect().size

signal laser_has_hit

func _on_Laser_body_entered(body : Node, bullet):
	# do not react when hitting the ship
	if body != self:
		bullet.queue_free()
		emit_signal("laser_has_hit", body)

var thrust = Vector2(30, 0)
var t = 300

func _integrate_forces(state):
	if Input.is_action_pressed("boost"):
		$Sprite/CPUParticles2D.emitting = true
		if linear_velocity.length() < 400:
			state.apply_central_impulse(thrust.rotated(rotation))
	else:
		$Sprite/CPUParticles2D.emitting = false
		#state.apply_central_impulse(Vector2())

	var rotation_direction = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1

	if rotation_direction < 0 and angular_velocity > -4:
		state.apply_torque_impulse(-t)
	if rotation_direction > 0 and angular_velocity < 4:
		state.apply_torque_impulse(t)

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
