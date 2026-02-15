class_name FunctionalTools
extends RefCounted

# Functional helpers to keep iteration consistent across the codebase.


static func map(values: Array, mapper: Callable) -> Array:
	return values.map(mapper)


static func filter(values: Array, predicate: Callable) -> Array:
	return values.filter(predicate)


static func any(values: Array, predicate: Callable) -> bool:
	return values.any(predicate)


static func all(values: Array, predicate: Callable) -> bool:
	return values.all(predicate)


static func for_each(values: Array, action: Callable) -> void:
	values.map(action)


static func reduce(
	values: Array, reducer: Callable, initial_value: Variant = null, use_initial: bool = false
) -> Variant:
	if use_initial:
		return values.reduce(reducer, initial_value)
	return values.reduce(reducer)
