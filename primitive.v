module stores

pub struct Primitive<T> {
	pub mut:
		value T
	mut:
		active bool
		subscribers []fn (T)
}

pub fn (mut primitive Primitive<T, S>) subscribe(func fn (T)) fn () {
	primitive.subscribers << func

	if primitive.subscribers.len == 1 {
		primitive.active = true
	}

	func(primitive.value)

	return fn [mut primitive, func]() {
		mut index_of := -1

		for i, func_comp in primitive.subscribers {
			if func_comp == func {
				index_of = i
			}
		}

		if index_of != -1 {
			primitive.subscribers.delete(index_of)
		}

		if primitive.subscribers.len == 0 {
			primitive.active = false
		}
	}
}

pub fn (mut primitive Primitive<T>) set(value T) {
	primitive.value = value	
	
	if primitive.active == false {
		return
	}

	for call_subscriber in primitive.subscribers {
		call_subscriber(primitive.value)
	}
}

pub fn (mut primitive Primitive<T>) update(func fn (T) T) {
	primitive.value = func(primitive.value)	
	
	if primitive.active == false {
		return
	}

	for call_subscriber in primitive.subscribers {
		call_subscriber(primitive.value)
	}
}


fn new_primitive<T>(default_value T) Primitive<T> {
	return Primitive<T>{
		value: default_value
	}
}
