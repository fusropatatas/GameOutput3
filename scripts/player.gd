extends CharacterBody2D

signal health_depleted
signal hit_score

const SPEED = 500.0

var screen_size: Vector2
var can_shoot = true
var collided: bool
@export var health = 10
@export var projectile: PackedScene

func _ready() -> void:
	$AnimatedSprite2D.animation = "Default"
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x/6, screen_size.y/2)
	collided = false
	
func _physics_process(delta) -> void:
	if health>0:
		move(delta)
		
		if Input.is_action_pressed("shoot") and can_shoot:
			shoot()

func move(delta) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	velocity = velocity.normalized() * SPEED
	
	position.x -= delta * 20
	position += velocity * delta
	position = position.clamp(Vector2(21*2,30*2), Vector2(screen_size.x/3, screen_size.y-30*2))
	
func shoot() -> void:
	var inst: PlayerBullet = projectile.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.position = $BulletSpawn.global_position
	inst.bullet_impact.connect(_bullet_impact)
	
	$AttackSpeed.start()
	can_shoot = false
	
func _on_attack_speed_timeout():
	can_shoot = true
	
func player_collide():
	if not collided:
		collided = true
		damaged(4)
		
		var old_color = modulate
		modulate = Color(1,0,0,0.5)
		var tween = create_tween()
		tween.tween_property(self, "modulate", old_color, 0.4)
		await tween.finished
		
		collided = false
		
func player_hit():
	damaged(1)

func damaged(dmg: int):
	health-= dmg
	if health <= 0:
		$AnimatedSprite2D.animation = 'explode'
		var tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "scale", Vector2(3,3), 0.1)
		await tween.finished
		health_depleted.emit()
		hide()
		position = Vector2(0,-1000)

func _bullet_impact():
	hit_score.emit()
