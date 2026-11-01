extends CharacterBody2D

signal health_changed(current_health, max_health)

@export var speed = 250.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtbox: Hurtbox = $PlayerHurtBox
@onready var hitbox: Hitbox = $PlayerHitBox

@export var max_health: int = 100
var current_health: int

@export var knockback_friction: float = 10.0

var knockback_velocity: Vector2 = Vector2.ZERO
var is_in_knockback: bool = false

var last_direction = "down"
var is_action_playing = false

var screen_size: Vector2

func _ready():
	current_health = max_health
	health_changed.emit(current_health, max_health)
	hurtbox.damage_received.connect(take_damage)
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	if current_health <= 0:
		return
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up",
		"move_down")

	if is_in_knockback:
		velocity = knockback_velocity
		move_and_slide()
		
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 
			knockback_friction * speed * delta)
		if knockback_velocity.length() < 10.0:
			is_in_knockback = false
	else:
		velocity = input_direction.normalized() * speed
		update_direction(input_direction)
	
	if not is_action_playing:
		update_movement_direction(input_direction)
	
	move_and_slide()
	global_position.x = clamp(global_position.x, 0, screen_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y)
	
func take_damage(hitbox: Hitbox):
	if current_health <= 0:
		return
	
	var amount = hitbox.damage
	play_action_animation("hit")
	current_health = clampi(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		die()
	else:
		apply_knockback(hitbox.global_position, hitbox.knockback_force)

func apply_knockback(source_position: Vector2, force: float):
	var knockback_direction = (global_position - source_position).normalized()
	if knockback_direction == Vector2.ZERO:
		knockback_direction = Vector2.DOWN
	knockback_velocity = knockback_direction * force
	is_in_knockback = true

func heal(amount: int):
	current_health = clampi(current_health + amount, 0, max_health)
	health_changed.emit(current_health, max_health)

func update_direction(input_direction):
	if input_direction.x < 0:
		last_direction = "left"
	elif input_direction.x > 0:
		last_direction = "right"
	elif input_direction.y < 0:
		last_direction = "up"
	elif input_direction.y > 0:
		last_direction = "down"

func update_movement_direction(input_direction):
	if input_direction == Vector2.ZERO:
		animated_sprite.play("idle_" + last_direction)
	else:
		animated_sprite.play("run_" + last_direction)

func flash_red():
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)

func play_action_animation(action_name):
	# The sprite sheet I used doesn't have a hit animation
	# so instead I am making the sprite flash red on hit
	if action_name == "hit":
		flash_red()
	else:
		is_action_playing = true
		animated_sprite.play(action_name + "_" + last_direction)

func die():
	play_action_animation("die")

func _unhandled_input(event):
	if event.is_action_pressed("attack") and current_health > 0:
		attack()

func attack():
	play_action_animation("attack")
	hitbox.trigger_hit.emit()

func _on_animated_sprite_2d_animation_finished() -> void:
	if current_health <= 0:
		animated_sprite.play("dead_" + last_direction)
	else:
		is_action_playing = false
