extends Node

func compute_expected_target_position(source_pos: Vector3, source_vel: Vector3, shot_speed: float, target_pos:Vector3, target_vel:Vector3) -> Vector3:
	#returns current target position if a solution cannot be calculated
	
	var relative_pos = target_pos - source_pos
	var relative_vel = target_vel - source_vel
	
	#all values are relative to global. result will also be global
	var A = relative_vel.length_squared() - shot_speed*shot_speed
	var B = 2*relative_vel.dot(relative_pos)
	var C = relative_pos.length_squared()

	var discriminant = B*B - 4*A*C

	if discriminant < 0:
		return target_pos

	var t1 = (-B + sqrt(discriminant)) / (2*A)
	var t2 = (-B - sqrt(discriminant)) / (2*A)
	if t1 <= 0 and t2 <= 0:
		return target_pos # no positive solution found
	var t = max(t1,t2)
	
	return target_pos + relative_vel*t
