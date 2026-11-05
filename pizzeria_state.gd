class_name PizzeriaState
extends RefCounted

## Coordinates the restaurant's physical stations, queues, and order slots:
## 1. Kitchen Main Table: 1 pizza capacity (MAKE DOUGH, ADD {ingredient}, TRASH)
## 2. Ovens: 4 slots, bakes pizzas over time (INTO OVEN -> first empty, TAKE OUT {slot})
## 3. Slice Station: Queue of pizzas on the counter (only 1 active at a time to "slice")
## 4. Packing Station: 1 boxed pizza capacity ("pack up", "trash", "give {number}")
## 5. Order Slots: 4 customer slots ("take order {number}", "give {number}")

signal kitchen_table_changed(pizza: Pizza)
signal oven_changed(slot_number: int, pizza: Pizza)
signal slice_queue_changed(queue: Array[Pizza])
signal packing_station_changed(pizza: Pizza)
signal order_slot_changed(slot_number: int, order: Order)
signal order_reviewed(slot_number: int, review: Dictionary)

## Available toppings in the kitchen
var available_toppings: Array[String] = ["SAUCE", "CHEESE", "PEPPERONI"]

## Next order number counter (e.g. 101, 102...)
var next_order_number: int = 101

## Stations
var kitchen_table_pizza: Pizza = null
var ovens: Array[Pizza] = [null, null, null, null] # Slots 1..4 (indices 0..3)
var slice_queue: Array[Pizza] = []
var packing_station_pizza: Pizza = null
var order_slots: Array[Order] = [null, null, null, null] # Slots 1..4 (indices 0..3)


func _init() -> void:
	for i in range(4):
		order_slots[i] = Order.new(i + 1, 100 + (i + 1))


## Updates baking progress in all 4 ovens and order patience timers.
func update(delta: float) -> void:
	# 1. Bake pizzas inside ovens
	for i in range(4):
		var p = ovens[i]
		if p != null:
			p.bake(delta)

	# 2. Update customer patience
	for i in range(4):
		var order = order_slots[i]
		if order != null:
			order.update_patience(delta)
			if order.status == Order.Status.EXPIRED:
				order_slot_changed.emit(i + 1, order)


# KITCHEN ACTIONS (Uppercase / Shift held)

## "MAKE DOUGH"
## Creates a new Pizza instance on the kitchen table (table must be empty).
func make_dough() -> bool:
	if kitchen_table_pizza != null:
		return false # Table already occupied

	kitchen_table_pizza = Pizza.new()
	kitchen_table_changed.emit(kitchen_table_pizza)
	return true


## "ADD {TOPPING}"
## Adds a topping to the pizza currently on the kitchen table.
func add_topping(topping: String) -> bool:
	if kitchen_table_pizza == null:
		return false

	var success = kitchen_table_pizza.add_topping(topping)
	if success:
		kitchen_table_changed.emit(kitchen_table_pizza)
	return success


## "TRASH"
## Clears/discards the pizza currently on the kitchen table.
func trash_table() -> bool:
	if kitchen_table_pizza == null:
		return false

	kitchen_table_pizza = null
	kitchen_table_changed.emit(null)
	return true


## "INTO OVEN"
## Moves the pizza from the kitchen table into the first available oven slot (1..4).
## Returns the 1-based oven slot number, or -1 if failed.
func put_into_oven() -> int:
	if kitchen_table_pizza == null:
		return -1

	for i in range(4):
		if ovens[i] == null:
			var slot_number = i + 1
			var pizza = kitchen_table_pizza
			kitchen_table_pizza = null
			kitchen_table_changed.emit(null)

			pizza.put_in_oven(slot_number)
			ovens[i] = pizza
			oven_changed.emit(slot_number, pizza)
			return slot_number

	return -1 # All ovens are full


## "TAKE OUT {oven_number}" (1 to 4)
## Removes the pizza from the specified oven slot and places it into the slice queue.
func take_out_of_oven(oven_number: int) -> bool:
	if oven_number < 1 or oven_number > 4:
		return false

	var idx = oven_number - 1
	var pizza = ovens[idx]
	if pizza == null:
		return false

	ovens[idx] = null
	pizza.take_out_of_oven()
	oven_changed.emit(oven_number, null)

	slice_queue.append(pizza)
	slice_queue_changed.emit(slice_queue)
	return true


# COUNTER ACTIONS (Lowercase / No Shift)

## Takes order by order number or slot number
func take_order_by_number(target_num: int) -> bool:
	# Try by order_number first
	for i in range(4):
		var ord = order_slots[i]
		if ord != null and ord.order_number == target_num and ord.status == Order.Status.WAITING_TO_TAKE:
			var ok = ord.take_order()
			if ok:
				order_slot_changed.emit(i + 1, ord)
			return ok

	# Fallback by slot_number (1 to 4)
	if target_num >= 1 and target_num <= 4:
		var ord = order_slots[target_num - 1]
		if ord != null and ord.status == Order.Status.WAITING_TO_TAKE:
			var ok = ord.take_order()
			if ok:
				order_slot_changed.emit(target_num, ord)
			return ok

	return false


## "slice"
## Slices the pizza at the head of the slice station queue.
func slice_active_pizza() -> bool:
	if slice_queue.is_empty():
		return false

	var active_pizza = slice_queue[0]
	if active_pizza.is_sliced:
		return false # Already sliced

	var ok = active_pizza.slice()
	if ok:
		slice_queue_changed.emit(slice_queue)
	return ok


