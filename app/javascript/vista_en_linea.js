
//const onlineUsers = document.getElementById("onlineUsers");
let inicalizado = false;

function id_for(id_user){
	return "usuario_"+id_user
}

function obtenerElemento(id_user){
	return document.getElementById(id_for(id_user));
}

function modificarElemento(usuario,onlineUsers){
	const elemento = obtenerElemento(usuario.id);

	if(elemento){
		console.log("MODIFICANDO");
		const activo_msj = elemento.querySelectorAll("[name=\"status\"]");

		console.log("activo", activo_msj);
	} else{
		console.log(" NO ESTABA?? ",usuario);
		agregarElemento(usuario, onlineUsers);
	}
}
	
function agregarElemento(usuario,onlineUsers){

	console.log("AGREGANDO .... ",usuario);
	const elementoNuevo= `<li id="${id_for(usuario.id)}">
		<p style="float: inline-start;">${usuario.nombre}</p>
		<p style="margin-left: 2rem;" name= "status">online</p></li>`;
		
	onlineUsers.innerHTML = onlineUsers.innerHTML+elementoNuevo;

}

export default function updateViewOnline(data, onlineUsers){
	if(data["action"] == "get"){
		if(inicalizado){
			return;
		}

			
		onlineUsers.innerHTML = "";

		console.log("activos inicio",data["enLinea"])
			
		data["enLinea"].forEach( usuario =>{
			agregarElemento(usuario.current_user,onlineUsers)
		})

		inicalizado = true;

		return;
	} 

	if(inicalizado == false){
		console.log(" NO ESTABA INCIALIZADO ...");
		return;
	}

	if(!data["activo"]){

		const elemento = obtenerElemento(data["id_usuario"]);

		if(elemento){
			elemento.remove()
		}
	} else{
		console.log("modificar activo ...",data);
		modificarElemento(data["nuevo"], onlineUsers);
	}
}