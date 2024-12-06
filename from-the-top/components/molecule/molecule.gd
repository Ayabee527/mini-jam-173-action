class_name MoleculeComponent
extends Node2D

signal split(molecules: Array[MoleculeComponent])

const BASE_JIGGLE: float = 50.0

@export var atoms: Array[AtomData]:
	set = update_atoms
var target_atom_positions: Array[Vector2]
var atom_positions: Array[Vector2]

var center_atom: AtomData = null

var time: float = 0.0

func _process(delta: float) -> void:
	global_rotation_degrees += 180.0 * delta
	
	for i: int in target_atom_positions.size():
		var target_pos: Vector2 = target_atom_positions[i]
		atom_positions[i] = lerp(atom_positions[i], target_pos, delta * 7.5)
	
	time += delta
	time = fposmod(time, TAU * 200.0)
	
	queue_redraw()

func _draw() -> void:
	if atoms:
		draw_cluster()

func draw_electrons() -> void:
	pass

func draw_cluster() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	
	for i: int in atoms.size():
		var atom: AtomData = atoms[i]
		
		var energy: float = float(atom.energy) / atom.energy_cap
		var jostle: Vector2 = Vector2(randf_range(0.5, 2.0), randf_range(0.5, 2.0)) * energy
		var pos = atom_positions[i]
		pos += Vector2(
			jostle.x * sin(BASE_JIGGLE * energy * time),
			jostle.y * cos(BASE_JIGGLE * energy * time)
		)
		
		draw_circle(
			pos, atom.radius + 1.0, Color.BLACK
		)
		draw_circle(
			pos, atom.radius, atom.color, false, 1.0
		)

func get_biggest_atom(checked_atoms: Array[AtomData]) -> AtomData:
	var max_rad: float = 0.0
	var biggest_atom: AtomData = null
	for atom in atoms:
		if atom.radius > max_rad:
			max_rad = atom.radius
			biggest_atom = atom
	
	return biggest_atom

func update_atoms(new_atoms: Array[AtomData]) -> void:
	atoms = new_atoms
	center_atom = get_biggest_atom(atoms)
	atoms.shuffle()
	atoms.erase(center_atom)
	atoms.insert(ceilf(atoms.size() / 2.0), center_atom)
	update_atom_positions()

func update_atom_positions() -> void:
	target_atom_positions.clear()
	
	var average_rad: float = 0.0
	for atom: AtomData in atoms:
		average_rad += atom.radius
	average_rad /= atoms.size()
	
	var spread_angle = TAU / ( atoms.size() - 1 )
	
	var atoms_dupe: Array[AtomData] = atoms.duplicate()
	atoms_dupe.erase(center_atom)
	
	for i: int in atoms_dupe.size():
		var atom: AtomData = atoms_dupe[i]
		
		#var atom_angle = (spread_angle * i)
		var atom_angle = (spread_angle * i) + deg_to_rad(randf_range(-15.0, 15.0))
		var dist_radius: float = atom.radius + ( (atom.radius / average_rad) * atoms.size() )
		dist_radius = clampf(dist_radius, atom.radius, atom.radius * 2.0) * randf_range(0.8, 1.0)
		var atom_pos = Vector2.from_angle(atom_angle) * dist_radius
		target_atom_positions.append(atom_pos)
	
	var center_idx: int = atoms.find(center_atom)
	target_atom_positions.insert(center_idx, Vector2.ZERO)
	
	atom_positions.resize(target_atom_positions.size())
	atom_positions.fill(Vector2.ZERO)

func split_molecule(angry_atom: AtomData) -> void:
	pass

func add_energy(amount: int = 1) -> void:
	var chosen_atom: AtomData = atoms.pick_random() as AtomData
	chosen_atom.energy += amount
