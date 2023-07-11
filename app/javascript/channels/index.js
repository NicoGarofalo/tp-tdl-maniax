import susLinea from "channels/en_linea_channel"
import susUsuarios from "channels/usuarios_channel"

const channels = {
	"EnLinea": [null, susLinea],
	"Usuarios": [null, susUsuarios],
};

export function suscribirseA(channel, listener, cargar_datos){

	if(!(channel in channels)){
		console.error("Error '"+channel+"' no era un canal existente para suscribirse");
		return;
	}

	let channel_data = channels[channel]

	if( channel_data[0] !== null){
		console.error("Error ya estaba conectado a '"+channel+"'");
		return;
	}

	console.log("Se suscribira a '"+channel+"' se cargara datos? ",cargar_datos);
	channel_data[0] = channel_data[1](listener, cargar_datos);
}

export function deSuscribirseA(channel){

	if(!(channel in channels)){
		console.error("Error '"+channel+"' no era un canal existente para suscribirse");
		return;
	}

	let channel_data = channels[channel]

	if( channel_data[0] === null){
		console.error("Error no estaba conectado a '"+channel+"'");
		return;
	}

	console.log("Se desuscribira a '"+channel+"'");
	channel_data[0].disconnect();
	channel_data[0]= null;
}