import consumer from "channels/consumer"

function suscribirseEnLinea(listener){


	console.log("Consumer",consumer.connection);

	console.log("Res: '", consumer.subscriptions.findAll("EnLineaChannel"),"'");
	consumer.subscriptions.create({channel: "EnLineaChannel"},{
	  connected(data) {
	  	console.log("CONNECTED EnLinea? '",data,"'");  	
	    // Called when the subscription is ready for use on the server
	    this.perform("appear");

	    this.perform("get_subs");

	  },

	  disconnected() {
	  	console.log("DISCONNECTED EnLinea?");  	
	    this.perform("away");
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {

	    // Called when there's incoming data on the websocket for this channel
	  	console.log("RCV data , ",data);

	  	listener(data)
	  }
	});

	consumer.subscriptions.subscriptions.forEach(element => console.log("Deberia haber esta",element));
}

export default suscribirseEnLinea
