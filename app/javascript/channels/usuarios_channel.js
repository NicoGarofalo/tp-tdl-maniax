import consumer from "channels/consumer"


function suscribirseUsuarios(listener, cargar_datos){

	return consumer.subscriptions.create({channel: "UsuariosChannel"},{
	  connected(data) {
	    if(cargar_datos){
	    	this.perform("get_usuarios");
	    }
	  },

	  disconnected() {
	  	console.log("Diconnected usuarios desde Consumer??");  	
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	    // Called when there's incoming data on the websocket for this channel
	  	listener(data)
	  }
	});
}

export default suscribirseUsuarios
