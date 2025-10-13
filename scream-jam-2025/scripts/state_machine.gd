extends Node

@export var scenes: Array[Node] = [] 
@onready var fade = $Fade

@onready var bgm: AudioStreamPlayer2D = $Sound/BGM
@onready var sfx: AudioStreamPlayer2D = $Sound/SFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## INICIALIZAR GLOBAL
	Global.sm = self
	Global.sfx = sfx
	Global.bgm = bgm
	
	## CONECTAR SEÑALES
	Global.on_transition_end.connect(_on_fade_end)
	Global.on_game_end.connect(_on_game_end)
	
	## PRIMER CAMBIO DE ESCENA
	Global.change_scene(Global.Scenes.GAME)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	var scene = Global.Scenes.NULL;
	if event.is_action_pressed("1"):
		scene = Global.Scenes.INTRO
	if event.is_action_pressed("2"):
		Global.desbloq_ultima = !Global.desbloq_ultima
		scene = Global.Scenes.GAME
	#if event.is_action_pressed("ui_cancel"):
		#get_tree().quit()
	if (scene != Global.Scenes.NULL):
		Global.change_scene(scene)

func _on_game_end():
	pass

#func _on_transition(speed = 1.0) -> void: #fade in
	#fade.transition(speed)


func _on_fade_end() -> void: #justo antes del fadeout, la idea es que esto sea un switch
	# escena a apagar
	scenes[Global.current_scene].visible = false
	scenes[Global.current_scene].on_disable()
	scenes[Global.current_scene].process_mode = Node.PROCESS_MODE_DISABLED

	# escena a encender
	scenes[Global.next_scene].visible = true
	scenes[Global.next_scene].on_enable()
	scenes[Global.next_scene].process_mode = Node.PROCESS_MODE_INHERIT

	Global.current_scene = Global.next_scene	
	
