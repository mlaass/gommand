class_name Guard
extends RefCounted


static func against(condition: bool, message: String = "Guard condition failed.") -> void:
	if not condition:
		return
	push_error(message)


static func against_null(value: Variant, message: String = "Expected value to be non-null.") -> void:
	return against(value == null, message)


static func against_false(value: bool, message: String = "Expected value to be true.") -> void:
	return against(value == false, message)


static func against_true(value: bool, message: String = "Expected value to be false.") -> void:
	return against(value == true, message)

static func against_empty_array(value: Array, message: String = "Expected array to be non-empty.") -> void:
	return against(value.is_empty(), message)

static func against_empty_string(value: String, message: String = "Expected string to be non-empty.") -> void:
	return against(value.is_empty(), message)


static func against_invalid_instance(value: Object, message: String = "Expected instance to be valid.") -> void:
	return against(not is_instance_valid(value), message)

static func against_negative(value: float, message: String = "Expected value to be non-negative.") -> void:
	return against(value < 0.0, message)

static func against_zero(value: float, message: String = "Expected value to be non-zero.") -> void:
	return against(value == 0.0, message)
