extends Area2D

class_name EnemyBullet
	
var speed = 15;
var in_flight: bool

func _ready():
	in_flight = true
	$AnimatedSprite2D.animation = 'fired'
	
func _physics_process(delta):
	if in_flight:
		$AnimatedSprite2D.animation = 'in_flight'
		global_position.x -= speed
	
func _on_body_entered(body):
	if body.has_method("player_hit"):
		in_flight = false
		body.player_hit()
		$AnimatedSprite2D.animation = 'explode'
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "scale", Vector2(3,3), 0.1)
		await tween.finished
		queue_free()


func _on_despawn_timeout():
	queue_free()
