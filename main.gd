extends Control

@onready var counter: Control = $Counter
@onready var kitchen: Control = $Kitchen
@onready var time_up_panel: Panel = $TimeUpPanel

var pizzeria: PizzeriaState = PizzeriaState.new()

# TEXTURE ASSETS
var tex_uncooked: Texture2D = null
var tex_cooked: Texture2D = null
var tex_sauce: Texture2D = null
var tex_cheese_unmelted: Texture2D = null
var tex_cheese_melted: Texture2D = null
var tex_pepperoni: Texture2D = null
var tex_slice4: Texture2D = null
var tex_slice8: Texture2D = null
var tex_slice1_order: Texture2D = null
var tex_slice4_order: Texture2D = null
var tex_slice8_order: Texture2D = null
var tex_box_open: Texture2D = null
var tex_box_closed: Texture2D = null
var tex_timesup: Texture2D = null

# OVEN STYLEBOXES
var style_oven_on: StyleBoxTexture = null
var style_oven_off: StyleBoxTexture = null

# GAME TIMER & MONEY TRACKER
var game_time: float = 120.0 # 2 minutes countdown
var money: int = 0
var is_game_over: bool = false

# COUNTER NODE REFERENCES
@onready var order_slot_nodes = [
	{
		"container": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1,
		"title": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/TitlePanel/TitleLbl,
		"toppings": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/ToppingLbl,
		"slice_1": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice1,
		"slice_4": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice4,
		"slice_8": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice8,
		"take_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/TakeOrder,
		"give_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot1/OrderMargin/OrderVBox/GiveOrder,
	},
	{
		"container": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2,
		"title": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/TitlePanel/TitleLbl,
		"toppings": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/ToppingLbl,
		"slice_1": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice1,
		"slice_4": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice4,
		"slice_8": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice8,
		"take_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/TakeOrder,
		"give_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot2/OrderMargin/OrderVBox/GiveOrder,
	},
	{
		"container": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3,
		"title": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/TitlePanel/TitleLbl,
		"toppings": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/ToppingLbl,
		"slice_1": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice1,
		"slice_4": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice4,
		"slice_8": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice8,
		"take_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/TakeOrder,
		"give_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot3/OrderMargin/OrderVBox/GiveOrder,
	},
	{
		"container": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4,
		"title": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/TitlePanel/TitleLbl,
		"toppings": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/ToppingLbl,
		"slice_1": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice1,
		"slice_4": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice4,
		"slice_8": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/ToppingPanel/ToppingVBox/SliceIndHBox/Slice8,
		"take_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/TakeOrder,
		"give_order": $Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/OrderSlot4/OrderMargin/OrderVBox/GiveOrder,
	}
]

@onready var slice_texture: TextureRect = $Counter/MainMargin/MainVBox/CounterContainer/SlicePanel/SliceMargin/SliceVBox/BoardTexture/SliceTexture
@onready var slice_4_label: RichTextLabel = $Counter/MainMargin/MainVBox/CounterContainer/SlicePanel/SliceMargin/SliceVBox/SliceHBox/Slice4
@onready var slice_8_label: RichTextLabel = $Counter/MainMargin/MainVBox/CounterContainer/SlicePanel/SliceMargin/SliceVBox/SliceHBox/Slice8

@onready var box_background: TextureRect = $Counter/MainMargin/MainVBox/CounterContainer/BoxPanel/BoxTexture
@onready var box_pizza_texture: TextureRect = $Counter/MainMargin/MainVBox/CounterContainer/BoxPanel/BoxMargin/BoxVBox/BoxTexture
@onready var pack_up_label: RichTextLabel = $Counter/MainMargin/MainVBox/CounterContainer/BoxPanel/BoxMargin/BoxVBox/PackUp

@onready var money_label: Label = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/MoneyPanel/Money
@onready var time_label: Label = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/TimePanel/Time
@onready var counter_trash_label: RichTextLabel = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/Trash

