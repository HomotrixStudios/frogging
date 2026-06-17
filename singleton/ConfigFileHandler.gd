extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"


func _ready() -> void:
    if !FileAccess.file_exists(SETTINGS_FILE_PATH):
        config.set_value("keybinding", "jump", "Space")
        config.set_value("keybinding", "dash", "Ctrl")
        config.set_value("keybinding", "shift", "Shift")
        config.set_value("keybinding", "attack", "mouse_1")
        config.set_value("keybinding", "lick_attack", "Y")
        config.set_value("keybinding", "down", "S")

        config.save(SETTINGS_FILE_PATH)
    else:
        config.load(SETTINGS_FILE_PATH)
    
    var keybindings = load_keybindings()
    for action in keybindings.keys():
        InputMap.action_erase_events(action)
        InputMap.action_add_event(action, keybindings[action])


func save_keybinding(action: StringName, event: InputEvent) -> void:
    var event_str
    if event is InputEventKey:
        event_str = OS.get_keycode_string(event.physical_keycode)
    elif event is InputEventMouseButton:
        event_str = "mouse_" + str(event.button_index)

    config.set_value("keybinding", action, event_str)
    config.save(SETTINGS_FILE_PATH)


func load_keybindings():
    var keybindings = {}
    var keys = config.get_section_keys("keybinding")
    for key in keys:
        var input_event
        var event_str = config.get_value("keybinding", key)

        if event_str.contains("mouse_"):
            input_event = InputEventMouseButton.new()
            input_event.button_index = int(event_str.split("_")[1])
        else:
            input_event = InputEventKey.new()
            input_event.keycode = OS.find_keycode_from_string(event_str)
        
        keybindings[key] = input_event
    
    return keybindings
