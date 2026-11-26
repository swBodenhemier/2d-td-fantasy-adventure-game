extends CharacterBody2D

class_name Item

var this = {}

var pickupable = false

func _physics_process(delta: float) -> void:
	if velocity != Vector2.ZERO and velocity.x <= 1 and velocity.y <= 1:
		velocity = Vector2.ZERO
	$Sprite2D.position.y = sin($DespawnTimer.time_left * 2) * 4
	$Shadow.scale.x = 1 + (sin($DespawnTimer.time_left * 2) / 4)
	move_and_slide()
	velocity -= velocity * delta * 2
	

func set_item(item: Dictionary):
	get_node("Sprite2D").texture = load(item["sprite"])
	this = {
		"sprite": item["sprite"],
		"type": item["type"],
		"id": item["id"],
		"count": 1,
		"amount": item["amount"],
		"stackSize": item["stackSize"]
	}
	
func set_count(item: Dictionary):
	this["count"] = item["count"]


func _on_grace_period_timeout() -> void:
	pickupable = true

func _on_despawn_timer_timeout() -> void:
	queue_free()