# KITCHEN NODE REFERENCES
@onready var sauce_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Sauce
@onready var cheese_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Cheese
@onready var pepperoni_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Pepperoni
@onready var make_dough_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/MakeDough

@onready var add_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/PizzaPanel/PizzaMargin/PizzaVBox/Add
@onready var kitchen_pizza_texture: TextureRect = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/PizzaPanel/PizzaMargin/PizzaVBox/BoardTexture/PizzaTexture
@onready var into_oven_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/PizzaPanel/PizzaMargin/PizzaVBox/IntoOven
@onready var kitchen_trash_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/PizzaPanel/PizzaMargin/PizzaVBox/Trash

@onready var take_out_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/TakeOut

@onready var oven_panels: Array[PanelContainer] = [
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel1,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel2,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel3,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel4
]

@onready var oven_slot_labels: Array[RichTextLabel] = [
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel1/CommandContainer.get_node("1") as RichTextLabel,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel2/CommandContainer.get_node("2") as RichTextLabel,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel3/CommandContainer.get_node("3") as RichTextLabel,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel4/CommandContainer.get_node("4") as RichTextLabel
]

@onready var oven_sliders: Array[HSlider] = [
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel1/HSlider,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel2/HSlider,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel3/HSlider,
	$Kitchen/MainContainer/MainHBox/OvenPanel/OvenMargin/OvenVBox/OvenPanel4/HSlider
]

# Active command descriptor structures:
# { "command": String, "completion": int, "label": RichTextLabel, "prefix": String, "action": String }
var active_kitchen_targets: Array[Dictionary] = []
var active_counter_targets: Array[Dictionary] = []

# Order spawner timer
var order_timer: float = 0.0
const ORDER_INTERVAL: float = 20.0


func _ready() -> void:
	# Load image textures
	tex_uncooked = load("res://textures/pizza_uncooked.png")
	tex_cooked = load("res://textures/pizza_cooked.png")
	tex_sauce = load("res://textures/sauce.png")
	tex_cheese_unmelted = load("res://textures/cheese_unmelted.png")
	tex_cheese_melted = load("res://textures/cheese_melted.png")
	tex_pepperoni = load("res://textures/pepperoni.png")
	tex_slice4 = load("res://textures/slice4.png")
	tex_slice8 = load("res://textures/slice8.png")
	tex_slice1_order = load("res://textures/slice1_order.png")
	tex_slice4_order = load("res://textures/slice4_order.png")
	tex_slice8_order = load("res://textures/slice8_order.png")
	tex_box_open = load("res://textures/box_open.png")
	tex_box_closed = load("res://textures/box_closed.png")
	tex_timesup = load("res://textures/timesup.png")

	# Setup oven StyleBoxTextures for empty/off and baking/on
	style_oven_off = StyleBoxTexture.new()
	style_oven_off.texture = load("res://textures/oven_off.png")
	style_oven_off.expand_margin_top = 80.0
	style_oven_off.expand_margin_bottom = 80.0

	style_oven_on = StyleBoxTexture.new()
	style_oven_on.texture = load("res://textures/oven_on.png")
	style_oven_on.expand_margin_top = 80.0
	style_oven_on.expand_margin_bottom = 80.0

	# Ensure order slice textures are set (fallback if not assigned in scene)
	for slot in order_slot_nodes:
		if slot["slice_1"].texture == null:
			slot["slice_1"].texture = tex_slice1_order
		if slot["slice_4"].texture == null:
			slot["slice_4"].texture = tex_slice4_order
		if slot["slice_8"].texture == null:
			slot["slice_8"].texture = tex_slice8_order

	# Ensure slice texture on cutting board fills the board nicely
	slice_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	slice_texture.offset_left = 0
	slice_texture.offset_top = 0
	slice_texture.offset_right = 0
	slice_texture.offset_bottom = 0

	# Configure TimeUpPanel graphic
	time_up_panel.custom_minimum_size = Vector2(500, 250)
	var timesup_rect = time_up_panel.get_node_or_null("TimesUpTexture") as TextureRect
	if timesup_rect == null:
		timesup_rect = TextureRect.new()
		timesup_rect.name = "TimesUpTexture"
		timesup_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		timesup_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		timesup_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		timesup_rect.texture = tex_timesup
		timesup_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		time_up_panel.add_child(timesup_rect)
	var timesup_lbl = time_up_panel.get_node_or_null("TimesUp") as Label
	if timesup_lbl != null:
		timesup_lbl.hide()

	# Configure oven sliders
	for slider in oven_sliders:
		slider.min_value = 0.0
		slider.max_value = Pizza.TIME_BURNT
		slider.value = 0.0

	# Hide TimeUpPanel at start
	time_up_panel.hide()

	# Connect pizzeria signals
	pizzeria.kitchen_table_changed.connect(_on_state_updated)
	pizzeria.oven_changed.connect(_on_oven_updated)
	pizzeria.slice_queue_changed.connect(_on_state_updated)
	pizzeria.packing_station_changed.connect(_on_state_updated)
	pizzeria.order_slot_changed.connect(_on_order_updated)
	pizzeria.order_reviewed.connect(_on_order_reviewed)
	pizzeria.order_expired.connect(_on_order_expired)

	# Spawn initial customer orders with generous waiting times and slice requirements
	pizzeria.spawn_order(1, ["SAUCE", "CHEESE", "PEPPERONI"], 90.0, 150.0, 4)
	pizzeria.spawn_order(2, ["CHEESE"], 80.0, 130.0, 8)

	update_time_display()
	update_money_display()
	refresh_ui()