## "pack up"
## Moves the sliced pizza at the head of the slice queue into the packing station box.
## Only works if the packing station is currently empty.
func pack_up() -> bool:
	if packing_station_pizza != null:
		return false # Box is already occupied; must serve or trash it first

	if slice_queue.is_empty():
		return false # No pizza to pack

	var pizza = slice_queue[0]
	if not pizza.is_sliced:
		return false # Must slice before packing

	slice_queue.remove_at(0)
	slice_queue_changed.emit(slice_queue)

	pizza.box()
	packing_station_pizza = pizza
	packing_station_changed.emit(packing_station_pizza)
	return true


## "trash"
## Clears/discards the boxed pizza currently in the packing station.
func trash_box() -> bool:
	if packing_station_pizza == null:
		return false

	packing_station_pizza = null
	packing_station_changed.emit(null)
	return true


## "give {number}"
## Delivers the boxed pizza to the active order, reviews it, and clears the packing station.
func give_order_by_number(target_num: int) -> Dictionary:
	if packing_station_pizza == null:
		return {}

	var target_slot: int = -1
	# Try by order_number first
	for i in range(4):
		var ord = order_slots[i]
		if ord != null and ord.order_number == target_num and ord.status == Order.Status.ACTIVE:
			target_slot = i + 1
			break

	# Fallback by slot_number (1 to 4)
	if target_slot == -1 and target_num >= 1 and target_num <= 4:
		var ord = order_slots[target_num - 1]
		if ord != null and ord.status == Order.Status.ACTIVE:
			target_slot = target_num

	if target_slot == -1:
		return {}

	var order = order_slots[target_slot - 1]
	var pizza = packing_station_pizza
	packing_station_pizza = null
	packing_station_changed.emit(null)

	var review = order.review_pizza(pizza)
	order_slot_changed.emit(target_slot, order)
	order_reviewed.emit(target_slot, review)
	return review


## Spawns a customer order at the given slot (1 to 4).
func spawn_order(slot_number: int, toppings: Array[String], p_order_patience: float = 80.0, p_food_patience: float = 130.0) -> Order:
	if slot_number < 1 or slot_number > 4:
		return null
	var num = next_order_number
	next_order_number += 1
	var new_order = Order.new(slot_number, num, toppings, p_order_patience, p_food_patience)
	order_slots[slot_number - 1] = new_order
	order_slot_changed.emit(slot_number, new_order)
	return new_order


# COMMAND GENERATION & EXECUTION
## Returns all currently executable kitchen commands based on restaurant state.
func get_valid_kitchen_commands() -> Array[String]:
	var commands: Array[String] = []

	# Main table commands
	if kitchen_table_pizza == null:
		commands.append("MAKE DOUGH")
	else:
		for topping in available_toppings:
			commands.append("ADD %s" % topping)

		# Check if any oven has space
		var has_free_oven = ovens.has(null)
		if has_free_oven:
			commands.append("INTO OVEN")

		commands.append("TRASH")

	# Oven commands
	for i in range(4):
		if ovens[i] != null:
			commands.append("TAKE OUT %d" % (i + 1))

	return commands


## Returns all currently executable counter commands based on restaurant state.
func get_valid_counter_commands() -> Array[String]:
	var commands: Array[String] = []

	# Order slot commands
	for i in range(4):
		var order = order_slots[i]
		if order != null:
			if order.status == Order.Status.WAITING_TO_TAKE:
				commands.append("take order %d" % order.order_number)
			elif order.status == Order.Status.ACTIVE and packing_station_pizza != null:
				commands.append("give %d" % order.order_number)

	# Slicing station commands
	if not slice_queue.is_empty() and not slice_queue[0].is_sliced:
		commands.append("slice")

	# Packing station commands
	if not slice_queue.is_empty() and slice_queue[0].is_sliced and packing_station_pizza == null:
		commands.append("pack up")

	if packing_station_pizza != null:
		commands.append("trash")

	return commands


## Executes a command string. Returns true if the command was recognized and handled.
func execute_command(command: String) -> bool:
	# Kitchen commands (UPPERCASE)
	if command == "MAKE DOUGH":
		return make_dough()
	elif command == "TRASH":
		return trash_table()
	elif command == "INTO OVEN":
		return put_into_oven() != -1
	elif command.begins_with("ADD "):
		var topping = command.substr(4).strip_edges()
		return add_topping(topping)
	elif command.begins_with("TAKE OUT "):
		var num_str = command.substr(9).strip_edges()
		if num_str.is_valid_int():
			return take_out_of_oven(num_str.to_int())

	# Counter commands (lowercase)
	if command.begins_with("take order "):
		var num_str = command.substr(11).strip_edges()
		if num_str.is_valid_int():
			return take_order_by_number(num_str.to_int())
	elif command.begins_with("give "):
		var num_str = command.substr(5).strip_edges()
		if num_str.is_valid_int():
			var review = give_order_by_number(num_str.to_int())
			return not review.is_empty()
	elif command == "slice":
		return slice_active_pizza()
	elif command == "pack up":
		return pack_up()
	elif command == "trash":
		return trash_box()

	return false
