@tool
extends Node3D

@export var number : int:
	set(new_number):
		number = new_number
		update_texture()
@export var heightChange : float:
	set(new_heightChange):
		heightChange = new_heightChange
		update_texture()
@export var scaleChange : float = 1.0:
	set(new_scaleChange):
		scaleChange = new_scaleChange
		update_texture()
@export var density : float:
	set(new_density):
		density = new_density
		update_texture()
@export var radius : float:
	set(new_radius):
		radius = new_radius
		update_texture()
@export var gradient : GradientTexture1D:
	set(new_gradient):
		gradient = new_gradient
		update_texture()
@export var noiseTexture : NoiseTexture2D:
	set(new_noiseTexture):
		noiseTexture = new_noiseTexture
		update_texture()

func _find_mesh_instance() -> MeshInstance3D:
	for child in get_children():
		if child is MeshInstance3D:
			return child as MeshInstance3D
	return null


func _get_configuration_warning() -> String:
	var shape := _find_mesh_instance()
	if not shape:
		return "This node must have at least one MeshInstance3D child."
	return ""

var base : MeshInstance3D
var instantiatedNodes: Array

func update_texture() -> void:
	for node in instantiatedNodes:
		remove_child(node)
		node.queue_free()
	instantiatedNodes.clear()
	
	update_configuration_warnings()
	for child in get_children():
		if child is MeshInstance3D:
			base = child as MeshInstance3D
	
			for i in range(0, number):
				var plane : MeshInstance3D = base.duplicate(true)
				var grassPlaneMaterial : ShaderMaterial = ShaderMaterial.new()
				plane.set_surface_override_material(0, grassPlaneMaterial)
				grassPlaneMaterial.shader = load("res://grassShader.gdshader")
				grassPlaneMaterial.set_shader_parameter("maxHeight", heightChange + scaleChange - 1)
				grassPlaneMaterial.set_shader_parameter("density", density)
				grassPlaneMaterial.set_shader_parameter("radius", radius)
				grassPlaneMaterial.set_shader_parameter("gradient", gradient)
				grassPlaneMaterial.set_shader_parameter("noiseTexture", noiseTexture)
				grassPlaneMaterial.set_shader_parameter("shellHeight", (float)(i)/number)
				plane.position.y = heightChange * (float)(i+1) / number
				plane.scale += Vector3.ONE * (scaleChange - 1.0) * (float)(i) / number
				
				add_child(plane)
				instantiatedNodes.append(plane)
	print_debug(get_child_count())

func _enter_tree() -> void:
	update_texture()
