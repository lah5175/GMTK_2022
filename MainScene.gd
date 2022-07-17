extends Node2D

const Credits = preload("res://CreditsScene.tscn")

var bullet_factory = preload("res://Enemy_Elements/Boss_Abilities/BossBullet.tscn");

onready var boss = $MainScene/Boss;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	randomize();
	boss.connect("bullet_start", self, "_on_Boss_bullet_start");



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Boss_bullet_start():
	$BulletEndTimer.start();
	$BulletTimer.start();

func _on_BulletTimer_timeout():
	var bullet = bullet_factory.instance();
	var bullet_spawn_location = $BulletPath/BulletSpawnLocation;
	bullet_spawn_location.offset = randi();

	var direction = bullet_spawn_location.rotation + PI / 2;
	bullet.position = bullet_spawn_location.position;
	direction += rand_range(-PI / 4, PI / 4);
	bullet.rotation = direction;

	var velocity = Vector2(100.0, 0.0);
	bullet.linear_velocity = velocity.rotated(direction);

	bullet.player = $MainScene/Player; # HACK

	add_child(bullet);


func _on_BulletEndTimer_timeout():
	$BulletTimer.stop();

func _on_TransitionScreen_transitioned():
	$MainScene.add_child(Credits.instance());
