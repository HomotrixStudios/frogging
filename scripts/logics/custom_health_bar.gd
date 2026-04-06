class_name CustomHealthBar extends ProgressBar

var change_value_tween : Tween
var opacity_tween : Tween

@export var health_gradient: Gradient

func setup_health_bar(max_val : float):
	modulate.a = 1.0 #so we can make it visible/invisible in a smoother way. Update: Removed invisibility
	max_value = max_val
	value = max_value
	$ProgressBar.value = max_val
	$ProgressBar.max_value = max_val

	#To display the color initially
	if health_gradient: 
		var current_color = health_gradient.sample(1.0) 
		
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = current_color
		add_theme_stylebox_override("fill", style_box)


func change_value(new_value : float):
	# change_opacity(1.0) #For invisibility
	# await opacity_tween.finished

	value = new_value

	var health_percent = new_value / max_value #calculate the percent of health
	
	# 2. Peschiamo il colore esatto dal gradiente
	var current_color = health_gradient.sample(health_percent)

	var style_box = StyleBoxFlat.new()
	style_box.bg_color = current_color
	add_theme_stylebox_override("fill", style_box)  

	if change_value_tween:
		change_value_tween.kill()
	change_value_tween = create_tween()
	# change_value_tween.finished.connect($ResetVisibility.start) #reset the visibility at the end of the timer
	change_value_tween.tween_property($ProgressBar, "value", new_value, 0.35).set_trans(Tween.TRANS_SINE)

func change_opacity(new_amount : float):
	if opacity_tween: #check if it's already running
		opacity_tween.kill()
	opacity_tween = create_tween()
	#we change the opacity of the bar (with a custom amount) with an animation of 0.12
	opacity_tween.tween_property(self, "modulate:a", new_amount, 0.12).set_trans(Tween.TRANS_SINE)

#For invisibility
# func _on_reset_visibility_timeout() -> void:
# 	change_opacity(0.0)