func _process(delta: float) -> void:
	if is_game_over:
		return

	# Countdown overall game timer
	game_time = maxf(0.0, game_time - delta)
	update_time_display()
	if game_time <= 0.0:
		trigger_game_over()
		return

	# Update simulation (baking timers, customer patience)
	pizzeria.update(delta)

	# Customer order spawner
	order_timer += delta
	if order_timer >= ORDER_INTERVAL:
		order_timer = 0.0
		spawn_random_order()

	# Dimension switch: Hold Shift for Kitchen, release for Counter
	if Input.is_action_pressed("hold_shift"):
		counter.hide()
		kitchen.show()
	else:
		kitchen.hide()
		counter.show()

	# Continuously update dynamic displays (patience countdowns, oven bars & stages)
	update_order_cards()
	update_oven_progress()


func _unhandled_key_input(event: InputEvent) -> void:
	if is_game_over:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SHIFT or event.keycode == KEY_CAPSLOCK:
			return

		var typed_char = char(event.unicode)
		var is_kitchen = Input.is_action_pressed("hold_shift")

		# Normalize casing by dimension so Caps Lock never breaks typing
		if is_kitchen:
			# In kitchen, holding Shift produces symbols for top-row numbers.
			# Map symbols and keycodes to '1', '2', '3', '4' so '! ' counts as '1', etc.
			if typed_char == "!" or event.physical_keycode == KEY_1 or event.keycode == KEY_1 or event.keycode == KEY_KP_1:
				typed_char = "1"
			elif typed_char == "@" or typed_char == "\"" or event.physical_keycode == KEY_2 or event.keycode == KEY_2 or event.keycode == KEY_KP_2:
				typed_char = "2"
			elif typed_char == "#" or typed_char == "+" or event.physical_keycode == KEY_3 or event.keycode == KEY_3 or event.keycode == KEY_KP_3:
				typed_char = "3"
			elif typed_char == "$" or typed_char == "%" or event.physical_keycode == KEY_4 or event.keycode == KEY_4 or event.keycode == KEY_KP_4:
				typed_char = "4"
			else:
				# Kitchen commands are always UPPERCASE
				typed_char = typed_char.to_upper()
		else:
			# Counter commands are always lowercase, regardless of Caps Lock state
			typed_char = typed_char.to_lower()

		if typed_char.length() == 0:
			return

		var targets = active_kitchen_targets if is_kitchen else active_counter_targets
		var completed_action: String = ""

		for item in targets:
			var command: String = item["command"]
			var current_comp: int = item["completion"]

			if current_comp < command.length():
				var expected_char = command[current_comp]
				if typed_char == expected_char:
					item["completion"] = current_comp + 1
				else:
					item["completion"] = 0

			if item["completion"] >= command.length():
				completed_action = item.get("action", command)
				item["completion"] = 0

		render_all_targets(targets, is_kitchen)

		if completed_action != "":
			print("Executed: ", completed_action)
			pizzeria.execute_command(completed_action)
			refresh_ui()


