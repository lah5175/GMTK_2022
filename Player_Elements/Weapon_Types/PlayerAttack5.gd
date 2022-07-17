extends Area2D

var damage: int = 1;
var speed: int = 200;
var direction: Vector2 = Vector2();
var velocity: Vector2 = Vector2();


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = direction.normalized() * speed;


func _physics_process(delta):
	position += velocity * delta;


func _on_Timer_timeout():
	queue_free();


func _on_PlayerAttack5_body_entered(body):
	var collider_type = body.get_class();
	if collider_type == "Enemy":
		body.take_damage(damage);
		body.modulate.a = 0.5;
		body.start_flicker_timer();
		queue_free();
