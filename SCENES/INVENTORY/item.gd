extends Sprite2D
var type
var amount
var is_stackable
func set_item(item: Dictionary):
	texture = item["sprite"]
	type = item["type"]
	amount = item["amount"]
	is_stackable = item["stackable"]
	