func trigger_game_over() -> void:
	is_game_over = true
	time_up_panel.show()


func update_time_display() -> void:
	var total_sec = int(ceil(game_time))
	var minutes = total_sec / 60
	var seconds = total_sec % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]


func update_money_display() -> void:
	if money >= 0:
		money_label.text = "$%d" % money
	else:
		money_label.text = "-$%d" % abs(money)


# Rebuilds active typing targets and syncs station visuals.
func refresh_ui() -> void:
	build_counter_targets()
	build_kitchen_targets()
	update_order_cards()
	update_counter_station_visuals()
	update_kitchen_station_visuals()
	update_oven_progress()


# TYPING TARGET REGISTRATION
func build_counter_targets() -> void:
	var old_completions = {}
	for t in active_counter_targets:
		old_completions[t["command"]] = t["completion"]

	active_counter_targets.clear()

	# 1. Order cards: "take order {num}" or "give {num}"
	for i in range(4):
		var order = pizzeria.order_slots[i]
		if order != null:
			if order.status == Order.Status.WAITING_TO_TAKE:
				var cmd = "take order %d" % order.order_number
				active_counter_targets.append({
					"command": cmd,
					"completion": old_completions.get(cmd, 0),
					"label": order_slot_nodes[i]["take_order"],
					"prefix": "",
					"action": cmd
				})
			elif order.status == Order.Status.ACTIVE and pizzeria.packing_station_pizza != null:
				var cmd = "give %d" % order.order_number
				active_counter_targets.append({
					"command": cmd,
					"completion": old_completions.get(cmd, 0),
					"label": order_slot_nodes[i]["give_order"],
					"prefix": "",
					"action": cmd
				})

	# 2. Slice station: "slice 4" and "slice 8" (pizza can be sliced once)
	if not pizzeria.slice_queue.is_empty() and not pizzeria.slice_queue[0].is_sliced:
		active_counter_targets.append({
			"command": "slice 4",
			"completion": old_completions.get("slice 4", 0),
			"label": slice_4_label,
			"prefix": "",
			"action": "slice 4"
		})
		active_counter_targets.append({
			"command": "slice 8",
			"completion": old_completions.get("slice 8", 0),
			"label": slice_8_label,
			"prefix": "",
			"action": "slice 8"
		})

	# 3. Packing box station: "pack up" (works for sliced or unsliced pizzas if box is free)
	if not pizzeria.slice_queue.is_empty() and pizzeria.packing_station_pizza == null:
		active_counter_targets.append({
			"command": "pack up",
			"completion": old_completions.get("pack up", 0),
			"label": pack_up_label,
			"prefix": "",
			"action": "pack up"
		})

	# 4. Trash station: "trash"
	if pizzeria.packing_station_pizza != null:
		active_counter_targets.append({
			"command": "trash",
			"completion": old_completions.get("trash", 0),
			"label": counter_trash_label,
			"prefix": "",
			"action": "trash"
		})

	render_all_targets(active_counter_targets, false)


