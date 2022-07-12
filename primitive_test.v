module stores


fn test_init() {
	println("Test init function")

	primitive_int := new_primitive<int>(10)

	assert primitive_int.value == 10
}

fn test_set() {
	println("Test set function")

	mut primitive_int := new_primitive<int>(10)

	primitive_int.set(2)

	assert primitive_int.value == 2
}

fn test_update() {
	println("Test update function")

	mut primitive_int := new_primitive<int>(10)

	primitive_int.update( fn (value int) int {
		return value * 2
	})

	assert primitive_int.value == 20
}


fn test_subscribe_for_set() {
	println("Test subscribe for set function")

	mut primitive_int := new_primitive<int>(10)
	
	mut value_check := 1
	mut value_check_ref := &value_check
	
	primitive_int.subscribe(fn [mut value_check_ref](value int) {
		
		unsafe {
			*value_check_ref = value
		}
	})
	
	primitive_int.set(20)

	assert value_check == 20
}