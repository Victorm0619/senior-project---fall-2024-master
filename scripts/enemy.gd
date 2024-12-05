# enemy.gd
extends Area2D

class_name Enemy

signal killed(points)
signal hit

@export var speed = 150  # Default speed for regular Enemy
@export var hp = 2  # Default health for regular Enemy (2 shots to die)
@export var points = 100

# Export a flag to differentiate DiverEnemy behavior
@export var is_diver_enemy = false  # Flag to differentiate DiverEnemy

func _ready():
	# Check if this is a DiverEnemy, and if so, adjust properties
	if is_diver_enemy:
		speed = 500  # Faster speed for DiverEnemy
		hp = 1  # DiverEnemy takes 1 shot to die
	else:
		speed = 250  # Default speed for regular Enemy
		hp = 2  # Regular enemy takes 2 shots to die

	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	global_position.y += speed * delta  # Move down

# Fallback method to handle collision detection and resolve push
func _on_body_entered(body):
	if body is Enemy and body != self:
		resolve_collision(body)
	elif body is Player:
		body.die()
		die()

func resolve_collision(other: Enemy):
	var direction = (global_position - other.global_position).normalized()
	global_position += direction * 10  # Push effect

func die():
	queue_free()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()
