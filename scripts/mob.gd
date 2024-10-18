extends RigidBody2D

@export var animated_sprite: AnimatedSprite2D
@export var collision_shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get all animations name of the mob
	var mob_types := animated_sprite.sprite_frames.get_animation_names()
	
	# Chose one randomly and play it
	animated_sprite.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Delete himself when out of the screen
	queue_free()
