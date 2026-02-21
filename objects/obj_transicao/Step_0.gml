/// @description Insert description here
// You can write your code in this editor


if(trocou_room == false) {
	alpha += .02;
}else{
	alpha -= .02;
}

if(alpha <= 0 && trocou_room == true) {
	instance_destroy();
}

if(alpha >= 1 && !trocou_room) {
	room_goto(destino);
}





