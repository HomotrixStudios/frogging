extends EnemyState

@export var hitbox_shape : Shape2D
@onready var attack_timer : Timer = $AttackTimer


func enter() -> void:
    attack_timer.start()
    enemy.animation_player.play("meele_attack")
    
func hit() -> void:
    var hitbox = Hitbox.new(enemy.stats, 0.35, hitbox_shape, enemy)
    enemy.add_child(hitbox)
    hitbox.global_position = enemy.muzzle.global_position

func _on_attack_timer_timeout() -> void:
    enemy.cooldown_timer.start()
    enemy.state_machine.change_state("FollowState")

