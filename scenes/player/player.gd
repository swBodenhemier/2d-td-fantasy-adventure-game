extends CharacterBody2D

@export var speed = 250.0
@onready var animated_sprite = $AnimatedSprite2D

var last_direction = "down"

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up",
		"move_down")
	
	velocity = input_direction.normalized() * speed
	update_direction(input_direction)
	
	move_and_slide()

func update_direction(input_direction):
	if input_direction.y < 0:
		last_direction = "up"
	elif input_direction.y > 0:
		last_direction = "down"
	elif input_direction.x < 0:
		last_direction = "left"
	elif input_direction.x > 0:
		last_direction = "right"
