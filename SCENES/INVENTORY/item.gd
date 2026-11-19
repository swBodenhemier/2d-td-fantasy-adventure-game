extends Sprite2D

class_name Item

var this = {}

var pickupable = false

func set_item(item: Dictionary):
	texture = load(item["sprite"])
	this = {
		"sprite": item["sprite"],
		"type": item["type"],
		"id": item["id"],
		"amount": item["amount"],
		"stackSize": item["stackSize"]
	}


func _on_grace_period_timeout() -> void:
	pickupable = true

func _on_despawn_timer_timeout() -> void:
	queue_free()
