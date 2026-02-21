/// @description Insert description here
// You can write your code in this editor


if(identificador==1){
	// Evento Draw GUI
	var _largura = 200; // Largura da barra
	var _altura = 20;   // Altura da barra
	var _x1 = 10;       // Posição X esquerda (margem)
	var _y1 = 10;       // Posição Y topo (margem)
	var _x2 = _x1 + _largura;
	var _y2 = _y1 + _altura;

	
	// Cálculo da porcentagem (0 a 100)
	var saude = (vida / vida_max) * 100;

	// Desenhar a barra
	draw_healthbar(_x1, _y1, _x2, _y2, saude, c_black, c_red, c_lime, 0, true, true);
}




