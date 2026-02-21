/// @description Insert description here
// You can write your code in this editor

inputs = pega_input();

if(inputs.ataque1) {
	buffer_ataque++;
    buffer_ataque = min(buffer_ataque, 1);
	buffer_timer = buffer_max;
}

if(buffer_timer > 0) {
	buffer_timer--;
}else{
	buffer_ataque = 0;
}

if(zonzo > 0) {
	zonzo--;
}

if(checa_chao()) {
	coyote_timer = coyote_max;
}else{
	coyote_timer = max(0, coyote_timer - 1);
}

estado.atualiza();


