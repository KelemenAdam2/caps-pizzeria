extends Control

enum GameScreen {
	MENU,
	LEVELS,
	GAMEPLAY,
	TIMES_UP,
	REVIEW,
	END_SCREEN
}

var current_screen: GameScreen = GameScreen.MENU

# SCREEN REFERENCES
@onready var menu_screen: Control = $Menu
@onready var levels_screen: Control = $Levels
@onready var counter: Control = $Counter
@onready var kitchen: Control = $Kitchen
@onready var time_up_panel: Panel = $TimeUpPanel
@onready var review_panel: Panel = $ReviewPanel
@onready var end_screen: Control = $EndScreen
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

# MENU NODES
@onready var menu_logo_texture: TextureRect = $Menu/MenuVBox/LogoTexture
@onready var menu_start_label: RichTextLabel = $Menu/MenuVBox/Start
@onready var menu_quit_label: RichTextLabel = $Menu/MenuVBox/Quit

# LEVELS NODES
@onready var levels_header_label: RichTextLabel = $Levels/Level
@onready var level_cards: Array[Dictionary] = [
	{
		"panel": $Levels/GridContainer/Level1,
		"label": $Levels/GridContainer/Level1/LevelMargin/LevelVBox.get_node("1") as RichTextLabel,
		"stars": [
			$Levels/GridContainer/Level1/LevelMargin/LevelVBox/StarHBox/StarTexture,
			$Levels/GridContainer/Level1/LevelMargin/LevelVBox/StarHBox/StarTexture1,
			$Levels/GridContainer/Level1/LevelMargin/LevelVBox/StarHBox/StarTexture2,
		]
	},
	{
		"panel": $Levels/GridContainer/Level2,
		"label": $Levels/GridContainer/Level2/LevelMargin/LevelVBox.get_node("2") as RichTextLabel,
		"stars": [
			$Levels/GridContainer/Level2/LevelMargin/LevelVBox/StarHBox/StarTexture,
			$Levels/GridContainer/Level2/LevelMargin/LevelVBox/StarHBox/StarTexture1,
			$Levels/GridContainer/Level2/LevelMargin/LevelVBox/StarHBox/StarTexture2,
		]
	},
	{
		"panel": $Levels/GridContainer/Level3,
		"label": $Levels/GridContainer/Level3/LevelMargin/LevelVBox.get_node("3") as RichTextLabel,
		"stars": [
			$Levels/GridContainer/Level3/LevelMargin/LevelVBox/StarHBox/StarTexture,
			$Levels/GridContainer/Level3/LevelMargin/LevelVBox/StarHBox/StarTexture1,
			$Levels/GridContainer/Level3/LevelMargin/LevelVBox/StarHBox/StarTexture2,
		]
	},
	{
		"panel": $Levels/GridContainer/Level4,
		"label": $Levels/GridContainer/Level4/LevelMargin/LevelVBox.get_node("4") as RichTextLabel,
		"stars": [
			$Levels/GridContainer/Level4/LevelMargin/LevelVBox/StarHBox/StarTexture,
			$Levels/GridContainer/Level4/LevelMargin/LevelVBox/StarHBox/StarTexture1,
			$Levels/GridContainer/Level4/LevelMargin/LevelVBox/StarHBox/StarTexture2,
		]
	},
	{
		"panel": $Levels/GridContainer/Level5,
		"label": $Levels/GridContainer/Level5/LevelMargin/LevelVBox.get_node("5") as RichTextLabel,
		"stars": [
			$Levels/GridContainer/Level5/LevelMargin/LevelVBox/StarHBox/StarTexture,
			$Levels/GridContainer/Level5/LevelMargin/LevelVBox/StarHBox/StarTexture1,
			$Levels/GridContainer/Level5/LevelMargin/LevelVBox/StarHBox/StarTexture2,
		]
	},
	{
		"panel": $Levels/GridContainer/Level6,
		"label": $Levels/GridContainer/Level6/LevelMargin/LevelVBox.get_node("6") as RichTextLabel,
		"stars": [
			$Levels/GridContainer/Level6/LevelMargin/LevelVBox/StarHBox/StarTexture,
			$Levels/GridContainer/Level6/LevelMargin/LevelVBox/StarHBox/StarTexture1,
			$Levels/GridContainer/Level6/LevelMargin/LevelVBox/StarHBox/StarTexture2,
		]
	}
]

# REVIEW PANEL NODES
@onready var review_star1_tex: TextureRect = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/StarsHBox/Star1/StarTexture
@onready var review_star1_lbl: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/StarsHBox/Star1/Label
@onready var review_star2_tex: TextureRect = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/StarsHBox/Star2/StarTexture
@onready var review_star2_lbl: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/StarsHBox/Star2/Label
@onready var review_star3_tex: TextureRect = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/StarsHBox/Star3/StarTexture
@onready var review_star3_lbl: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/StarsHBox/Star3/Label

@onready var review_ord_comp_left: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/OrdCompHBox/LeftLabel
@onready var review_ord_comp_right: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/OrdCompHBox/RightLabel
@onready var review_tips_left: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/TipsHBox/LeftLabel
@onready var review_tips_right: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/TipsHBox/RightLabel
@onready var review_ord_fail_left: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/OrdFailHBox/LeftLabel
@onready var review_ord_fail_right: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/OrdFailHBox/RightLabel
@onready var review_total_right: Label = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/TotalHBox/RightLabel

@onready var review_menu_label: RichTextLabel = ($ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/CommandsHBox.get_node_or_null("Menu") if $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/CommandsHBox.get_node_or_null("Menu") != null else $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/CommandsHBox.get_node_or_null("Exit"))
@onready var review_levels_label: RichTextLabel = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/CommandsHBox/Levels
@onready var review_next_label: RichTextLabel = $ReviewPanel/ReviewScreen/ReviewMargin/ReviewVBox/CommandsHBox/Next

