class_name Hurtbox
extends Area2D

signal try_hit(hitbox: Hitbox)
signal damage_received(amount: int)

@export var iframe_duration: float = 1.0

var is_invincible: bool = false
var iframe_timer: Timer

func _ready() -> void:
	add_to_group("Hurtbox")
	try_hit.connect(_on_try_hit)
	_setup_iframe_timer()

func _on_try_hit(hitbox: Hitbox):
	if !is_invincible:
		damage_received.emit(hitbox)
		is_invincible = true
		iframe_timer.start(iframe_duration)
	
func _setup_iframe_timer() -> void:
	iframe_timer = Timer.new()
	iframe_timer.one_shot = true
	add_child(iframe_timer)
	iframe_timer.timeout.connect(_on_iframe_timer_timeout)

func _on_iframe_timer_timeout() -> void:
	is_invincible = false
