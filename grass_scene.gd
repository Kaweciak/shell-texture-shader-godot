extends Node3D

var grassPlane : MeshInstance3D

@export var number : int
@export var heightChange : float
@export var scaleChange : float = 1.0
@export var density : float
@export var radius : float
@export var gradient : GradientTexture1D
@export var noiseTexture : NoiseTexture2D

func _enter_tree() -> void:
	grassPlane = get_child(0)
	
	var grassPlaneMaterial : ShaderMaterial = ShaderMaterial.new()
	grassPlaneMaterial.shader = load("res://grassShader.gdshader")
	grassPlane.set_surface_override_material(0, grassPlaneMaterial)
	grassPlaneMaterial.set_shader_parameter("maxHeight", heightChange + scaleChange - 1)
	grassPlaneMaterial.set_shader_parameter("density", density)
	grassPlaneMaterial.set_shader_parameter("radius", radius)
	grassPlaneMaterial.set_shader_parameter("gradient", gradient)
	grassPlaneMaterial.set_shader_parameter("noiseTexture", noiseTexture)
	grassPlaneMaterial.set_shader_parameter("shellHeight", 0)

	for i in range(0, number):
		var plane : MeshInstance3D = grassPlane.duplicate(true)
		plane.position.y = heightChange * (float)(i) / number
		plane.scale += Vector3.ONE * (scaleChange - 1.0) * (float)(i) / number
		
		grassPlaneMaterial = plane.get_active_material(0).duplicate(true)
		grassPlaneMaterial.set_shader_parameter("shellHeight", (float)(i)/number)
		plane.set_surface_override_material(0, grassPlaneMaterial)
		add_child(plane)
