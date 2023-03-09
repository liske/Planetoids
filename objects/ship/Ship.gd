extends RigidBody2D

onready var Bullet = preload("res://objects/weapon/Laser.tscn")

var ANIM_RESPAWN = "respawn"

var velocity : Vector2
var can_die : bool
var can_control: bool

export (int) var max_linear_velocity = 400
export (Vector2) var linear_thrust = Vector2(30, 0)

export (int) var max_angular_velocity = 4
export (int) var torque_impulse = 300

onready var viewport_size = get_viewport_rect().size

func do_spawn():
	self.can_die = false
	self.can_control = true
	self.enable_collisions()
	self.enable_supershield()

	self.position.x	= viewport_size.x/4 + randi() % int(viewport_size.x/2)
	self.position.y	= viewport_size.y/4 + randi() % int(viewport_size.y/2)
	self.rotation = randf()*2*PI
	
	$ExplosionParticles.emitting = false
	$RespawnTimer.stop()
	$AnimationPlayer.play(ANIM_RESPAWN)
	$Sprite.show()

func do_explode(respawn=false):
	self.can_control = false
	self.disable_collisions()
	self.disable_supershield()
	$Sprite.hide()
	$Sprite/CPUParticles2D.emitting = false
	$ExplosionParticles.emitting = true
	if respawn:
		$RespawnTimer.start()

func disable_collisions():
	self.collision_layer = 0
	self.collision_mask = 0

func enable_collisions():
	self.collision_layer = 2
	self.collision_mask = 1

func enable_supershield():
	$SuperShieldCollisionShape2D.set_disabled(false)
	$SuperShieldSprite.show()

func disable_supershield():
	$SuperShieldCollisionShape2D.set_disabled(true)
	$SuperShieldSprite.hide()

func _on_RespawnTimer_timeout():
	self.do_spawn()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ANIM_RESPAWN:
		self.can_die = true
		self.disable_supershield()

func _on_Laser_body_entered(body : Node, bullet):
	# do not react when hitting the ship
	if body != self:
		planetoids.laser_hit_astroid(bullet, body)

func _integrate_forces(state):
	if not can_control:
		return

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

	if can_control and Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instance()
		get_parent().add_child(bullet)
		bullet.global_rotation = $Position2D_Gun.global_rotation
		bullet.global_position = $Position2D_Gun.global_position
		bullet.apply_central_impulse(Vector2.RIGHT.rotated(rotation) * 600)
		bullet.connect("body_entered", self, "_on_Laser_body_entered", [bullet])

func _ready():
	self.can_control = false
	self.disable_supershield()
	self.disable_collisions()
	$Sprite.hide()
