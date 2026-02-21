/// @description Insert description here
// You can write your code in this editor


//Desenhando um texto em mim
draw_self();


draw_set_color(c_black);
//Definindo minha font

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x + 32, y + 32, texto);
draw_set_color(c_white);

draw_set_halign(-1);
draw_set_valign(-1);

