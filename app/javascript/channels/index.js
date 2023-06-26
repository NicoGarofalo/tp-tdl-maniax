import susLinea from "channels/en_linea_channel"

const channels = {
	"EnLinea": susLinea,
};

export function suscribirseA(channel, listener, cargar_datos){

	if(!(channel in channels)){
		console.error("Error '"+channel+"' no era un canal existente para suscribirse");
		return;
	}

	console.log("Se suscribira a '"+channel+"' se cargara datos? ",cargar_datos);
	channels[channel](listener, cargar_datos);

}

export default suscribirseA