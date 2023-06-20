class EnLineaChannel < ApplicationCable::Channel
  def subscribed

    puts "Se Suscribio... "+current_user.to_s

    stream_for "online"
  end

  def unsubscribed
    puts "Se desuscribio(desconecto)... "+current_user.to_s

  	puts "-----------------> SE DE SUBSCRIBIO ? "+current_user.nombre
	notificarCambio(false)  	
  end

  def appear(data)
  	puts "--------->se conecto ...? id?= "+data['id'].to_s
  	puts "--------->id current user es ...id?= "+current_user.id.to_s
	notificarCambio(true)

  end

  def away
  	puts "--------->se desconecto ...? id?= "+data['id'].to_s
  	puts "--------->id current user es ...id?= "+current_user.id.to_s
	notificarCambio(false)

  end

  private
  	def notificarCambio(activo)  		
		EnLineaChannel.broadcast_to("online", nuevo: current_user.nombre, id_usuario: current_user.id, activo: activo)
  	end
end
