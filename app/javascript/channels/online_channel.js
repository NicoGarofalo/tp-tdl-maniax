
consumer.subscriptions.create({ channel: "OnlineChannel" },
{ // creas como una clase, e implementas sus metodos

  // Called once when the subscription is created.
  initialized() {
  	console.log("INITIALIZED SUBSCRIPTION");
    //this.update = this.update.bind(this)
  },

  // Called when the subscription is ready for use on the server.
  connected() {
  	console.log("CONNECTED.. now installing");
    //this.install()
  	console.log("CONNECTED.. now updating");
    //this.update()
  },

  // Called when the WebSocket connection is closed.
  disconnected() {
  	console.log("DISCONNECTED ...");
    //this.uninstall()
  },

  // Called when the subscription is rejected by the server.
  rejected() {
  	console.log("CONNECTION REJECTED...");
    
    //this.uninstall()
  },
  received(data) {
  	console.log("Received some data:", data);
  }
  /*

  update() {
    this.documentIsActive ? this.appear() : this.away()
  },

  appear() {
    // Calls `AppearanceChannel#appear(data)` on the server.
    this.perform("appear", { appearing_on: this.appearingOn })
  },

  away() {
    // Calls `AppearanceChannel#away` on the server.
    this.perform("away")
  },

  // Pones listeners para actualizar?
  install() {
    window.addEventListener("focus", this.update)
    window.addEventListener("blur", this.update)
    document.addEventListener("turbo:load", this.update)
    document.addEventListener("visibilitychange", this.update)
  },

  // Sacas listeners para actualizar?
  uninstall() {
    window.removeEventListener("focus", this.update)
    window.removeEventListener("blur", this.update)
    document.removeEventListener("turbo:load", this.update)
    document.removeEventListener("visibilitychange", this.update)
  },

  // Verificas o seteas lo que consideras como "activo" u "online"
  get documentIsActive() {
    return document.visibilityState === "visible" && document.hasFocus()
  },


  // Obtenes algo del document un elemento lol...
  get appearingOn() {
    const element = document.querySelector("[data-appearing-on]")
    return element ? element.getAttribute("data-appearing-on") : null
  }

  */
})