func build_kitchen_targets() -> void:
	var old_completions = {}
	for t in active_kitchen_targets:
		old_completions[t["command"]] = t["completion"]

	active_kitchen_targets.clear()

	# 1. Main table empty: "MAKE DOUGH"
	if pizzeria.kitchen_table_pizza == null:
		active_kitchen_targets.append({
			"command": "MAKE DOUGH",
			"completion": old_completions.get("MAKE DOUGH", 0),
			"label": make_dough_label,
			"prefix": "",
			"action": "MAKE DOUGH"
		})
	else:
		# 2. Pizza on table: Ingredients ("ADD SAUCE", "ADD CHEESE", "ADD PEPPERONI")
		var topping_labels = {
			"SAUCE": sauce_label,
			"CHEESE": cheese_label,
			"PEPPERONI": pepperoni_label
		}

		for topping in pizzeria.available_toppings:
			var lbl = topping_labels.get(topping)
			if lbl != null:
				var full_cmd = "ADD %s" % topping
				active_kitchen_targets.append({
					"command": full_cmd,
					"completion": old_completions.get(full_cmd, 0),
					"label": lbl,
					"prefix": "ADD ",
					"action": full_cmd
				})

		# 3. "INTO OVEN"
		if pizzeria.ovens.has(null):
			active_kitchen_targets.append({
				"command": "INTO OVEN",
				"completion": old_completions.get("INTO OVEN", 0),
				"label": into_oven_label,
				"prefix": "",
				"action": "INTO OVEN"
			})

		# 4. "TRASH"
		active_kitchen_targets.append({
			"command": "TRASH",
			"completion": old_completions.get("TRASH", 0),
			"label": kitchen_trash_label,
			"prefix": "",
			"action": "TRASH"
		})

	# 5. Ovens: "TAKE OUT 1", "TAKE OUT 2", etc.
	for i in range(4):
		if pizzeria.ovens[i] != null:
			var slot_num = i + 1
			var cmd = "TAKE OUT %d" % slot_num
			active_kitchen_targets.append({
				"command": cmd,
				"completion": old_completions.get(cmd, 0),
				"label": oven_slot_labels[i],
				"prefix": "TAKE OUT ",
				"action": cmd
			})

	render_all_targets(active_kitchen_targets, true)


## Renders green BBCode highlight for all targets, aggregating shared prefixes correctly,
## and disables/dims ingredients and oven numbers until their prefix ("ADD " / "TAKE OUT ") is typed.
func render_all_targets(targets: Array[Dictionary], is_kitchen: bool) -> void:
	if is_kitchen:
		var has_pizza = (pizzeria.kitchen_table_pizza != null)

		# Calculate shared prefix progression
		var max_add_comp: int = 0
		var max_takeout_comp: int = 0

		for item in targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			if cmd.begins_with("ADD "):
				max_add_comp = maxi(max_add_comp, mini(comp, 4))
			elif cmd.begins_with("TAKE OUT "):
				max_takeout_comp = maxi(max_takeout_comp, mini(comp, 9))

		# Render ADD prefix label above prep table
		var add_pref = "ADD "
		var typed_add = add_pref.substr(0, max_add_comp)
		var untyped_add = add_pref.substr(max_add_comp)
		add_label.text = "[color=green]" + typed_add + "[/color]" + untyped_add
		add_label.modulate = Color(1, 1, 1, 1.0) if has_pizza else Color(1, 1, 1, 0.3)

		# INGREDIENTS ARE DISABLED/DIMMED UNTIL "ADD " IS TYPED!
		var ing_enabled = has_pizza and (max_add_comp >= 4)
		var ing_color = Color(1, 1, 1, 1.0) if ing_enabled else Color(1, 1, 1, 0.3)
		sauce_label.modulate = ing_color
		cheese_label.modulate = ing_color
		pepperoni_label.modulate = ing_color

		# Render TAKE OUT prefix label above ovens
		var any_baking = pizzeria.ovens.any(func(p): return p != null)
		var to_pref = "TAKE OUT "
		var typed_to = to_pref.substr(0, max_takeout_comp)
		var untyped_to = to_pref.substr(max_takeout_comp)
		take_out_label.text = "[color=green]" + typed_to + "[/color]" + untyped_to
		take_out_label.modulate = Color(1, 1, 1, 1.0) if any_baking else Color(1, 1, 1, 0.3)

		# OVEN NUMBERS ARE DISABLED/DIMMED UNTIL "TAKE OUT " IS TYPED!
		var ovens_active = any_baking and (max_takeout_comp >= 9)

		# Render individual labels
		for item in targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			var label: RichTextLabel = item.get("label")
			var prefix: String = item.get("prefix", "")

			if label == null:
				continue

			if prefix != "":
				var pref_len = prefix.length()
				var suffix = cmd.substr(pref_len)
				if comp > pref_len:
					var suf_comp = comp - pref_len
					var typed = suffix.substr(0, suf_comp)
					var untyped = suffix.substr(suf_comp)
					label.text = "[color=green]" + typed + "[/color]" + untyped
				else:
					label.text = suffix
			else:
				var typed = cmd.substr(0, comp)
				var untyped = cmd.substr(comp)
				label.text = "[color=green]" + typed + "[/color]" + untyped

		# Apply dimming to oven numbers based on prefix state
		for i in range(4):
			var has_oven_pizza = (pizzeria.ovens[i] != null)
			if has_oven_pizza and ovens_active:
				oven_slot_labels[i].modulate = Color(1, 1, 1, 1.0)
			else:
				oven_slot_labels[i].modulate = Color(1, 1, 1, 0.25)
	else:
		# Counter targets
		for item in targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			var label: RichTextLabel = item.get("label")

			if label != null:
				var typed = cmd.substr(0, comp)
				var untyped = cmd.substr(comp)
				label.text = "[color=green]" + typed + "[/color]" + untyped


