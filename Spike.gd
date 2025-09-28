extends Area2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Debug: see what hit the spike
	print("Spike hit by:", body, "class:", body.get_class(), "name:", body.name, "has take_damage:", body.has_method("take_damage"))

	# SAFEST: only call take_damage if that method exists on the body
	if body.has_method("take_damage"):
		body.take_damage()
	else:
		# useful message for debugging; don't try to access `health` here
		print("Spike: collided body has no take_damage() method — check groups/layers or player node.")

