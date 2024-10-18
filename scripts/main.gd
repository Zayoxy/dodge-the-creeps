extends Node

@export var mob_scene: PackedScene
@export var mob_timer: Timer
@export var score_timer: Timer
@export var start_timer: Timer
var score : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	# Remove all remaining mobs if there are any
	get_tree().call_group("mobs", "queue_free")
	
	score = 0
	$Player.start($StartPosition.position)
	start_timer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()

func _on_mob_timer_timeout() -> void:
	# Create an instance of a mob scene
	var mob := mob_scene.instantiate()
	
	# Random location on Path2D
	var mob_spawn_location := $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set instanciated mob the the random position
	mob.position = mob_spawn_location.position
	
	# Random direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Set a random direction
	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Add the mob to the main scene
	add_child(mob)