# VISUAL SYNCHRONIZATION & PIZZA RENDERING
func update_pizza_display(base_rect: TextureRect, pizza: Pizza) -> void:
	if base_rect == null:
		return

	if pizza == null:
		base_rect.texture = null
		for child in base_rect.get_children():
			if child is TextureRect:
				child.hide()
		return

	base_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	base_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Choose dough base: cooked if baked/overcooked/burnt, uncooked otherwise
	var doneness = pizza.get_doneness()
	var is_cooked = (doneness != Pizza.Doneness.RAW and doneness != Pizza.Doneness.UNDERCOOKED)
	base_rect.texture = tex_cooked if is_cooked else tex_uncooked

	# Sauce layer
	var sauce_node = get_or_create_layer(base_rect, "SauceLayer", tex_sauce)
	sauce_node.visible = pizza.has_topping("SAUCE")

	# Cheese layer (unmelted or melted depending on bake stage)
	var cheese_tex = tex_cheese_melted if is_cooked else tex_cheese_unmelted
	var cheese_node = get_or_create_layer(base_rect, "CheeseLayer", cheese_tex)
	cheese_node.texture = cheese_tex
	cheese_node.visible = pizza.has_topping("CHEESE")

	# Pepperoni layer
	var pep_node = get_or_create_layer(base_rect, "PepLayer", tex_pepperoni)
	pep_node.visible = pizza.has_topping("PEPPERONI")

	# Slice cut layer (slice4.png or slice8.png)
	var slice_tex: Texture2D = null
	if pizza.is_sliced:
		slice_tex = tex_slice8 if pizza.slice_count == 8 else tex_slice4
	var slice_node = get_or_create_layer(base_rect, "SliceLayer", slice_tex)
	slice_node.texture = slice_tex
	slice_node.visible = pizza.is_sliced

	# If burnt, tint darker
	if doneness == Pizza.Doneness.BURNT:
		base_rect.self_modulate = Color(0.35, 0.25, 0.25)
	else:
		base_rect.self_modulate = Color(1, 1, 1)


func get_or_create_layer(parent: TextureRect, layer_name: String, tex: Texture2D) -> TextureRect:
	var layer = parent.get_node_or_null(layer_name) as TextureRect
	if layer == null:
		layer = TextureRect.new()
		layer.name = layer_name
		layer.set_anchors_preset(Control.PRESET_FULL_RECT)
		layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		layer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(layer)
	layer.texture = tex
	return layer


