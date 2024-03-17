extends Node

@export var person_scene: PackedScene

@export var base_textures: Array[PersonBase]
@export var hair_textures: Array[PersonHair]

var skin_colors: Array[String] = [
	"#fdcbb0",
	"#fca790",
	"#e6904e",
	"#966c6c",
	"#694f62",
	"#f68181",
]

var clothes_colors: Array[String] = [
	"#4d9be6",
	"#0eaf9b",
	"#1ebc73",
	"#c32454",
	"#eaaded",
	"#905ea9",
	"#fb6b1d",
	"#fbb954",
	"#f04f78",
	"#239063",
]

var hair_colors: Array[String] = [
	"#966c6c",
	"#3e3546",
	"#fbb954",
	"#b2ba90",
	"#9e4539",
	"#ea4f36",
	"#45293f",
	"#eaaded",
]

var face_normal = preload("res://people/sprites/face_normal.png")
var face_happy = preload("res://people/sprites/face_happy.png")
var face_annoyed = preload("res://people/sprites/face_annoyed.png")

var person_container_node
var smoothie_container_node
