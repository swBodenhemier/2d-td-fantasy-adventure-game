extends CharacterBody2D

class_name Item

var this = {}

var pickupable = false

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
