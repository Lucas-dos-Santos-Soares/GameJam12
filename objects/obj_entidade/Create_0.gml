/// @description Insert description here
// You can write your code in this editor


#region // variaveis

nome = "player"

identificador = 0

espirito = noone;

// vida
vida_max = 1
vida = vida_max

// fisica
velv = 0;
velh = 0;
velh_max = 10;
aceleracao = 2;
grav = .2;
dir = 1;
forca_pulo = 10;

//buffer de input
buffer_ataque = 0;
buffer_timer = 0;
buffer_max = 10;

zonzo = 0;

cooldown_medita = 0;

// inputs
inputs = {
	dir_x: 0,
	pula: false,
	ataque1: false,
	previsao: false,
	fim_previsao: false,
}

// coyote time
coyote_timer = 0;
coyote_max = 10;

// variaveis de ataques
ataques = {};

ataques.ataque1 = {
    dano: 10,
    hitboxes: [
        { ini: 0, fim: 5, x1: 8,  y1: -60, x2: 40, y2: -15 },
    ]
};


// estado
estado = noone;
nome_estado = ""

hurtbox = new Hurtbox(id, x1, y1, x2, y2);

#endregion

#region // métodos


pega_input = function() {
	return {
		dir_x: keyboard_check(ord("D")) - keyboard_check(ord("A")),
		pula: keyboard_check_pressed(vk_space),
		ataque1: keyboard_check_pressed(ord("K")),
		previsao: keyboard_check(vk_shift),
		fim_previsao: keyboard_check(vk_control)
	}
}

checa_chao = function() {
	return place_meeting(x, y + 1, obj_chao);
}

colisao = function() {
    var move_x = round(velh);
    var move_y = round(velv);
	
    if (place_meeting(x + move_x, y, obj_chao)) {
        while (!place_meeting(x + sign(move_x), y, obj_chao)) {
            x += sign(move_x);
        }
        velh = 0;
    } else {
        x += move_x;
    }
	
    if (place_meeting(x, y + move_y, obj_chao)) {
        while (!place_meeting(x, y + sign(move_y), obj_chao)) {
            y += sign(move_y);
        }
        velv = 0;
    } else {
        y += move_y;
    }
}

movimento = function() {
	var _dir_x = inputs.dir_x;

	// aceleração horizontal
	if (_dir_x != 0) {
		velh += _dir_x * aceleracao;
		dir = sign(_dir_x);
	} else {
		// atrito
		velh -= min(abs(velh), aceleracao) * sign(velh);
	}

	velh = clamp(velh, -velh_max, velh_max);

	// gravidade
	if (!checa_chao()) {
		velv += grav;
	} else if (velv > 0) {
		velv = 0;
	}

	colisao();
}

troca_sprite = function(_sprite) {
	
	if(_sprite == undefined) {
		sprite_index = spr_player_idle;
		image_index = 0;
	}
	
	if(sprite_index != _sprite) {
		sprite_index = _sprite;
		image_index = 0;
	}
}

acabou_animacao = function() {
	return image_index >= image_number - 1;
}


define_estado = function(novo_estado) {
	
	if((estado != noone) && variable_struct_exists(estado, "fim")) {
		estado.fim();
	}
	
	estado = novo_estado;
	if(variable_struct_exists(estado, "inicio")) {
		estado.inicio();
	}
}

recebe_dano = function(_dano, outro) {
	vida -= _dano;
	
	var dx = x - outro.x;
	var dy = y - outro.y;

	var direcao = point_direction(0, 0, dx, dy);
	var forca = 30;

	velh = lengthdir_x(forca, direcao);
	velv = lengthdir_y(forca, direcao);
	
	if(identificador==2){
		if(instance_exists(obj_player)) {
			obj_player.zonzo = 50;
			obj_player.define_estado(obj_player.estado_zonzo);
		}
	}
	if(identificador==1) {
		if(instance_exists(obj_player2)) {
			obj_player2.zonzo = 50;
			obj_player2.define_estado(obj_player2.estado_zonzo)
		}
	}
	
	define_estado(estado_dano);
}

#endregion


#region // estados