func update_order_cards() -> void:
	for i in range(4):
		var order = pizzeria.order_slots[i]
		var nodes = order_slot_nodes[i]

		# Update slice indicator TextureRects (Slice1, Slice4, Slice8)
		# All low alpha (0.2) until the order is taken; alpha 1.0 for requested slice once ACTIVE
		var req_slices: int = 0
		if order != null and order.status == Order.Status.ACTIVE:
			req_slices = order.requested_slices

		nodes["slice_1"].modulate.a = 1.0 if req_slices == 1 else 0.2
		nodes["slice_4"].modulate.a = 1.0 if req_slices == 4 else 0.2
		nodes["slice_8"].modulate.a = 1.0 if req_slices == 8 else 0.2

		# ToppingLbl is a plain Label, so NO BBCode tags are used here!
		if order == null or order.status == Order.Status.EMPTY:
			nodes["title"].text = "Slot %d" % (i + 1)
			nodes["toppings"].text = "(Empty Slot)"
			nodes["take_order"].hide()
			nodes["give_order"].hide()
		elif order.status == Order.Status.WAITING_TO_TAKE:
			nodes["title"].text = "Order #%d (%.0fs)" % [order.order_number, order.patience]
			nodes["toppings"].text = "Customer Waiting!\n%.0fs left to take order\n\n(Take order to view)" % order.patience
			nodes["take_order"].show()
			nodes["give_order"].hide()
		elif order.status == Order.Status.ACTIVE:
			nodes["title"].text = "Order #%d (%.0fs)" % [order.order_number, order.patience]
			var top_str = "Time Left: %.0fs\nToppings:" % order.patience
			for t in order.requested_toppings:
				top_str += "\n + " + t.capitalize()
			nodes["toppings"].text = top_str
			nodes["take_order"].hide()
			nodes["give_order"].visible = (pizzeria.packing_station_pizza != null)
		elif order.status == Order.Status.SERVED:
			nodes["title"].text = "Order #%d" % order.order_number
			nodes["toppings"].text = "Served!\nScore: %d%%\n%d Stars" % [order.last_review.get("score", 0), order.last_review.get("stars", 1)]
			nodes["take_order"].hide()
			nodes["give_order"].hide()
		elif order.status == Order.Status.EXPIRED:
			nodes["title"].text = "Order #%d" % order.order_number
			nodes["toppings"].text = "Customer Left!"
			nodes["take_order"].hide()
			nodes["give_order"].hide()


func update_counter_station_visuals() -> void:
	# Slice station
	if pizzeria.slice_queue.is_empty():
		slice_4_label.text = "slice 4"
		slice_8_label.text = "slice 8"
		slice_4_label.modulate = Color(1, 1, 1, 0.3)
		slice_8_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(slice_texture, null)
	elif not pizzeria.slice_queue[0].is_sliced:
		slice_4_label.modulate = Color(1, 1, 1, 1.0)
		slice_8_label.modulate = Color(1, 1, 1, 1.0)
		update_pizza_display(slice_texture, pizzeria.slice_queue[0])
	else:
		var count = pizzeria.slice_queue[0].slice_count
		if count == 4:
			slice_4_label.text = "sliced (4)"
			slice_8_label.text = "slice 8"
			slice_4_label.modulate = Color(0.4, 1.0, 0.4, 0.8)
			slice_8_label.modulate = Color(1, 1, 1, 0.2)
		elif count == 8:
			slice_4_label.text = "slice 4"
			slice_8_label.text = "sliced (8)"
			slice_4_label.modulate = Color(1, 1, 1, 0.2)
			slice_8_label.modulate = Color(0.4, 1.0, 0.4, 0.8)
		else:
			slice_4_label.text = "slice 4"
			slice_8_label.text = "slice 8"
			slice_4_label.modulate = Color(1, 1, 1, 0.3)
			slice_8_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(slice_texture, pizzeria.slice_queue[0])

	# Box station
	if pizzeria.packing_station_pizza != null:
		box_background.texture = tex_box_closed
		pack_up_label.text = "boxed"
		pack_up_label.modulate = Color(1.0, 0.85, 0.3, 1.0)
		counter_trash_label.modulate = Color(1, 1, 1, 1.0)
		update_pizza_display(box_pizza_texture, null)
	elif not pizzeria.slice_queue.is_empty():
		box_background.texture = tex_box_open
		pack_up_label.text = "pack up"
		pack_up_label.modulate = Color(1, 1, 1, 1.0)
		counter_trash_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(box_pizza_texture, null)
	else:
		box_background.texture = tex_box_open
		pack_up_label.text = "pack up"
		pack_up_label.modulate = Color(1, 1, 1, 0.3)
		counter_trash_label.modulate = Color(1, 1, 1, 0.3)
		update_pizza_display(box_pizza_texture, null)


