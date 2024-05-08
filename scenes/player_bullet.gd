extends Area2D

class_name PlayerBullet

signal bullet_impact
var in_flight
var speed = 20;

func _ready():
	in_flight = true
	scale = Vector2(3, 3)
	$AnimatedSprite2D.animation = 'fired'
	$Despawn.start()
	
func _physics_process(delta):
	if in_flight:
		scale = Vector2(2, 2)
		$AnimatedSprite2D.animation = 'in_flight'
		position += transform.x * speed
	

func _on_body_entered(body):
	if body.has_method("enemy_hit"):
		in_flight = false
		body.enemy_hit()
		$AnimatedSprite2D.animation = 'explode'
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "scale", Vector2(3,3), 0.1)
		await tween.finished
		queue_free()
		bullet_impact.emit()

func _on_despawn_timeout():
	queue_free()
