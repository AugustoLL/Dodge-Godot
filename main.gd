extends Node

@export var enemy_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Music.play()
	get_tree().call_group("enemies", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()

func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()


func _on_start_timer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)



func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	var direction = enemy_spawn_location.rotation + PI / 2
	
	enemy.position = enemy_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)

	add_child(enemy)
	
