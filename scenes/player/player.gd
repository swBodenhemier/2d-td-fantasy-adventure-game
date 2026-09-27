extends CharacterBody2D

@export var speed = 250.0
@onready var animated_sprite = $AnimatedSprite2D

var last_direction = "down"
var is_action_playing = false

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up",
		"move_down")
	
	velocity = input_direction.normalized() * speed
	update_direction(input_direction)
	if not is_action_playing:
		update_movement_direction(input_direction)
	
	if Input.is_action_pressed("test_hit"):
		flash_red()
	
	move_and_slide()

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

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		play_action_animation("attack")
	elif event.is_action_pressed("test_hit"):
		play_action_animation("hit")
	elif event.is_action_pressed("test_die"):
		play_action_animation("die")

func _on_animated_sprite_2d_animation_finished() -> void:
	is_action_playing = false
