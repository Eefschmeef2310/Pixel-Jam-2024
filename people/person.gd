extends Node2D

@onready var hair_back = $HairBack
@onready var hair_back_color = $HairBackColor
@onready var base = $Base
@onready var base_clothes = $BaseClothes
@onready var base_skin = $BaseSkin
@onready var face = $Face
@onready var hair_front = $HairFront
@onready var hair_front_color = $HairFrontColor

func _ready():
	generate()

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
