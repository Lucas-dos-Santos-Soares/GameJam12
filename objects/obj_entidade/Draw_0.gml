/// @description Insert description here
// You can write your code in this editor

cor = image_blend
if(identificador==2) cor =c_aqua;


draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * dir, image_yscale, image_angle, cor, image_alpha);



draw_text(x+10, y-32, nome_estado);

if (estado != noone && variable_struct_exists(estado, "hitbox_atual")) {
    if (estado.hitbox_atual != undefined) {
        estado.hitbox_atual.draw();
    }
}

if (hurtbox != undefined) {
    hurtbox.draw();
}

