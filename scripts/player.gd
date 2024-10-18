extends Area2D

signal hit

@export var speed = 400 # (pixels/sec)
var screen_size # Game window size

@export var animated_sprite: AnimatedSprite2D
@export var collision_shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	# Hide player when game starts
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity := Vector2.ZERO # Player movement vector
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	# /!\ Y axis is upside down in computer graphics
	# See: https://docs.godotengine.org/en/4.3/tutorials/math/vector_math.html#doc-vector-math
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	# Length/Magnitude
	if velocity.length() > 0:
		# Scale movement vector to the speed
		velocity = velocity.normalized() * speed # Mandatory, otherwise the player would move faster diagonally :/
		animated_sprite.play()
	else:
		animated_sprite.stop()
	
	# Make velocity change the player position (delta --> Previous framelength like in Unity)
	position += velocity * delta
	
	# Limit the position of the player so it cannot go off screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Handle animations
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
		
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = velocity.y > 0

func start(pos):
	position = pos
	show()
	collision_shape.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	
	# Must be deferred as we can't change physics properties on a physics callback.
	# Disable player's collision to not trigger hit more than once
	collision_shape.set_deferred("disabled", true)
