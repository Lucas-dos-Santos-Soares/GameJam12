/// @description Insert description here
// You can write your code in this editor

#region // variaveis

nome = "inimigo"

vida_max = 30;
vida = vida_max;
dano = 0;

// fisica
velh = 0;
velv = 0;
grav = .2;
aceleracao = 2;
max_velv = 5;
max_velh = 5;
forca_pulo = 10;
dir_x = 0;
dir = 1;
area_visao = 250;

// ataque
distancia_ataque_min = 40;
distancia_ataque_max = 50;
cooldown_ataque = 0;

// estado
estado = noone;
trava_estado = false;
timer_estado_max = irandom_range(200, 300);
timer_estado = timer_estado_max;
nome_estado = "";
alvo = noone;




// variaveis de ataques
ataques = {};

ataques.ataque1 = {
    dano: 10,
    hitboxes: [
        { ini: 0, fim: 5, x1: 8,  y1: -60, x2: 40, y2: -15 },
    ],
};


hurtbox = new Hurtbox(id, x1, y1, x2, y2);

#endregion


#region

checa_chao = function() {
	return place_meeting(x, y + 1, obj_chao);
}


pula = function() {
	velv -= max_velv
	velv = clamp(velv, -max_velv, max_velv);
}

movimento = function() {
	velh += dir_x * aceleracao;
	
	if (dir_x != 0) dir = sign(dir_x);
	if(dir_x == 0) {
		velh -= min(abs(velh), aceleracao) * sign(velh);
	}
	
	velh = clamp(velh, -max_velh, max_velh);
	
	if(!checa_chao()) {
		velv += grav;
	}else if(velv > 0){
		velv = 0
	}
	
	colisao();
}

colisao = function() {
	var move_x = round(velh);
	var move_y = round(velv);
	
	// X
    if (place_meeting(x + move_x, y, obj_chao)) {
        while (!place_meeting(x + sign(move_x), y, obj_chao)) {
            x += sign(move_x);
        }
        velh = 0;
    } else {
        x += move_x;
    }

    // Y
    if (place_meeting(x, y + move_y, obj_chao)) {
        while (!place_meeting(x, y + sign(move_y), obj_chao)) {
            y += sign(move_y);
        }
        velv = 0;
    } else {
        y += move_y;
    }
}

animacao_acabou = function() {
	return image_index >= image_number - 1;
}

troca_sprite = function(_sprite) {
	if(_sprite == undefined) {
		sprite_index = spr_player_idle;
		image_index = 0;
		return
	}
	
	if(sprite_index != _sprite) {
		sprite_index = _sprite;
		image_index = 0;
	}
}

define_estado = function(novo_estado) {
	if(estado == novo_estado) return;
	
	if(trava_estado && !novo_estado.forca) return;
	
	if (estado != noone && variable_struct_exists(estado, "hitbox_atual")) {
        estado.hitbox_atual = undefined;
    }
	
	if(estado != noone && variable_struct_exists(estado, "fim")) {
		estado.fim();
	}
	
	if(vida <= 0) {
		estado = estado_morre;
		return
	}
	
	estado = novo_estado;
	if(variable_struct_exists(estado, "inicio")) {
		estado.inicio();
	}
}

muda_estado = function() {
	if(timer_estado>=0) {
		timer_estado--;
		return false;
	}else{
		timer_estado = timer_estado_max;
	}
	if(nome_estado == "parado"){
		return (irandom(100) <= 80)
	}
	if(nome_estado == "patrulha"){
		return (irandom(100) <= 35)
	}
	return false
}

checa_area = function(_tamanho_area = 0, _obj_alvo = noone) {
	var inst = collision_circle(x, y, _tamanho_area, _obj_alvo, false, true);
	return inst;
}

define_direcao_alvo = function(_alvo) {
	return sign(_alvo.x - x);
}

dist_x_alvo = function(_alvo) {
    return abs(_alvo.x - x);
}

recebe_dano = function(_dano, outro) {
	vida -= _dano;
	
	var dx = x - outro.x;
	var dy = y - outro.y;

	var direcao = point_direction(0, 0, dx, dy);
	var forca = 30;

	velh = lengthdir_x(forca, direcao);
	velv = lengthdir_y(forca, direcao);
	
	define_estado(estado_dano);
}

#endregion


#region // estados


estado_parado = {
	dono: id,
	prioridade: 1,
	forca: false,
	
	inicio: function() {
		dono.nome_estado = "parado";
		dono.troca_sprite(spr_player_idle);
		dono.dir_x = 0
	},
	
	atualiza: function() {
		dono.movimento();
		
		var detectado = dono.checa_area(dono.area_visao, obj_entidade);
		if(detectado) {
			dono.define_estado(dono.estado_persegue);
			return;
		}
		
		var muda = dono.muda_estado()
		if(muda) {
			dono.define_estado(dono.estado_patrulha);
			return;
		}
		
	}
};

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
		
		var detectado = dono.checa_area(dono.area_visao, obj_entidade);
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
		
		
		var detectado = dono.checa_area(dono.area_visao, obj_entidade);
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

estado_cai = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "cai";
		dono.troca_sprite(spr_player_fall);
	},
	
	atualiza: function() {
		dono.movimento();
		
		if(dono.checa_chao()) {
			dono.define_estado(dono.estado_parado);
			return;
		}
	},
	
}


estado_ataque = {
    dono: id,
	hitbox_atual: undefined,
	hitbox_ativa: false,
		
    inicio: function() {
        dono.nome_estado = "ataque";
        dono.troca_sprite(spr_player_ataque);
			
        ataque = dono.ataques.ataque1
			
        hitbox_atual = undefined;
		hitbox_ativa = false;
			
		if (instance_exists(dono.alvo)) {
		    dono.dir = sign(dono.alvo.x - dono.x);
		    if (dono.dir == 0) dono.dir = 1;
		}
			
    },

    atualiza: function() {
			
        var frame = floor(dono.image_index);

        // HITBOX
        var ativa = false;
        for (var i = 0; i < array_length(ataque.hitboxes); i++) {
            var hb = ataque.hitboxes[i];

            if (frame >= hb.ini && frame <= hb.fim) {
                ativa = true;
				hitbox_ativa = true;

                if (hitbox_atual == undefined) {
                    hitbox_atual = new Hitbox(
                        dono,
                        hb.x1, hb.y1,
                        hb.x2, hb.y2,
                        ataque.dano,
						self
                    );
                }

                hitbox_atual.update();
                break;
            }
        }

        if (!ativa) hitbox_atual = undefined;


        if (dono.animacao_acabou()) {
            dono.define_estado(dono.estado_parado);
			return
        }
    },
		
	fim: function() {
		hitbox_atual = undefined;
		hitbox_ativa = false;
		dono.cooldown_ataque = 50; 
	}
		
}

estado_dano = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "dano";
		dono.troca_sprite(spr_player_hit);
		dono.dano = 0;
	},
	
	atualiza: function() {
		dono.movimento();
		dono.image_blend = c_red;
		
		if (dono.animacao_acabou()) {
			dono.define_estado(dono.estado_parado);
			return;
        }
	},
	
	fim: function() {
		dono.image_blend = c_white;
	}
	
}

estado_morre = {
	dono: id,
	prioridade: 7,
	forca: true,
	
	inicio: function() {
		dono.nome_estado = "morre";
		dono.troca_sprite(spr_player_idle);
	},
	
	atualiza: function() {
		
		if (dono.animacao_acabou()) {
			instance_destroy(dono);
			return;
        }
	},
	
	
}



#endregion

define_estado(estado_parado);





