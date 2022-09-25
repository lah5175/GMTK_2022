extends Area2D

var damage = 1;
var target;
var direction = Vector2();

var is_burning: bool = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass;


func _on_DurationTimer_timeout():
	queue_free();


func _on_BossAttack4_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		is_burning = true;
		target.take_damage(damage);
		$BurningTimer.start();

func _on_BurningTimer_timeout():
	target.take_damage(damage);


func _on_BossAttack4_body_exited(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		is_burning = false;
		$BurningTimer.stop();


func _on_WarningTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", false);
	$AnimatedSprite.animation = "Active";
	$DurationTimer.start();


func _on_BossAttack4_area_entered(area):
	var collider_type = area.get_class();
	print(collider_type);
	if collider_type == "ParticleShield":
		area.reflect(damage);