# END SCREEN NODES
@onready var end_return_label: RichTextLabel = $EndScreen/ReturnToMenu

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

@onready var global_background: TextureRect = $Background
@onready var money_coin_texture: TextureRect = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/MoneyPanel/TextureRect

@onready var money_label: Label = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/MoneyPanel/Money
@onready var time_label: Label = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/TimePanel/Time
@onready var counter_trash_label: RichTextLabel = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/HBoxContainer/Trash
@onready var counter_exit_label: RichTextLabel = $Counter/MainMargin/MainVBox/CounterContainer/VBoxContainer/HBoxContainer/Exit

@onready var locked_order_panels: Array[Panel] = [
	$Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/LockedOrder1,
	$Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/LockedOrder2,
	$Counter/MainMargin/MainVBox/OrderPanel/OrderMargin/OrderHbox/LockedOrder3
]

# KITCHEN NODE REFERENCES
@onready var sauce_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Sauce
@onready var cheese_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Cheese
@onready var ham_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Ham
@onready var olive_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Olive
@onready var pepperoni_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Pepperoni
@onready var tomato_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Tomato
@onready var mushroom_label: RichTextLabel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Mushroom
@onready var locked_ing_panel: Panel = $Kitchen/MainContainer/MainHBox/StationPanel/StationMargin/StationHBox/IngPanel/IngMargin/IngVBox/Panel
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

# STATE & ASSETS
var pizzeria: PizzeriaState = PizzeriaState.new()

var tex_uncooked: Texture2D = null
var tex_cooked: Texture2D = null
var tex_sauce: Texture2D = null
var tex_cheese_unmelted: Texture2D = null
var tex_cheese_melted: Texture2D = null
var tex_ham: Texture2D = null
var tex_olives: Texture2D = null
var tex_pepperoni: Texture2D = null
var tex_tomato: Texture2D = null
var tex_mushroom: Texture2D = null
var tex_slice4: Texture2D = null
var tex_slice8: Texture2D = null
var tex_slice1_order: Texture2D = null
var tex_slice4_order: Texture2D = null
var tex_slice8_order: Texture2D = null
var tex_box_open: Texture2D = null
var tex_box_closed: Texture2D = null
var tex_timesup: Texture2D = null
var tex_star: Texture2D = null

var tex_coin_empty: Texture2D = null
var tex_coin_bronze: Texture2D = null
var tex_coin_silver: Texture2D = null
var tex_coin_gold: Texture2D = null

var tex_red_bg: Texture2D = null
var tex_blue_bg: Texture2D = null

var style_oven_on: StyleBoxTexture = null
var style_oven_off: StyleBoxTexture = null

const RICH_TEXT_BG_NORMAL := Color("#b1000081")
const RICH_TEXT_BORDER_NORMAL := Color("#b10000")
const RICH_TEXT_BG_SHIFT := Color("#007ed5a2")
const RICH_TEXT_BORDER_SHIFT := Color("#006aa2")
var _last_shift_theme_state: int = -1

# AUDIO ASSETS & PLAYERS
var sfx_box: AudioStream = null
var sfx_cash_up: AudioStream = null
var sfx_clock15: AudioStream = null
var sfx_fail: AudioStream = null
var sfx_new_order: AudioStream = null
var sfx_order_completed: AudioStream = null
var sfx_oven_in: AudioStream = null
var sfx_review: AudioStream = null
var sfx_review2: AudioStream = null
var sfx_slicing: AudioStream = null
var sfx_success: AudioStream = null
var sfx_times_up: AudioStream = null
var sfx_trash: AudioStream = null
var sfx_keyboard: Array[AudioStream] = []

var sfx_pool: Array[AudioStreamPlayer] = []
var clock_player: AudioStreamPlayer = null
var clock15_started: bool = false

