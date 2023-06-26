import consumer from "channels/consumer"

//let seSuscribio = false;

function suscribirseEnLinea(listener, cargar_datos){

	//if(seSuscribio){
		//console.log("NO HIZO NADA YA QUE YA SE HABIA SUSCRIPTO");
		//return;
	//}
	//seSuscribio = true;


	//console.log("Consumer",consumer.connection);
	//console.log("Res: '", consumer.subscriptions.findAll("EnLineaChannel"),"'");

	consumer.subscriptions.create({channel: "EnLineaChannel"},{
	  connected(data) {
	  	//console.log("CONNECTED EnLinea? '",data,"'");  	
	    // Called when the subscription is ready for use on the server

	    document.addEventListener("turbo:load", ()=>{
	    	// no es ideal lol
	    	if (window.location.pathname === "/iniciar_sesion"){
	    		this.perform("away");
	    		consumer.subscriptions.consumer.disconnect()
	    		listener({action: "delete"})
	    		console.log("CLOSING CONSUMER");
	    	}
	    });
	    //console.log("CONNECTED TO EN LINEA ....");
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

	//consumer.subscriptions.subscriptions.forEach(element => console.log("Existe susbcripcion",element));
}

export default suscribirseEnLinea
