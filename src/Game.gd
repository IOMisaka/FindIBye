extends Control

#status
var running = false

#config
var configFile = "user://data3.json"
var config = {"version":3,"count":0,"type":0}

#alert color
var colorab = Color("#66ffff")
var colorwj = Color("#aaff66")
var alert_color = colorab setget ,get_alert_color
func get_alert_color():
	if config.type==4:
		return colorwj
	return colorab
#color text
var textab = "[center]总共找到[color=#66ffff]%s[/color]只[/center]"
var textwj = "[center]总共找到[color=#aaff66]%s[/color]只[/center]"
var text = textab setget ,get_colored_text
func get_colored_text():
	if config.type == 4:
		return textwj
	return textab

#score
var score = 0 setget set_score,get_score
func set_score(value):
	config.count = value
func get_score():
	return config.count

onready var medal = $UI/Panel/Label4
var medal_list = [
	"不堪一击",
	"毫不足虑",
	"不足挂齿",
	"初学乍练",
	"勉勉强强",
	"初窥门径",
	"初出茅庐",
	"略知一二",
	"普普通通",
	"平平常常",
	"平淡无奇",
	"粗懂皮毛",
	"半生不熟",
	"登堂入室",
	"略有小成",
	"已有小成",
	"鹤立鸡群",
	"驾轻就熟",
	"青出於蓝",
	"融会贯通",
	"心领神会",
	"炉火纯青",
	"了然於胸",
	"略有大成",
	"已有大成",
	"豁然贯通",
	"非比寻常",
	"出类拔萃",
	"罕有敌手",
	"技冠群雄",
	"神乎其技",
	"出神入化",
	"傲视群雄",
	"登峰造极",
	"无与伦比",
	"所向披靡",
	"一代宗师",
	"精深奥妙",
	"神功盖世",
	"举世无双",
	"惊世骇俗",
	"撼天动地",
	"震古铄今",
	"超凡入圣",
	"威镇寰宇",
	"空前绝后",
	"天人合一",
	"深藏不露",
	"深不可测",
	"返璞归真",
	"蚌埠住了"
]

#control
onready var audio = $AudioClassic
onready var video = $VideoPlayer
var audio_list = [
	preload("res://assets/voice/v1_laugh.ogg"),
	preload("res://assets/voice/v2_skr.ogg"),
	preload("res://assets/voice/v3_bl.ogg"),
	preload("res://assets/voice/v4_yyh.ogg"),
	preload("res://assets/voice/v5_wj.ogg")
]
var video_list = [
	preload("res://assets/video/v1_ge.webm"),
	preload("res://assets/video/v2_ge.webm"),
	preload("res://assets/video/v3_ge.webm"),
	preload("res://assets/video/v4_ge.webm"),
	preload("res://assets/video/v5_ge.webm"),
]

#option list
var prompt_next = "找到[color=red]%s[/color]只解锁下一个"
var prompt_all = "已全部解锁"
onready var next = $UI/Panel/Label3
var option_list = [
	{"score":0,"text":"嗝"},
	{"score":10,"text":"咩"},
	{"score":20,"text":"嗯"},
	{"score":30,"text":"云与海"},
	{"score":50,"text":"绿色肥鸡"},
]
onready var option = $UI/Panel/OptionButton
var icon_ab = preload("res://assets/image/ibye_small.png")
var icon_wj = preload("res://assets/image/wj_small.png")
var ab = preload("res://assets/image/ibye.png")
var wj = preload("res://assets/image/wj.webp")

var max_item_count = 0
func set_options():
	option.clear()
	var next_score = 0
	for obj in option_list:
		if self.score>=obj.score:
			if obj.score == 50:
				option.add_icon_item(icon_wj,obj.text)
			else:
				option.add_icon_item(icon_ab,obj.text)
		else:
			next_score = obj.score
			break
	var is_add_new = false
	if max_item_count != 0:
		if max_item_count < option.get_item_count():
			is_add_new = true
			
	max_item_count = option.get_item_count()
	
	#select new one
	if is_add_new:
		option.select(option.get_item_count()-1)
		option.emit_signal("item_selected",option.get_item_count()-1)
	else:
		option.select(config.type)
	
	if self.score < 30:
		next.text = prompt_next % next_score
	elif self.score >= 50:
		next.text = prompt_all
	else:
		next.text = ""

func _ready():
	randomize()
	$IBye.hide()
	$RedAlert.hide()
	video.hide()
	
	load_data()
	set_show()
	set_options()

func _process(_delta):
	if running:
		var dis = get_global_mouse_position().distance_to($IBye.rect_global_position+$IBye.rect_size/2)
		var db = - sqrt(dis)+8 #-4*log(dis)+20
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
	
	if config.type != 3:
		audio.stop()
	
	video.show()
	video.play()
	$RedAlert.hide()


func _on_VideoPlayer_finished():
	self.score = self.score+1
	$UI/Panel/Text.bbcode_text = text % self.score
	medal.text = medal_list[min(int(sqrt(self.score+1)),medal_list.size())-1]
	
	$UI.show()
	video.hide()
	$IBye.hide()
	
	#refresh option
	set_options()
	#save
	save_data()


func _on_Control_resized():
	if running:
		restart()
	
func restart():
	$IBye.disabled = false
	$UI.hide()
	$IBye.show()
	
	var size = get_viewport_rect().size
	var x = rand_range(0,size.x-64)
	var y = rand_range(0,size.y-64)
	#print_debug(size,x,y)
	$IBye.set_position(Vector2(x,y))
	if not OS.is_debug_build():
		$IBye.modulate.a=0.001
	audio.volume_db = -100
	
	if !audio.playing:
		audio.play()
	
	running = true

#choose type
func _on_OptionButton_item_selected(index):
	config.type = index
	save_data()
	set_show()
	
func set_show():
	audio.stream = audio_list[config.type]
	video.stream = video_list[config.type]
	$UI/Panel/Text.bbcode_text = text % self.score
	$RedAlert.color = alert_color
	medal.text = medal_list[min(int(sqrt(self.score+1)),medal_list.size())-1]
	if config.type == 3:
		audio.play()
	if config.type == 4:
		$IBye.texture_normal = wj
	else:
		$IBye.texture_normal = ab

func load_data():
	var file = File.new()
	if file.file_exists(configFile):
		file.open(configFile,File.READ)
		config = str2var(file.get_as_text())
		file.close()
		
func save_data():
	var file = File.new()
	file.open(configFile,File.WRITE)
	file.store_string(var2str(config))
	file.close()

