extends Control

var configFile = "user://data.json"
var config = {"count":0,"countab":0,"countwj":0,"type":""}
var running = false
var colorab = Color("#66ffff")
var colorwj = Color("#aaff66")
var textab = "[center]你已找到[color=#66ffff]%s[/color]只[/center]"
var textwj = "[center]你已找到[color=#aaff66]%s[/color]只[/center]"
var text = textab

onready var audio = $AudioClassic
onready var video = $VideoPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$IBye.hide()
	$RedAlert.hide()
	video.hide()
	var file = File.new()
	if file.file_exists(configFile):
		file.open(configFile,File.READ)
		config = str2var(file.get_as_text())
		file.close()
	
	$CC/Panel/Text.bbcode_text = text % config.count

func _process(_delta):
	if running:
		var dis = get_global_mouse_position().distance_to($IBye.rect_global_position+$IBye.rect_size/2)
		var db = - sqrt(dis)+10 #-4*log(dis)+20
		audio.volume_db = db
		$RedAlert.visible = $IBye.get_global_rect().has_point(get_global_mouse_position())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func _notification(what):
#	if what == NOTIFICATION_WM_GO_BACK_REQUEST or what == NOTIFICATION_WM_QUIT_REQUEST:
#		var file = File.new()
#		file.open(configFile,File.WRITE)
#		file.store_string(var2str(config))
#		file.close()

func _on_Start_pressed():
	restart()
	


func _on_IBye_mouse_entered():
	$RedAlert.show()


func _on_IBye_mouse_exited():
	$RedAlert.hide()


func _on_IBye_pressed():
	running = false
	
	$IBye.disabled = true
	$IBye.modulate.a=1
	audio.stop()
	video.show()
	video.play()
	$RedAlert.hide()


func _on_VideoPlayer_finished():
	config.count=int(config.count)+1
	$CC/Panel/Text.bbcode_text = text % config.count
	$CC.show()
	video.hide()
	$IBye.hide()
	
	#save
	var file = File.new()
	file.open(configFile,File.WRITE)
	file.store_string(var2str(config))
	file.close()


func _on_Control_resized():
	if running:
		restart()
	
func restart():
	$IBye.disabled = false
	$CC.hide()
	$IBye.show()
	
	var size = get_viewport_rect().size
	var x = rand_range(0,size.x-64)
	var y = rand_range(0,size.y-64)
	print_debug(size,x,y)
	$IBye.set_position(Vector2(x,y))
	if not OS.is_debug_build():
		$IBye.modulate.a=0.001
	audio.volume_db = -100
	audio.play()
	
	running = true
