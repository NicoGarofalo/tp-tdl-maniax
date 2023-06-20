import susLinea from "channels/en_linea_channel"

console.log("MENSAJE DESDE INDEX");

function otraFuncion(id, listener){
	console.log("Se suscribio a OTRO CHANNEL? id"+id);
}

const channels = {
	"EnLinea": susLinea,
	"Otro": otraFuncion,
};


export function suscribirseA(channel, id, listener){

	if(!(channel in channels)){
		console.error("Error '"+channel+"' no era un canal existente para suscribirse");
		return;
	}
	console.log("Se suscribira a '"+channel+"'");
	channels[channel](id, listener);

}

export default suscribirseA