estado_parado = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "parado";
		dono.troca_sprite(spr_player_idle);
		dono.velv = 0;
		dono.velh = 0;
	},
	
	atualiza: function() {
		if(dono.inputs.pula && dono.coyote_timer > 0) {
			dono.coyote_timer = 0;
			dono.define_estado(dono.estado_pulo);
			return;
		}
		if(!dono.checa_chao()) {
			dono.define_estado(dono.estado_cai);
			return;
		}
		if(dono.inputs.dir_x != 0) {
			dono.define_estado(dono.estado_move);
			return;
		}
		if(dono.inputs.ataque1) {
			dono.define_estado(dono.estado_ataque);
			return;
		}
		if(dono.inputs.previsao && (dono.identificador!=2) && (dono.cooldown_medita<=0)) {
			dono.define_estado(dono.estado_medita);
			return;
		}
		if(dono.inputs.fim_previsao && dono.identificador==2) {
			instance_destroy(dono)
			return;
		}
	},
};

estado_move = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "move";
		dono.troca_sprite(spr_player_run);
	},
	
	atualiza: function() {
		dono.movimento();
		if(!dono.checa_chao()) {
			dono.define_estado(dono.estado_cai);
			return;
		}
		if(dono.inputs.pula && (dono.coyote_timer > 0)) {
			dono.coyote_timer = 0;
			dono.define_estado(dono.estado_pulo);
			return;
		}
		if(dono.inputs.dir_x == 0) {
			dono.define_estado(dono.estado_parado);
			return;
		}
		if(dono.inputs.ataque1) {
			dono.define_estado(dono.estado_ataque);
			return;
		}
		if(dono.inputs.fim_previsao && dono.identificador==2) {
			instance_destroy(dono)
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
		
		if(dono.inputs.pula && (dono.coyote_timer > 0)) {
			dono.coyote_timer = 0;
			dono.define_estado(dono.estado_pulo);
			return;
		}
		
		if(dono.checa_chao()) {
			dono.define_estado(dono.estado_parado);
			return;
		}
		if(dono.inputs.fim_previsao && dono.identificador==2) {
			instance_destroy(dono)
			return;
		}
	},
}

estado_pulo = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "pula";
		dono.troca_sprite(spr_player_jump);
		dono.velv -=dono.forca_pulo;
	},
	
	atualiza: function() {
		dono.movimento();
		if(dono.velv >= 0) {
			dono.define_estado(dono.estado_cai);
			return;
		}
		if(dono.inputs.fim_previsao && dono.identificador==2) {
			instance_destroy(dono)
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
    },

    atualiza: function() {
        dono.movimento();

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


        if (dono.acabou_animacao()) {
            dono.define_estado(dono.estado_parado);
			return
        }
		
		if(dono.inputs.fim_previsao && dono.identificador==2) {
			instance_destroy(dono)
			return;
		}
    },
		
	fim: function() {
		hitbox_atual = undefined;
		hitbox_ativa = false;
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
		
		if (dono.acabou_animacao()) {
			dono.define_estado(dono.estado_parado);
        }
		
		if(dono.inputs.fim_previsao && dono.identificador==2) {
			instance_destroy(dono)
			return;
		}
	},
	
	fim: function() {
		dono.image_blend = c_white;
	}
	
}

estado_zonzo = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "tonto";
		dono.troca_sprite(spr_player_zonzo);
	},
	
	atualiza: function() {
		if (dono.zonzo<=0) {
			dono.define_estado(dono.estado_parado);
        }
	},
	
}

cria_espirito = function() {
	espirito = instance_create_layer(x, y, "Instances", obj_player_espirito)
}

estado_medita = {
	dono: id,
	
	inicio: function() {
		dono.nome_estado = "medita";
		dono.troca_sprite(spr_player_idle);
		if (!instance_exists(dono.espirito)) {
			dono.cria_espirito()
		}
	},
	
	atualiza: function() {
		if (!instance_exists(dono.espirito)) {
			dono.define_estado(dono.estado_parado);
        }
	},
	
	fim: function() {
		dono.cooldown_medita = 100;
	}
	
}


#endregion


estado = estado_parado;

