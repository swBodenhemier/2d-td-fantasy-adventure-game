class_name Hitbox
extends Area2D

signal hit_landed
signal trigger_hit

@export var triggered: bool = false
@export var damage: int = 10
@export var cooldown: float = 1.0
@export var target_group: StringName = &"Hurtbox"
@export var knockback_force: float = 300.0

var _cooldown_timer: float = 0.0

func _ready() -> void:
	trigger_hit.connect(_on_trigger_hit)

func _physics_process(delta: float) -> void:
	if triggered:
		return
	
	_cooldown_timer = maxf(_cooldown_timer - delta, 0.0)
	if _cooldown_timer > 0.0:
		return
	# The overlap list updates once per physics step.
	for body in get_overlapping_bodies():
		for child in body.get_children():
			if child.is_in_group(target_group):
				_try_hit(child)

func _on_trigger_hit():
	for body in get_overlapping_bodies():
		for child in body.get_children():
			if child.is_in_group(target_group):
				_try_hit(child)

func _try_hit(target: Node2D) -> void:
	var hurtbox = target as Hurtbox
	hurtbox.try_hit.emit(self)
	_cooldown_timer = cooldown
	hit_landed.emit(target)
