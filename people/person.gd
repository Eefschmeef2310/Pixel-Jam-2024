extends Node2D

@onready var hair_back = $Parts/HairBack
@onready var hair_back_color = $Parts/HairBackColor
@onready var base = $Parts/Base
@onready var base_clothes = $Parts/BaseClothes
@onready var base_skin = $Parts/BaseSkin
@onready var face = $Parts/Face
@onready var hair_front = $Parts/HairFront
@onready var hair_front_color = $Parts/HairFrontColor

var tween: Tween

func _ready():
	generate()
	enter()

func _process(_delta):
	if Input.is_action_just_pressed("Right"):
		generate()

func generate():
	var base_resource: PersonBase = PersonManager.base_textures.pick_random()
	var hair_resource: PersonHair = PersonManager.hair_textures.pick_random()
	
	base.texture = base_resource.base
	base_clothes.texture = base_resource.clothes
	base_clothes.self_modulate = Color.html(PersonManager.clothes_colors.pick_random())
	
	base_skin.texture = base_resource.skin
	base_skin.self_modulate = Color.html(PersonManager.skin_colors.pick_random())
	
	hair_front.texture = hair_resource.front
	hair_front_color.texture = hair_resource.front_color
	hair_back.texture = hair_resource.back
	hair_back_color.texture = hair_resource.back_color
	
	var color = PersonManager.hair_colors.pick_random()
	hair_front_color.self_modulate = Color.html(color)
	hair_back_color.self_modulate = Color.html(color)

func enter():
	global_position.y = 255
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position:y", 108, 1)
	
func exit():
	make_happy()
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "global_position:y", 255, 1)
	tween.tween_callback(queue_free)

func make_normal():
	face.texture = PersonManager.face_normal

func make_happy():
	face.texture = PersonManager.face_happy
	
func make_annoyed():
	face.texture = PersonManager.face_annoyed
