/// @description Insert description here
// You can write your code in this editor


// Inherit the parent event
event_inherited();

identificador = 2


estado_iniciando = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "medita";
		dono.troca_sprite(spr_player_idle);
		dono.velv = -5;
		dono.hurtbox = noone;
	},
	
	atualiza: function() {
		dono.movimento();
		if (!instance_exists(dono.espirito)) {
			dono.define_estado(dono.estado_parado);
        }
	},
	
}


estado = estado_iniciando