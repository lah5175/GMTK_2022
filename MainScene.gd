extends Node2D

const CREDITS = preload("res://CreditsScene.tscn");
const GAME_OVER = preload("res://GameOver.tscn");

var bullet_factory = preload("res://Enemy_Elements/Boss_Abilities/BossBullet.tscn");

onready var boss = $MainScene/Boss;

# Called when the node enters the scene tree for the first time.
func _ready():
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

func _on_TransitionScreen_transitioned(type):
	$MainScene/FieldBGM.stop();
	$MainScene/BossBGM.stop();
	$MainScene/CreditsBGM.play();
	$MainScene/CanvasLayer/UI.queue_free();
	
	if type == "credits":
		$MainScene.add_child(CREDITS.instance());
	elif type == "game_over":
		$MainScene.add_child(GAME_OVER.instance());
	else:
		print("Invalid scene type, treating as a Game Over");
		$MainScene.add_child(GAME_OVER.instance());
