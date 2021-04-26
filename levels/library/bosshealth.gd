extends Control

func update_health(total_health):
	$ProgressBar.value = total_health
	if total_health <= 0:
		queue_free()