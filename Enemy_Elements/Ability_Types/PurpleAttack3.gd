extends Area2D

var damage: int = 1;
var speed: int = 200;
var direction: Vector2 = Vector2();
var velocity: Vector2 = Vector2();

var target;


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = direction.normalized() * speed;


func _physics_process(delta):
	direction = (target.global_position - global_position);
	position += direction * delta;


func _on_DurationTimer_timeout():
	queue_free();


func _on_PurpleAttack3_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Player":
		body.take_damage(damage);
		queue_free();


func _on_PurpleAttack3_area_entered(area):
	var collider_type = area.get_class();
	print(collider_type);
	if collider_type == "ParticleShield":
		area.reflect(damage);
		queue_free();
