#macro FPS game_get_speed(gamespeed_fps)

function array_contains_manual(_array, _value) {
    var _len = array_length(_array);
    for (var i = 0; i < _len; i++) {
        if (_array[i] == _value) {
            return true;
        }
    }
    return false;
}

function Hitbox(_dono, _x1, _y1, _x2, _y2, _dano, _estado) constructor {
	dono = _dono;
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	dano = _dano;
	estado = _estado;

	acertados = [];

	update = function() {
		var hx1 = dono.x + x1 * dono.dir;
		var hy1 = dono.y + y1;
		var hx2 = dono.x + x2 * dono.dir;
		var hy2 = dono.y + y2;

		if(dono.nome == "player") {
			var lista = ds_list_create();
			collision_rectangle_list(
				hx1, hy1, hx2, hy2,
				obj_inimigo, false, true,
				lista, true
			);
		} else{
			var lista = ds_list_create();
				collision_rectangle_list(
				hx1, hy1, hx2, hy2,
				obj_entidade, false, true,
				lista, true
			);
		}
		

		for (var i = 0; i < ds_list_size(lista); i++) {
			var alvo = lista[| i];
			if (alvo == dono) continue;
			if (array_contains_manual(acertados, alvo)) continue;
			if (rectangle_in_rectangle(
				hx1, hy1, hx2, hy2,
				alvo.hurtbox.x1 + alvo.x,
				alvo.hurtbox.y1 + alvo.y,
				alvo.hurtbox.x2 + alvo.x,
				alvo.hurtbox.y2 + alvo.y
			)) {
				alvo.recebe_dano(dano, dono);
				array_push(acertados, alvo);
			}
		}

		ds_list_destroy(lista);
	};

	draw = function() {
		draw_set_color(c_red);
		draw_rectangle(
			dono.x + x1 * dono.dir,
			dono.y + y1,
			dono.x + x2 * dono.dir,
			dono.y + y2,
			true
		);
		draw_set_color(c_white);
	};
}

function Hurtbox(_dono, _x1, _y1, _x2, _y2) constructor {
	dono = _dono;
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;

	draw = function() {
		draw_set_color(c_blue);
		draw_rectangle(
			dono.x + x1,
			dono.y + y1,
			dono.x + x2,
			dono.y + y2,
			true
		);
		draw_set_color(c_white);
	};
}

