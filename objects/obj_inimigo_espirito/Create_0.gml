/// @description Insert description here
// You can write your code in this editor



// Inherit the parent event
event_inherited();
identificador = 2
estado_persegue = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "persegue";
		dono.troca_sprite(spr_player_run);
	},
	
	atualiza: function() {
		
		if(!dono.checa_chao()) {
			dono.define_estado(dono.estado_cai);
			return;
		}
				
		
		var detectado = dono.checa_area(dono.area_visao, obj_player_espirito);
		dono.alvo = detectado;
		
		if (dono.alvo != noone) {
			var d = dono.dist_x_alvo(dono.alvo);

			// fora do alcance → anda
			if (d > dono.distancia_ataque_max) {
			    dono.dir_x = dono.define_direcao_alvo(dono.alvo);
			}

			// dentro da zona → para
			else if (d >= dono.distancia_ataque_min && d <= dono.distancia_ataque_max) {
			    dono.dir_x = 0;
			}

			// colado demais → recua (opcional, mas MUITO bom)
			else if (d < dono.distancia_ataque_min) {
			    dono.dir_x = -dono.define_direcao_alvo(dono.alvo);
			}

			if (d >= dono.distancia_ataque_min && d <= dono.distancia_ataque_max) {
				if(dono.cooldown_ataque <= 0) {
					dono.define_estado(dono.estado_ataque);
				}
			    return;
			}


			dono.movimento();
		} else {
			dono.alvo = noone
			dono.define_estado(dono.estado_parado);
			return;
		}
		
	},
	
}

estado_patrulha = {
	dono: id,
	prioridade: 2,
	forca: false,
	
	inicio: function() {
		dono.nome_estado = "patrulha";
		dono.troca_sprite(spr_player_run);
		dono.dir_x = choose(-1, 1);
	},
	
	atualiza: function() {
		if(dono.velh == 0) dono.dir_x*=-1
		dono.movimento();
		
		if(!dono.checa_chao()) {
			dono.define_estado(dono.estado_cai);
			return;
		}
		
		var detectado = dono.checa_area(dono.area_visao, obj_player_espirito);
		dono.alvo = detectado;
		if (dono.alvo != noone) {
			dono.define_estado(dono.estado_persegue);
			return;
		}
				
		if(dono.muda_estado()) {
			dono.define_estado(dono.estado_parado);
			return;
		}
		
	}
}

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