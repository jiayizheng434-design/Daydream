extends CharacterBody2D

const SPEED := 900.0
const JUMP_VELOCITY := -900.0
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")

var hearts_list: Array = []
var health: int = 3
var can_take_damage: bool = true
var damage_cooldown: float = 1.0

func _ready() -> void:
	for child in $HBoxContainer.get_children():
		hearts_list.append(child)
	update_heart_display()
	add_to_group("Player") # convenient (or add the group in the editor)

func take_damage() -> void:
	if health > 0 and can_take_damage:
		health -= 1
		update_heart_display()
		can_take_damage = false
		var t = get_tree().create_timer(damage_cooldown)
		t.timeout.connect(Callable(self, "_on_damage_cooldown_timeout"))

func _on_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_heart_display() -> void:
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
