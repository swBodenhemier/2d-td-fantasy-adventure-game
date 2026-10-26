extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_group("Movement")
@export var patrol_speed: float = 40.0
@export var chase_speed: float = 70.0

@export_group("Idle and Patrol Timing")
@export var idle_time_min: float = 1.0
@export var idle_time_max: float = 3.0
@export var patrol_time_min: float = 1.5
@export var patrol_time_max: float = 4.0

@export_group("Chasing")
@export var detection_range: float = 120.0
@export var give_up_time: float = 3.0

const BLOB_GROUP := &"blobs"
const PLAYER_GROUP := &"Player"

var _state_timer: float = 0.0
var _chase_timer: float = 0.0
var _patrol_direction := Vector2.ZERO
var _player: Node2D = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $BlobHitbox
@onready var hurtbox: Hurtbox = $BlobHurtbox

var screen_size: Vector2

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group(BLOB_GROUP)
	hitbox.hit_landed.connect(_on_hit_landed)
	hurtbox.damage_received.connect(take_damage)
	_start_idle()
	screen_size = get_viewport_rect().size

enum State {IDLE, PATROL, CHASE}
var state: State = State.IDLE
func _physics_process(delta: float) -> void:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group(PLAYER_GROUP) as Node2D
	match state:
		State.IDLE:
			_update_idle(delta)
		State.PATROL:
			_update_patrol(delta)
		State.CHASE:
			_update_chase(delta)
	move_and_slide()
	global_position.x = clamp(global_position.x, 0, screen_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y)
	
	_bounce_off_walls()
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x > 0.0

func _start_idle():
	state = State.IDLE
	_state_timer = randf_range(idle_time_min, idle_time_max)
	velocity = Vector2.ZERO
	sprite.play("idle")

func _start_patrol():
	state = State.PATROL
	_state_timer = randf_range(patrol_time_min, patrol_time_max)
	_patrol_direction = Vector2.from_angle(randf_range(0.0, TAU))
	sprite.play("move")

func _start_chase():
	state = State.CHASE
	_chase_timer = give_up_time
	sprite.play("move")

func _update_idle(delta: float):
	velocity = Vector2.ZERO
	_state_timer -= delta
	if _state_timer <= 0.0:
		_start_patrol()

func _update_patrol(delta: float):
	velocity = _patrol_direction * patrol_speed
	_state_timer -= delta
	if _player_in_range():
		_start_chase()
	elif _state_timer <= 0.0:
		_start_idle()

func _update_chase(delta: float) -> void:
	if not _player_in_range():
		_start_idle()
		return

	_chase_timer -= delta
	if _chase_timer <= 0.0:
		_start_idle()
		return
		
	var to_player := global_position.direction_to(_player.global_position)
	velocity = to_player * chase_speed

func _player_in_range():
	if not is_instance_valid(_player):
		return false
	var distance := global_position.distance_to(_player.global_position)
	return distance <= detection_range

func _bounce_off_walls() -> void:
	if state != State.PATROL:
		return
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var normal := collision.get_normal()
		if _patrol_direction.dot(normal) < 0.0:
			_patrol_direction = _patrol_direction.bounce(normal)

func _on_hit_landed(_target: Node2D) -> void:
	if state == State.CHASE:
		_chase_timer = give_up_time

func take_damage(amount: int) -> void:
	die()

func die() -> void:
	queue_free()
