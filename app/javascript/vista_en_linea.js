
//const onlineUsers = document.getElementById("onlineUsers");
let inicalizado = false;
let usuariosActivos= {};

function id_for(id_user) {
	return "usuario_" + id_user
}

function obtenerElemento(id_user) {
	return document.getElementById(id_for(id_user));
}

function modificarElemento(usuario, onlineUsers) {
	//const elemento = obtenerElemento(usuario.id);
	if(id_for(usuario.id) in usuariosActivos){
		return;// por ahora si esta es por que estuvo activo.
	}

	onlineUsers.innerHTML+= buildElemento(usuario);
}

function buildElemento(usuario){
	const elementoNuevo = `<li id="${id_for(usuario.id)}"  class="list-group-item d-flex justify-content-between align-items-center">
		<span>${usuario.nombre + " " + usuario.apellido}</span>
		<span  name= "status" class="badge bg-success d-flex">Online</p></li>`;
	usuariosActivos[id_for(usuario.id)] = elementoNuevo;
	return elementoNuevo;
}


export function initializeOn(onlineUsers){

	if(Object.keys(usuariosActivos).length === 0){
		return false;
	}
	// ya se habia inicializado. Por ende tambien se habia suscripto
	console.log("Cargando elementos Anteriores",usuariosActivos);

	let innerHTML= ""; 
	Object.values(usuariosActivos).forEach( (elemento)=>{
		innerHTML+= elemento;
	});

	if(innerHTML == ""){
		return false;
	}


	onlineUsers.innerHTML = innerHTML;

	return true;
}

export function updateViewOnline(data, onlineUsers) {
	if (data["action"] == "get") {
		if (inicalizado) {
			return;
		}


		//onlineUsers.innerHTML = "";

		console.log("activos inicio", data["enLinea"])
		let innerHTML = "";

		Object.values(data["enLinea"]).forEach(usuario => {
			innerHTML+= buildElemento(usuario);
		});

		inicalizado = true;

		onlineUsers.innerHTML = innerHTML;
		return;
	} else if(data["action"] == "delete"){
		console.log("DELETING CURRENT ACTIVOS ",usuariosActivos);
		usuariosActivos= {};
		//onlineUsers.innerHTML = "";
		return;
	}

	if (inicalizado == false) {
		console.log(" NO ESTABA INCIALIZADO ...");
		return;
	}

	if (!data["activo"]) {

		const elemento = obtenerElemento(data["id_usuario"]);

		if (elemento) {
			elemento.remove()
		}

		delete usuariosActivos[id_for(data["id_usuario"])];
	} else {
		console.log("modificar activo ...", data);
		modificarElemento(data["nuevo"], onlineUsers);
	}
}