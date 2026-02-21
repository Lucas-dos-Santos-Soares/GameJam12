/// @description Insert description here
// You can write your code in this editor

var d = (dir == 0) ? 1 : dir;

if(image_blend != c_red) {
	cor = c_gray
}else{
	cor = image_blend
}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * d, image_yscale, image_angle, cor, image_alpha);


draw_text(x - 32, y - 86, nome_estado)

if (estado != noone && variable_struct_exists(estado, "hitbox_atual")) {
    if (estado.hitbox_atual != undefined) {
        estado.hitbox_atual.draw();
    }
}

if (hurtbox != undefined) {
    hurtbox.draw();
}

draw_circle(x,y,area_visao, true);

var _vida = (vida / vida_max) * 100;
draw_healthbar(x - 30, y - 70, x + 30, y - 65, _vida, c_black, c_red, c_aqua, 1, 1, 1);