# LEVEL DATA DEFINITIONS
var levels_config: Array[Dictionary] = [
	{
		"level": 1,
		"time_limit": 90.0,
		"stars": [100, 200, 300],
		"active_orders": 1,
		"unlocked_ingredients": ["SAUCE", "CHEESE"],
		"orders": [
			{"take_time": 60.0, "give_time": 90.0, "toppings": ["CHEESE"], "slice": 4, "price": 100},
			{"take_time": 55.0, "give_time": 85.0, "toppings": ["SAUCE", "CHEESE"], "slice": 4, "price": 120},
			{"take_time": 50.0, "give_time": 80.0, "toppings": ["CHEESE"], "slice": 4, "price": 100},
			{"take_time": 45.0, "give_time": 80.0, "toppings": ["SAUCE", "CHEESE"], "slice": 4, "price": 120},
		]
	},
	{
		"level": 2,
		"time_limit": 100.0,
		"stars": [150, 300, 450],
		"active_orders": 2,
		"unlocked_ingredients": ["SAUCE", "CHEESE", "HAM"],
		"orders": [
			{"take_time": 50.0, "give_time": 85.0, "toppings": ["SAUCE", "CHEESE"], "slice": 4, "price": 120},
			{"take_time": 50.0, "give_time": 85.0, "toppings": ["CHEESE", "HAM"], "slice": 8, "price": 130},
			{"take_time": 45.0, "give_time": 80.0, "toppings": ["SAUCE", "HAM"], "slice": 8, "price": 130},
			{"take_time": 45.0, "give_time": 80.0, "toppings": ["SAUCE", "CHEESE", "HAM"], "slice": 4, "price": 150},
			{"take_time": 40.0, "give_time": 75.0, "toppings": ["CHEESE"], "slice": 8, "price": 110},
		]
	},
	{
		"level": 3,
		"time_limit": 110.0,
		"stars": [200, 400, 600],
		"active_orders": 2,
		"unlocked_ingredients": ["SAUCE", "CHEESE", "HAM", "OLIVE"],
		"orders": [
			{"take_time": 45.0, "give_time": 80.0, "toppings": ["CHEESE"], "slice": 1, "price": 110},
			{"take_time": 45.0, "give_time": 80.0, "toppings": ["SAUCE", "CHEESE", "HAM"], "slice": 8, "price": 150},
			{"take_time": 40.0, "give_time": 75.0, "toppings": ["SAUCE", "CHEESE", "OLIVE"], "slice": 1, "price": 140},
			{"take_time": 40.0, "give_time": 75.0, "toppings": ["HAM", "OLIVE"], "slice": 4, "price": 130},
			{"take_time": 35.0, "give_time": 70.0, "toppings": ["SAUCE", "CHEESE", "HAM", "OLIVE"], "slice": 8, "price": 180},
			{"take_time": 35.0, "give_time": 70.0, "toppings": ["CHEESE", "OLIVE"], "slice": 1, "price": 130},
		]
	},
	{
		"level": 4,
		"time_limit": 120.0,
		"stars": [250, 500, 750],
		"active_orders": 3,
		"unlocked_ingredients": ["SAUCE", "CHEESE", "HAM", "OLIVE", "PEPPERONI"],
		"orders": [
			{"take_time": 40.0, "give_time": 75.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI"], "slice": 8, "price": 150},
			{"take_time": 40.0, "give_time": 75.0, "toppings": ["CHEESE", "HAM"], "slice": 4, "price": 130},
			{"take_time": 35.0, "give_time": 70.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI", "OLIVE"], "slice": 1, "price": 170},
			{"take_time": 35.0, "give_time": 70.0, "toppings": ["SAUCE", "HAM", "OLIVE"], "slice": 8, "price": 150},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["CHEESE", "PEPPERONI"], "slice": 4, "price": 130},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["SAUCE", "CHEESE", "HAM", "PEPPERONI"], "slice": 8, "price": 180},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["CHEESE", "OLIVE", "PEPPERONI"], "slice": 1, "price": 160},
		]
	},
	{
		"level": 5,
		"time_limit": 130.0,
		"stars": [300, 600, 900],
		"active_orders": 3,
		"unlocked_ingredients": ["SAUCE", "CHEESE", "HAM", "OLIVE", "PEPPERONI", "TOMATO"],
		"orders": [
			{"take_time": 35.0, "give_time": 70.0, "toppings": ["SAUCE", "CHEESE", "TOMATO"], "slice": 8, "price": 150},
			{"take_time": 35.0, "give_time": 70.0, "toppings": ["CHEESE", "HAM", "TOMATO"], "slice": 1, "price": 150},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI"], "slice": 4, "price": 150},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["CHEESE", "PEPPERONI", "OLIVE"], "slice": 8, "price": 160},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["SAUCE", "HAM", "TOMATO"], "slice": 1, "price": 150},
			{"take_time": 25.0, "give_time": 60.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI", "TOMATO"], "slice": 4, "price": 180},
			{"take_time": 25.0, "give_time": 60.0, "toppings": ["CHEESE", "OLIVE"], "slice": 8, "price": 130},
			{"take_time": 25.0, "give_time": 60.0, "toppings": ["SAUCE", "CHEESE", "HAM", "OLIVE", "TOMATO"], "slice": 1, "price": 200},
		]
	},
	{
		"level": 6,
		"time_limit": 140.0,
		"stars": [350, 750, 1100],
		"active_orders": 4,
		"unlocked_ingredients": ["SAUCE", "CHEESE", "HAM", "OLIVE", "PEPPERONI", "TOMATO", "MUSHROOM"],
		"orders": [
			{"take_time": 35.0, "give_time": 65.0, "toppings": ["SAUCE", "CHEESE", "MUSHROOM"], "slice": 4, "price": 150},
			{"take_time": 30.0, "give_time": 65.0, "toppings": ["CHEESE", "HAM", "MUSHROOM"], "slice": 8, "price": 160},
			{"take_time": 30.0, "give_time": 60.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI", "OLIVE"], "slice": 1, "price": 180},
			{"take_time": 25.0, "give_time": 60.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI", "MUSHROOM"], "slice": 8, "price": 190},
			{"take_time": 25.0, "give_time": 55.0, "toppings": ["CHEESE", "TOMATO", "MUSHROOM"], "slice": 4, "price": 160},
			{"take_time": 25.0, "give_time": 55.0, "toppings": ["SAUCE", "HAM", "OLIVE", "TOMATO"], "slice": 1, "price": 180},
			{"take_time": 20.0, "give_time": 50.0, "toppings": ["SAUCE", "CHEESE", "PEPPERONI", "TOMATO", "MUSHROOM"], "slice": 8, "price": 210},
			{"take_time": 20.0, "give_time": 50.0, "toppings": ["CHEESE", "HAM", "PEPPERONI"], "slice": 4, "price": 160},
			{"take_time": 20.0, "give_time": 50.0, "toppings": ["SAUCE", "CHEESE", "HAM", "OLIVE", "PEPPERONI", "TOMATO", "MUSHROOM"], "slice": 1, "price": 250},
		]
	}
]

# PROGRESSION & LEVEL RUNTIME
var current_level_idx: int = 1
var level_orders_remaining: Array = []
var level_best_stars: Array[int] = [0, 0, 0, 0, 0, 0, 0] # indices 1..6

# RUNTIME STATS
var game_time: float = 120.0
var money: int = 0
var orders_completed_count: int = 0
var orders_completed_money: int = 0
var total_tips_earned: int = 0
var orders_failed_count: int = 0
var orders_failed_penalty: int = 0
var current_streak: int = 0
var is_game_over: bool = false
var times_up_timer: float = 0.0

# COMMAND STRUCTURES
var active_kitchen_targets: Array[Dictionary] = []
var active_counter_targets: Array[Dictionary] = []
var active_screen_targets: Array[Dictionary] = []


func _ready() -> void:
	# Load image textures
	tex_uncooked = load("res://textures/pizza_uncooked.png")
	tex_cooked = load("res://textures/pizza_cooked.png")
	tex_sauce = load("res://textures/sauce.png")
	tex_cheese_unmelted = load("res://textures/cheese_unmelted.png")
	tex_cheese_melted = load("res://textures/cheese_melted.png")
	tex_ham = load("res://textures/ham.png")
	tex_olives = load("res://textures/olives.png")
	tex_pepperoni = load("res://textures/pepperoni.png")
	tex_tomato = load("res://textures/tomato.png")
	tex_mushroom = load("res://textures/mushroom.png")
	tex_slice4 = load("res://textures/slice4.png")
	tex_slice8 = load("res://textures/slice8.png")
	tex_slice1_order = load("res://textures/slice1_order.png")
	tex_slice4_order = load("res://textures/slice4_order.png")
	tex_slice8_order = load("res://textures/slice8_order.png")
	tex_box_open = load("res://textures/box_open.png")
	tex_box_closed = load("res://textures/box_closed.png")
	tex_timesup = load("res://textures/timesup.png")
	tex_star = load("res://textures/star.png")

	tex_coin_empty = load("res://textures/coin_empty.png")
	tex_coin_bronze = load("res://textures/coin_bronze.png")
	tex_coin_silver = load("res://textures/coin_silver.png")
	tex_coin_gold = load("res://textures/coin_gold.png")

	tex_red_bg = load("res://textures/red_bg.png")
	tex_blue_bg = load("res://textures/blue_bg.png")

	# Load audio assets
	sfx_box = load("res://audio/Box.wav")
	sfx_cash_up = load("res://audio/CashUp.wav")
	sfx_clock15 = load("res://audio/Clock15.wav")
	sfx_fail = load("res://audio/Fail.wav")
	sfx_new_order = load("res://audio/NewOrder.wav")
	sfx_order_completed = load("res://audio/OrderCompleted.wav")
	sfx_oven_in = load("res://audio/OvenIn.wav")
	sfx_review = load("res://audio/Review.wav")
	sfx_review2 = load("res://audio/Review2.wav")
	sfx_slicing = load("res://audio/Slicing.wav")
	sfx_success = load("res://audio/Succes.wav")
	sfx_times_up = load("res://audio/TimesOut.wav")
	sfx_trash = load("res://audio/Trash.wav")
	for i in range(1, 6):
		var kb_stream: AudioStream = load("res://audio/keyboard/keyboard%d.wav" % i)
		if kb_stream != null:
			sfx_keyboard.append(kb_stream)

	# Setup SFX player pool (starting with the scene's AudioStreamPlayer) and dedicated clock player
	sfx_pool.append(audio_player)
	for i in range(7):
		var p = AudioStreamPlayer.new()
		add_child(p)
		sfx_pool.append(p)

	clock_player = AudioStreamPlayer.new()
	clock_player.stream = sfx_clock15
	add_child(clock_player)

	# Setup oven StyleBoxTextures for empty/off and baking/on
	style_oven_off = StyleBoxTexture.new()
	style_oven_off.texture = load("res://textures/oven_off.png")
	style_oven_off.expand_margin_top = 80.0
	style_oven_off.expand_margin_bottom = 80.0

	style_oven_on = StyleBoxTexture.new()
	style_oven_on.texture = load("res://textures/oven_on.png")
	style_oven_on.expand_margin_top = 80.0
	style_oven_on.expand_margin_bottom = 80.0

	# Ensure order slice textures fallback if not assigned
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
	var timesup_rect = time_up_panel.get_node_or_null("TextureRect") as TextureRect
	if timesup_rect == null:
		timesup_rect = time_up_panel.get_node_or_null("TimesUpTexture") as TextureRect
	if timesup_rect == null:
		timesup_rect = TextureRect.new()
		timesup_rect.name = "TextureRect"
		timesup_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		timesup_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		timesup_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		time_up_panel.add_child(timesup_rect)
	timesup_rect.texture = tex_timesup
	timesup_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var timesup_lbl = time_up_panel.get_node_or_null("TimesUp") as Label
	if timesup_lbl != null:
		timesup_lbl.hide()

	# Menu Logo
	if menu_logo_texture != null and menu_logo_texture.texture == null:
		menu_logo_texture.texture = tex_cooked
		menu_logo_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		menu_logo_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Setup star textures on Review screen
	review_star1_tex.texture = tex_star
	review_star2_tex.texture = tex_star
	review_star3_tex.texture = tex_star

	# Setup star textures on Level cards
	for card in level_cards:
		for s in card["stars"]:
			s.texture = tex_star
			s.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			s.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Configure oven sliders
	for slider in oven_sliders:
		slider.min_value = 0.0
		slider.max_value = Pizza.TIME_BURNT
		slider.value = 0.0

	# Connect pizzeria signals
	pizzeria.kitchen_table_changed.connect(_on_state_updated)
	pizzeria.oven_changed.connect(_on_oven_updated)
	pizzeria.slice_queue_changed.connect(_on_state_updated)
	pizzeria.packing_station_changed.connect(_on_state_updated)
	pizzeria.order_slot_changed.connect(_on_order_updated)
	pizzeria.order_reviewed.connect(_on_order_reviewed)
	pizzeria.order_expired.connect(_on_order_expired)

	# Start on Main Menu
	go_to_menu()


func _process(delta: float) -> void:
	# Update background texture and RichTextLabel theme based on shift across all screens
	var is_shift = Input.is_action_pressed("hold_shift")
	update_shift_visuals(is_shift)

	if current_screen == GameScreen.TIMES_UP:
		times_up_timer -= delta
		if times_up_timer <= 0.0:
			time_up_panel.hide()
			show_review_screen()
		return

	if current_screen != GameScreen.GAMEPLAY or is_game_over:
		# For non-gameplay screens, re-render screen targets so text case matches shift state
		render_screen_targets()
		return

	# Countdown level game timer
	game_time = maxf(0.0, game_time - delta)
	update_time_display()
	if game_time <= 15.0 and game_time > 0.0 and not clock15_started:
		clock15_started = true
		if clock_player != null and sfx_clock15 != null:
			clock_player.play(clampf(15.0 - game_time, 0.0, 14.9))
	if game_time <= 0.0:
		trigger_times_up()
		return

	# Update simulation (baking timers, customer patience)
	pizzeria.update(delta)

	# Dimension switch: Hold Shift for Kitchen, release for Counter
	if is_shift:
		counter.hide()
		kitchen.show()
	else:
		kitchen.hide()
		counter.show()

	# Continuously update dynamic displays
	update_order_cards()
	update_oven_progress()


# SCREEN MANAGEMENT
func show_screen(screen: GameScreen) -> void:
	current_screen = screen
	menu_screen.visible = (screen == GameScreen.MENU)
	levels_screen.visible = (screen == GameScreen.LEVELS)
	var is_shift = Input.is_action_pressed("hold_shift")
	counter.visible = (screen == GameScreen.GAMEPLAY and not is_shift)
	kitchen.visible = (screen == GameScreen.GAMEPLAY and is_shift)
	time_up_panel.visible = (screen == GameScreen.TIMES_UP)
	review_panel.visible = (screen == GameScreen.REVIEW)
	end_screen.visible = (screen == GameScreen.END_SCREEN)

	update_shift_visuals(is_shift)


func update_shift_visuals(is_shift: bool) -> void:
	if global_background != null:
		global_background.texture = tex_blue_bg if is_shift else tex_red_bg

	var shift_int := 1 if is_shift else 0
	if shift_int == _last_shift_theme_state:
		return
	_last_shift_theme_state = shift_int

	if theme != null:
		var style := theme.get_stylebox("normal", "RichTextLabel") as StyleBoxFlat
		if style != null:
			style.bg_color = RICH_TEXT_BG_SHIFT if is_shift else RICH_TEXT_BG_NORMAL
			style.border_color = RICH_TEXT_BORDER_SHIFT if is_shift else RICH_TEXT_BORDER_NORMAL


func go_to_menu() -> void:
	clock15_started = false
	stop_clock_sfx()
	show_screen(GameScreen.MENU)
	build_menu_targets()


func go_to_levels() -> void:
	show_screen(GameScreen.LEVELS)
	update_levels_stars_display()
	build_levels_targets()


func go_to_end_screen() -> void:
	show_screen(GameScreen.END_SCREEN)
	build_end_targets()
	play_sfx(sfx_review2)


func is_level_unlocked(level_num: int) -> bool:
	if level_num == 1:
		return true
	if level_num < 1 or level_num > 6:
		return false
	return level_best_stars[level_num - 1] >= 1


func start_level(level_num: int) -> void:
	if not is_level_unlocked(level_num):
		return
	current_level_idx = clampi(level_num, 1, 6)
	var cfg = levels_config[current_level_idx - 1]

	pizzeria.reset()

	# Reset runtime stats
	money = 0
	orders_completed_count = 0
	orders_completed_money = 0
	total_tips_earned = 0
	orders_failed_count = 0
	orders_failed_penalty = 0
	current_streak = 0
	is_game_over = false
	clock15_started = false
	stop_clock_sfx()
	game_time = cfg["time_limit"]

	level_orders_remaining = cfg["orders"].duplicate(true)
	var unl_tops: Array[String] = []
	for item in cfg.get("unlocked_ingredients", ["SAUCE", "CHEESE"]):
		unl_tops.append(str(item))
	pizzeria.available_toppings = unl_tops

	show_screen(GameScreen.GAMEPLAY)

	refill_level_orders()
	update_time_display()
	update_money_display()
	refresh_ui()


func refill_level_orders() -> void:
	if current_screen != GameScreen.GAMEPLAY:
		return

	var active_limit: int = 4
	if current_level_idx >= 1 and current_level_idx <= levels_config.size():
		active_limit = levels_config[current_level_idx - 1].get("active_orders", 4)

	var spawned_any: bool = false
	for i in range(active_limit):
		var ord = pizzeria.order_slots[i]
		if ord == null or ord.status == Order.Status.EMPTY or ord.status == Order.Status.SERVED or ord.status == Order.Status.EXPIRED:
			if level_orders_remaining.size() > 0:
				var data = level_orders_remaining.pop_front()
				pizzeria.spawn_order(
					i + 1,
					data["toppings"],
					data.get("take_time", 60.0),
					data.get("give_time", 90.0),
					data.get("slice", 4),
					data.get("price", 100)
				)
				spawned_any = true

	if spawned_any:
		play_sfx(sfx_new_order)


func trigger_times_up() -> void:
	if is_game_over:
		return
	is_game_over = true
	stop_clock_sfx()
	play_sfx(sfx_times_up)
	current_screen = GameScreen.TIMES_UP
	times_up_timer = 2.5
	time_up_panel.show()


func show_review_screen() -> void:
	show_screen(GameScreen.REVIEW)

	var cfg = levels_config[current_level_idx - 1]
	var star_goals = cfg["stars"]

	# Set star goals
	review_star1_lbl.text = str(star_goals[0])
	review_star2_lbl.text = str(star_goals[1])
	review_star3_lbl.text = str(star_goals[2])

	# Evaluate stars earned
	var stars = 0
	if money >= star_goals[0]:
		stars = 1
	if money >= star_goals[1]:
		stars = 2
	if money >= star_goals[2]:
		stars = 3

	level_best_stars[current_level_idx] = maxi(level_best_stars[current_level_idx], stars)

	# Modulate stars
	review_star1_tex.modulate = Color(1, 1, 1, 1.0) if stars >= 1 else Color(0.25, 0.25, 0.25, 0.35)
	review_star2_tex.modulate = Color(1, 1, 1, 1.0) if stars >= 2 else Color(0.25, 0.25, 0.25, 0.35)
	review_star3_tex.modulate = Color(1, 1, 1, 1.0) if stars >= 3 else Color(0.25, 0.25, 0.25, 0.35)

	# Breakdown values
	review_ord_comp_left.text = "Orders Completed x%d" % orders_completed_count
	review_ord_comp_right.text = "%d" % orders_completed_money
	review_tips_left.text = "Tips"
	review_tips_right.text = "+%d" % total_tips_earned
	review_ord_fail_left.text = "Orders Failed x%d" % orders_failed_count
	review_ord_fail_right.text = "-%d" % orders_failed_penalty
	review_total_right.text = "%d" % money

	build_review_targets()
	play_sfx(sfx_review2 if stars >= 1 else sfx_review)


func update_levels_stars_display() -> void:
	for i in range(6):
		var level_num = i + 1
		var unlocked = is_level_unlocked(level_num)
		var stars = level_best_stars[level_num]
		var card = level_cards[i]

		if unlocked:
			card["panel"].modulate = Color(1.0, 1.0, 1.0, 1.0)
			card["label"].text = str(level_num)
			card["stars"][0].modulate = Color(1, 1, 1, 1.0) if stars >= 1 else Color(0.25, 0.25, 0.25, 0.3)
			card["stars"][1].modulate = Color(1, 1, 1, 1.0) if stars >= 2 else Color(0.25, 0.25, 0.25, 0.3)
			card["stars"][2].modulate = Color(1, 1, 1, 1.0) if stars >= 3 else Color(0.25, 0.25, 0.25, 0.3)
		else:
			card["panel"].modulate = Color(0.35, 0.35, 0.35, 0.45)
			card["label"].text = str(level_num)
			card["stars"][0].modulate = Color(0.15, 0.15, 0.15, 0.15)
			card["stars"][1].modulate = Color(0.15, 0.15, 0.15, 0.15)
			card["stars"][2].modulate = Color(0.15, 0.15, 0.15, 0.15)


# INPUT HANDLING
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SHIFT or event.keycode == KEY_CAPSLOCK:
			return

		var typed_char = char(event.unicode)

		if current_screen == GameScreen.GAMEPLAY:
			if is_game_over:
				return

			var is_kitchen = Input.is_action_pressed("hold_shift")

			# Normalize casing by dimension
			if is_kitchen:
				if typed_char == "!" or event.physical_keycode == KEY_1 or event.keycode == KEY_1 or event.keycode == KEY_KP_1:
					typed_char = "1"
				elif typed_char == "@" or typed_char == "\"" or event.physical_keycode == KEY_2 or event.keycode == KEY_2 or event.keycode == KEY_KP_2:
					typed_char = "2"
				elif typed_char == "#" or typed_char == "+" or event.physical_keycode == KEY_3 or event.keycode == KEY_3 or event.keycode == KEY_KP_3:
					typed_char = "3"
				elif typed_char == "$" or typed_char == "%" or event.physical_keycode == KEY_4 or event.keycode == KEY_4 or event.keycode == KEY_KP_4:
					typed_char = "4"
				else:
					typed_char = typed_char.to_upper()
			else:
				typed_char = typed_char.to_lower()

			if typed_char.length() == 0:
				return

			play_keyboard_sfx()

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
				if completed_action == "exit":
					play_sfx(sfx_success)
					go_to_menu()
				else:
					if pizzeria.execute_command(completed_action):
						play_command_sfx(completed_action)
					refresh_ui()

		elif current_screen == GameScreen.TIMES_UP:
			return
		else:
			# Non-gameplay screen typing: case-insensitive (matches command)
			typed_char = typed_char.to_lower()
			if typed_char.length() == 0:
				return

			play_keyboard_sfx()

			var completed_action: String = ""
			for item in active_screen_targets:
				var command: String = item["command"].to_lower()
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

			render_screen_targets()

			if completed_action != "":
				play_sfx(sfx_success)
				handle_screen_action(completed_action)


func handle_screen_action(action: String) -> void:
	match current_screen:
		GameScreen.MENU:
			if action == "start":
				go_to_levels()
			elif action == "quit":
				get_tree().quit()

		GameScreen.LEVELS:
			if action.begins_with("level "):
				var num = action.substr(6).strip_edges().to_int()
				if is_level_unlocked(num):
					start_level(num)
			elif action == "menu" or action == "back":
				go_to_menu()

		GameScreen.REVIEW:
			if action == "menu" or action == "exit":
				go_to_menu()
			elif action == "levels":
				go_to_levels()
			elif action == "next":
				if current_level_idx < 6:
					var next_lvl = current_level_idx + 1
					if is_level_unlocked(next_lvl):
						start_level(next_lvl)
				else:
					if level_best_stars[6] >= 1:
						go_to_end_screen()

		GameScreen.END_SCREEN:
			if action == "return to menu" or action == "menu":
				go_to_menu()


# SCREEN TARGET BUILDERS
func build_menu_targets() -> void:
	active_screen_targets = [
		{"command": "start", "completion": 0, "label": menu_start_label, "action": "start"},
		{"command": "quit", "completion": 0, "label": menu_quit_label, "action": "quit"}
	]
	render_screen_targets()


func build_levels_targets() -> void:
	active_screen_targets.clear()
	for i in range(6):
		var num = i + 1
		level_cards[i]["label"].text = str(num)
		if not is_level_unlocked(num):
			continue

		# Match "level {num}" or direct number "{num}"
		active_screen_targets.append({
			"command": "level %d" % num,
			"completion": 0,
			"label": level_cards[i]["label"],
			"prefix": "level ",
			"action": "level %d" % num
		})
		active_screen_targets.append({
			"command": "%d" % num,
			"completion": 0,
			"label": level_cards[i]["label"],
			"prefix": "",
			"action": "level %d" % num
		})
	active_screen_targets.append({
		"command": "menu",
		"completion": 0,
		"label": null,
		"action": "menu"
	})
	render_screen_targets()


func build_review_targets() -> void:
	var can_next: bool = false
	if current_level_idx < 6:
		can_next = is_level_unlocked(current_level_idx + 1)
	else:
		can_next = (level_best_stars[6] >= 1)

	if review_next_label != null:
		review_next_label.modulate = Color(1, 1, 1, 1.0) if can_next else Color(0.35, 0.35, 0.35, 0.35)

	active_screen_targets = [
		{"command": "menu", "completion": 0, "label": review_menu_label, "action": "menu"},
		{"command": "levels", "completion": 0, "label": review_levels_label, "action": "levels"},
	]
	if can_next:
		active_screen_targets.append({
			"command": "next",
			"completion": 0,
			"label": review_next_label,
			"action": "next"
		})
	render_screen_targets()


func build_end_targets() -> void:
	active_screen_targets = [
		{"command": "return to menu", "completion": 0, "label": end_return_label, "action": "return to menu"}
	]
	render_screen_targets()


func render_screen_targets() -> void:
	var is_shift = Input.is_action_pressed("hold_shift")
	if current_screen == GameScreen.LEVELS:
		# Highlight "level" header if "level " prefix is partially/fully typed
		var max_lvl_comp: int = 0
		for item in active_screen_targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			if cmd.begins_with("level "):
				max_lvl_comp = maxi(max_lvl_comp, mini(comp, 6))

		var pref = "LEVEL" if is_shift else "level"
		var typed_p = pref.substr(0, mini(max_lvl_comp, 5))
		var untyped_p = pref.substr(typed_p.length())
		levels_header_label.text = "[color=green]" + typed_p + "[/color]" + untyped_p

		for item in active_screen_targets:
			var cmd: String = item["command"]
			var comp: int = item["completion"]
			var label: RichTextLabel = item.get("label")
			if label == null or not cmd.begins_with("level "):
				continue

			var num_str = cmd.substr(6)
			if comp > 6:
				label.text = "[color=green]" + num_str + "[/color]"
			else:
				label.text = num_str
	else:
		for item in active_screen_targets:
			var label: RichTextLabel = item.get("label")
			if label != null:
				var cmd: String = item["command"]
				if is_shift:
					cmd = cmd.to_upper()
				var comp: int = item["completion"]
				var typed = cmd.substr(0, comp)
				var untyped = cmd.substr(comp)
				label.text = "[color=green]" + typed + "[/color]" + untyped


func update_time_display() -> void:
	var total_sec = int(ceil(game_time))
	var minutes = total_sec / 60
	var seconds = total_sec % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]


func update_money_display() -> void:
	if money >= 0:
		money_label.text = "%d" % money
	else:
		money_label.text = "-%d" % abs(money)

	if money_coin_texture != null and current_screen == GameScreen.GAMEPLAY and current_level_idx >= 1 and current_level_idx <= levels_config.size():
		var star_goals = levels_config[current_level_idx - 1]["stars"]
		if money >= star_goals[2]:
			money_coin_texture.texture = tex_coin_gold
		elif money >= star_goals[1]:
			money_coin_texture.texture = tex_coin_silver
		elif money >= star_goals[0]:
			money_coin_texture.texture = tex_coin_bronze
		else:
			money_coin_texture.texture = tex_coin_empty


# Rebuilds active typing targets and syncs station visuals.
func refresh_ui() -> void:
	build_counter_targets()
	build_kitchen_targets()
	update_order_cards()
	update_counter_station_visuals()
	update_kitchen_station_visuals()
	update_oven_progress()


# TYPING TARGET REGISTRATION (GAMEPLAY)
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

	# 5. Exit counter to main menu: "exit"
	active_counter_targets.append({
		"command": "exit",
		"completion": old_completions.get("exit", 0),
		"label": counter_exit_label,
		"prefix": "",
		"action": "exit"
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
		# 2. Pizza on table: Ingredients ("ADD SAUCE", "ADD CHEESE", "ADD HAM", etc.)
		var topping_labels = {
			"SAUCE": sauce_label,
			"CHEESE": cheese_label,
			"HAM": ham_label,
			"OLIVE": olive_label,
			"PEPPERONI": pepperoni_label,
			"TOMATO": tomato_label,
			"MUSHROOM": mushroom_label
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
		var add_pref = "ADD"
		var typed_add = add_pref.substr(0, max_add_comp)
		var untyped_add = add_pref.substr(max_add_comp)
		add_label.text = "[color=green]" + typed_add + "[/color]" + untyped_add
		add_label.modulate = Color(1, 1, 1, 1.0) if has_pizza else Color(1, 1, 1, 0.3)

		# INGREDIENTS ARE DISABLED/DIMMED UNTIL "ADD " IS TYPED!
		var ing_enabled = has_pizza and (max_add_comp >= 4)
		var ing_color = Color(1, 1, 1, 1.0) if ing_enabled else Color(1, 1, 1, 0.3)
		sauce_label.modulate = ing_color
		cheese_label.modulate = ing_color
		ham_label.modulate = ing_color
		olive_label.modulate = ing_color
		pepperoni_label.modulate = ing_color
		tomato_label.modulate = ing_color
		mushroom_label.modulate = ing_color

		# Render TAKE OUT prefix label above ovens
		var any_baking = pizzeria.ovens.any(func(p): return p != null)
		var to_pref = "TAKE OUT"
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

	# Cheese layer
	var cheese_tex = tex_cheese_melted if is_cooked else tex_cheese_unmelted
	var cheese_node = get_or_create_layer(base_rect, "CheeseLayer", cheese_tex)
	cheese_node.texture = cheese_tex
	cheese_node.visible = pizza.has_topping("CHEESE")

	# Ham layer
	var ham_node = get_or_create_layer(base_rect, "HamLayer", tex_ham)
	ham_node.visible = pizza.has_topping("HAM")

	# Olive layer
	var olive_node = get_or_create_layer(base_rect, "OliveLayer", tex_olives)
	olive_node.visible = pizza.has_topping("OLIVE")

	# Pepperoni layer
	var pep_node = get_or_create_layer(base_rect, "PepLayer", tex_pepperoni)
	pep_node.visible = pizza.has_topping("PEPPERONI")

	# Tomato layer
	var tomato_node = get_or_create_layer(base_rect, "TomatoLayer", tex_tomato)
	tomato_node.visible = pizza.has_topping("TOMATO")

	# Mushroom layer
	var mushroom_node = get_or_create_layer(base_rect, "MushroomLayer", tex_mushroom)
	mushroom_node.visible = pizza.has_topping("MUSHROOM")

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
	var active_limit: int = 4
	if current_screen == GameScreen.GAMEPLAY and current_level_idx >= 1 and current_level_idx <= levels_config.size():
		active_limit = levels_config[current_level_idx - 1].get("active_orders", 4)

	# Show active order slots, hide inactive slots
	for i in range(4):
		order_slot_nodes[i]["container"].visible = (i < active_limit)

	# Show locked panels for slots that are locked (4 - active_limit locked panels)
	var locked_count = 4 - active_limit
	for j in range(locked_order_panels.size()):
		locked_order_panels[j].visible = (j < locked_count)

	for i in range(active_limit):
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

	# Update ingredient labels visibility based on level unlocks
	var unlocked = pizzeria.available_toppings
	sauce_label.visible = unlocked.has("SAUCE")
	cheese_label.visible = unlocked.has("CHEESE")
	ham_label.visible = unlocked.has("HAM")
	olive_label.visible = unlocked.has("OLIVE")
	pepperoni_label.visible = unlocked.has("PEPPERONI")
	tomato_label.visible = unlocked.has("TOMATO")
	mushroom_label.visible = unlocked.has("MUSHROOM")

	# Hide locked panel if all 7 ingredients are unlocked
	if locked_ing_panel != null:
		locked_ing_panel.visible = (unlocked.size() < 7)

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


# SIGNAL CALLBACKS
func _on_state_updated(_arg = null) -> void:
	if current_screen == GameScreen.GAMEPLAY:
		refresh_ui()


func _on_oven_updated(_slot: int, _p: Pizza) -> void:
	if current_screen == GameScreen.GAMEPLAY:
		refresh_ui()


func _on_order_updated(_slot: int, _o: Order) -> void:
	if current_screen == GameScreen.GAMEPLAY:
		refresh_ui()


func _on_order_reviewed(slot: int, review: Dictionary) -> void:
	var max_price = review.get("price", 100)
	var score = review.get("score", 0) # 0 to 100
	var base_earned = roundi(max_price * (score / 100.0))

	orders_completed_count += 1
	orders_completed_money += base_earned
	money += base_earned

	# Streak & Tips (every completed order raises tip percentage by 10%)
	current_streak += 1
	var tip_pct = current_streak * 0.10
	var tip_earned = roundi(base_earned * tip_pct)
	total_tips_earned += tip_earned
	money += tip_earned

	update_money_display()
	play_sfx(sfx_order_completed)
	play_sfx(sfx_cash_up)
	print("Order #%d completed! Score: %d%% | Streak: %d (+%d%% tip: +$%d) | Total Money: $%d" % [
		review.get("order_number", 0), score, current_streak, int(tip_pct * 100), tip_earned, money
	])
	refresh_ui()

	check_level_completion()


func _on_order_expired(_slot: int, was_active: bool) -> void:
	# Failing to take or make an order breaks the streak!
	current_streak = 0
	orders_failed_count += 1
	play_sfx(sfx_fail)

	if was_active:
		# Customer had given their order: -$50 penalty
		money -= 50
		orders_failed_penalty += 50
		update_money_display()
		print("Order expired (was active): -$50 penalty! Streak reset. Current money: %d" % money)
	else:
		# Customer was waiting to take order: -10s penalty
		game_time = maxf(0.0, game_time - 10.0)
		orders_failed_penalty += 10
		update_time_display()
		print("Order expired (waiting to take): -10s penalty! Streak reset. Remaining time: %.1fs" % game_time)
		if game_time <= 0.0:
			trigger_times_up()
			return

	refresh_ui()
	check_level_completion()


func check_level_completion() -> void:
	refill_level_orders()

	# If all orders in queue have spawned, check if any are still active or waiting
	if level_orders_remaining.is_empty():
		var any_pending = false
		for ord in pizzeria.order_slots:
			if ord != null and (ord.status == Order.Status.WAITING_TO_TAKE or ord.status == Order.Status.ACTIVE):
				any_pending = true
				break
		if not any_pending:
			trigger_times_up()


# AUDIO HELPERS
func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	if stream == null or sfx_pool.is_empty():
		return
	for p in sfx_pool:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.play()
			return
	var fallback = sfx_pool[0]
	fallback.stream = stream
	fallback.volume_db = volume_db
	fallback.play()


func play_keyboard_sfx() -> void:
	if sfx_keyboard.is_empty():
		return
	var stream = sfx_keyboard[randi() % sfx_keyboard.size()]
	play_sfx(stream, -6.0)


func stop_clock_sfx() -> void:
	if clock_player != null and clock_player.playing:
		clock_player.stop()


func play_command_sfx(command: String) -> void:
	if command == "INTO OVEN":
		play_sfx(sfx_oven_in)
	elif command.begins_with("slice"):
		play_sfx(sfx_slicing)
	elif command == "pack up":
		play_sfx(sfx_box)
	elif command == "TRASH" or command == "trash":
		play_sfx(sfx_trash)
	elif command.begins_with("give "):
		# OrderCompleted and CashUp are played in _on_order_reviewed
		pass
	else:
		play_sfx(sfx_success)
