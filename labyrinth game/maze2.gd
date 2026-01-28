extends Node
class_name maze2

var width: int
var height: int
var start: Vector2i
var end: Vector2i
var grid: grid2

class grid2:
	var width: int
	var height: int
	var list: Array[int]
	
	func _init(new_wid: int, new_hei: int):
		width = new_wid
		height = new_hei
		list = []
		list.resize(width*height)
		
	func set_at_point(point: Vector2i, val: int):
		list[point.x + width * point.y] = val
		
	func get_from_point(point: Vector2i)-> int:
		##if point.x < 0 or point.x >= width or point.y < 0 or point.y >= height:
			##return 0
		return list [point.x + width * point.y]
		
	func recycle(wid: int, hei: int):
		list.resize(wid*hei)
		list.fill(0)
		width = wid
		height = hei
	
func _init(wid: int = 10, hei: int = 10):
	width = wid
	height = hei
	
func make_maze():
	if !grid: grid = grid2.new(width, height)
	else: grid.recycle(width, height)
	var card_directions : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	start = Vector2i(randi_range(1, width -2), randi_range(1, height -2))
	end = start
	grid.set_at_point(start, 1)
	var points : Array[Vector2i] = [start]
	var queue : Array[Vector2i] = [start]
	
	while(queue.size() > 0):
		card_directions.shuffle()
		var added = false
		
		var current = queue.back()
		for direction in card_directions:
			var next = current + direction
			
			if next.x <= 0 or next.x >= width-1 or next.y <= 0 or next.y >= height-1: continue
			if grid.get_from_point(next) : continue
			
			var orth = Vector2i(direction.y, direction.x)
			var add_next = true
			for neighbor in [next + orth, next + orth + direction, next + direction, next - orth + direction, next - orth]:
				if neighbor.x <0 or neighbor.x >= width or neighbor.y < 0 or neighbor.y >=height: continue
				if grid.get_from_point(neighbor):
					add_next = false
			break
						
			if add_next:
				points.append(next)
				queue.append(next)
				grid.set_at_point(next, grid.get_from_point(current)+1)
				added = true
				if grid.get_from_point(next) > grid.get_from_point(end):
					end = start
			break
		if !added:
			queue.pop_back()
 
