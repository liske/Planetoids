extends KinematicBody2D

onready var Bullet = preload("res://objects/weapon/Laser.tscn")

var input_vector : Vector2
var velocity : Vector2
export (int) var acceleration = 300
export (int) var max_speed = 500

var rotation_direction : int
export (float) var rotation_speed = 3.5

export (float) var slow_down = 0.005

onready var viewport_size = get_viewport_rect().size

func _physics_process(delta):
	rotation_direction = 0
	if Input.is_action_pressed("rotate_left"):
		rotation_direction = -1
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	
	input_vector.x = clamp(Input.get_action_strength("boost"), 0, max_speed)
	
	if input_vector.x == 0 && velocity != Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, slow_down)
		if abs(velocity.x) <= 0.1 && abs(velocity.y) <= 0:
			velocity = Vector2.ZERO
	else:
		velocity += Vector2(input_vector.x * acceleration * delta, 0).rotated(rotation)
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = clamp(velocity.y, -max_speed, max_speed)

	rotation += rotation_direction * rotation_speed * delta
	velocity = move_and_slide(velocity)

	var half_height : int = $Sprite.texture.get_height()/4
	var half_width : int = $Sprite.texture.get_width()/4

	position.x = wrapf(position.x, -half_width, viewport_size.x + half_width)
	position.y = wrapf(position.y, -half_height, viewport_size.y + half_height)

	if Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instance()
		get_parent().add_child(bullet)
		bullet.global_rotation = $Position2D_Center.global_rotation
		bullet.global_position = $Position2D_Center.global_position
#		bullet.position += transform.x * bullet.half_width
