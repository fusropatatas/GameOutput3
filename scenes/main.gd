extends Node2D

@export var enemy_scene: PackedScene
var enemies: int
var score: int
const SCROLL_SPEED = 1000
# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	enemies = 0
	$SpawnTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ParallaxBackground.offset.x -= delta*SCROLL_SPEED
	if $ParallaxBackground.offset.x <= -1920:
		$ParallaxBackground.offset.x = 0
	$Score.text = str(score)
	$Health.text = "Health: " + str($Player.health)


func _on_spawn_timer_timeout():
	if enemies <= 10:
		var enemy = enemy_scene.instantiate()
		var spawn_location = $SpawnLocation/SpawnPoints
		spawn_location.progress_ratio = randf()
		enemy.position = spawn_location.position
		add_child(enemy)
		enemies += 1
		enemy.destroyed.connect(_on_enemy_destroyed)
	
func _on_enemy_destroyed():
	enemies -= 1
	score += 100

func _on_player_hit_score():
	score += 10
