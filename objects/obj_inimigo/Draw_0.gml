/// @description Insert description here
// You can write your code in this editor

var d = (dir == 0) ? 1 : dir;

cor = image_blend
if(identificador==2) {
	cor = c_aqua;
	escala_x = image_xscale * 2;
	escala_y = image_yscale * 2;
}
escala_x = image_xscale
escala_y = image_yscale


draw_sprite_ext(sprite_index, image_index, x, y, escala_x * dir, escala_y, image_angle, cor, image_alpha);
//draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * d, image_yscale, image_angle, cor, image_alpha);


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

//var _vida = (vida / vida_max) * 100;
//draw_healthbar(x - 30, y - 70, x + 30, y - 65, _vida, c_black, c_red, c_aqua, 1, 1, 1);