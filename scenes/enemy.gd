extends CharacterBody2D

const SPEED = 100.0

signal destroyed

var screen_size: Vector2
var center_y: float
var time: float
var in_flight: bool

@export var health = 5
@export var projectile: PackedScene

func _ready() -> void:
	in_flight = true
	var ship_type
	match randi()%3:
		0:
			ship_type = "ship1"
		1:
			ship_type = "ship2"
		2:
			ship_type = "ship3"
		_:
			ship_type = "ship1"
	$AnimatedSprite2D.animation = ship_type
	time = 0
	$AttackSpeed.start()
	screen_size = get_viewport_rect().size
	center_y = position.y
	
func _physics_process(delta) -> void:
	time += delta
	position.x -= delta * SPEED
	position.y = center_y + sin(time)*SPEED
	if position.x < -100:
		queue_free()
		destroyed.emit()
	

func _on_attack_speed_timeout():
	var inst: EnemyBullet = projectile.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.position = $BulletSpawn.global_position
	$AttackSpeed.wait_time = 0.75 + randf()/2
	
func enemy_hit():
	health-=1
	if health == 0:
		$AnimatedSprite2D.animation = 'explode'
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "scale", Vector2(3,3), 0.1)
		await tween.finished
		queue_free()
		destroyed.emit()


func _on_area_2d_body_entered(body):
	if body.has_method("player_collide"):
		in_flight = false
		body.player_collide()
		$AnimatedSprite2D.animation = 'explode'
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "scale", Vector2(3,3), 0.1)
		await tween.finished
		queue_free()
		destroyed.emit()
