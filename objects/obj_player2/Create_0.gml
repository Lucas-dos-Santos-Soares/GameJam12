/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

pega_input = function() {
	return {
		dir_x: keyboard_check(vk_right) - keyboard_check(vk_left),
		pula: keyboard_check_pressed(vk_up),
		ataque1: keyboard_check_pressed(vk_numpad1)
	}
}



