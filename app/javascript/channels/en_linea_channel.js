import consumer from "channels/consumer"


function suscribirseEnLinea(listener, cargar_datos){

	consumer.subscriptions.create({channel: "EnLineaChannel"},{
	  connected(data) {

	    document.addEventListener("turbo:load", ()=>{

	    	if (window.location.pathname === "/iniciar_sesion"){
	    		this.perform("away");
	    		consumer.subscriptions.consumer.disconnect()
	    		listener({action: "delete"})
	    		console.log("CLOSING CONSUMER");
	    	}
	    });
	    if(cargar_datos){
	    	this.perform("get_subs");
	    }

	    this.perform("appear");
	  },

	  disconnected() {
	  	console.log("Diconnected EnLinea desde Consumer??");  	
	    this.perform("away");
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	    // Called when there's incoming data on the websocket for this channel
	  	console.log("RCV data , ",data);
	  	listener(data)
	  }
	});
}

export default suscribirseEnLinea