func update_kitchen_station_visuals() -> void:
	var has_pizza = (pizzeria.kitchen_table_pizza != null)

	# Update prep table pizza image layers
	update_pizza_display(kitchen_pizza_texture, pizzeria.kitchen_table_pizza)

	# Make dough active only when table is empty
	make_dough_label.modulate = Color(1, 1, 1, 1.0) if not has_pizza else Color(1, 1, 1, 0.3)

	kitchen_trash_label.modulate = Color(1, 1, 1, 1.0) if has_pizza else Color(1, 1, 1, 0.3)

	var can_bake = has_pizza and pizzeria.ovens.has(null)
	into_oven_label.modulate = Color(1, 1, 1, 1.0) if can_bake else Color(1, 1, 1, 0.3)


## Updates oven sliders & visual styles (oven_on / oven_off)
func update_oven_progress() -> void:
	for i in range(4):
		var p = pizzeria.ovens[i]
		var panel = oven_panels[i]
		var slider = oven_sliders[i]

		if p != null:
			panel.add_theme_stylebox_override("panel", style_oven_on)
			slider.modulate = Color(1, 1, 1, 1.0)
			slider.value = clampf(p.cook_time, 0.0, Pizza.TIME_BURNT)
		else:
			panel.add_theme_stylebox_override("panel", style_oven_off)
			slider.value = 0.0
			slider.modulate = Color(1, 1, 1, 0.25)


## Spawns a random customer order in an available slot
func spawn_random_order() -> void:
	var slot_to_fill: int = -1
	for i in range(4):
		var ord = pizzeria.order_slots[i]
		if ord == null or ord.status == Order.Status.EMPTY or ord.status == Order.Status.SERVED or ord.status == Order.Status.EXPIRED:
			slot_to_fill = i + 1
			break

	if slot_to_fill == -1:
		return

	var possible = ["SAUCE", "CHEESE", "PEPPERONI"]
	possible.shuffle()
	var count = randi_range(1, 3)
	var chosen: Array[String] = []
	for i in range(count):
		chosen.append(possible[i])

	var slice_options = [1, 4, 8]
	var chosen_slices = slice_options.pick_random()
	pizzeria.spawn_order(slot_to_fill, chosen, randf_range(80.0, 110.0), randf_range(130.0, 170.0), chosen_slices)
	refresh_ui()


# Signal callbacks
func _on_state_updated(_arg = null) -> void:
	refresh_ui()


func _on_oven_updated(_slot: int, _p: Pizza) -> void:
	refresh_ui()


func _on_order_updated(_slot: int, _o: Order) -> void:
	refresh_ui()


func _on_order_reviewed(slot: int, review: Dictionary) -> void:
	var score = review.get("score", 0)
	money += score
	update_money_display()
	print("Order review on slot %d: %s | Money earned: %d" % [slot, review, score])
	refresh_ui()


func _on_order_expired(_slot: int, was_active: bool) -> void:
	if was_active:
		# Customer had given their order: -$50 penalty
		money -= 50
		update_money_display()
		print("Order expired (was active): -$50 penalty! Current money: %d" % money)
	else:
		# Customer was waiting to take order: -10s penalty
		game_time = maxf(0.0, game_time - 10.0)
		update_time_display()
		print("Order expired (waiting to take): -10s penalty! Remaining time: %.1fs" % game_time)
		if game_time <= 0.0:
			trigger_game_over()
	refresh_ui()
