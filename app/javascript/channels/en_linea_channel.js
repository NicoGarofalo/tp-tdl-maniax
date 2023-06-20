import consumer from "channels/consumer"

function suscribirseEnLinea(id_user){
	consumer.subscriptions.create({channel: "EnLineaChannel", id: id_user},{
	  connected() {
	  	console.log("CONNECTED EnLinea?");  	
	    // Called when the subscription is ready for use on the server
	    this.perform("appear", {id: id_user});
	  },

	  disconnected() {
	  	console.log("DISCONNECTED EnLinea?");  	
	    this.perform("away", {id: id_user});
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	    // Called when there's incoming data on the websocket for this channel
	  	console.log("RCV data , ",data);  	
	  }
	});
}

export default suscribirseEnLinea
