class EnLineaChannel < ApplicationCable::Channel
  def subscribed

	@current_user = Usuario.find_by(params[:id].to_s);

	if @current_user.nil?
		puts "-------->Tira error no existe el usuario?"
	end

    puts "-----------------> SE SUBSCRIBIO ? "+@current_user.nombre
    stream_for "online"
  end

  def unsubscribed
  	if @current_user.nil?
  		puts "------> nunca debio existir esta conexion..."
  	else
  		puts "-----------------> SE DE SUBSCRIBIO ? "+@current_user.nombre
		notificarCambio(@current_user.id, false)
  	end
  end

  def appear(data)

  	if @current_user.nil?
  		puts "----------------> nunca debio existir..."
  		return;
  	end
  	puts "--------->se conecto ...? nm= "+data['id'].to_s
	notificarCambio(data['id'].to_s, true)

  end

  def away
  	if @current_user.nil?
  		puts "----------------> nunca debio existir..."
  		return;
  	end

  	puts "------------------>se desconecto ... "+@nombre
	notificarCambio(data['id'].to_s, false)
	
  end

  private
  	def notificarCambio(id, activo)  		
		EnLineaChannel.broadcast_to("online", nuevo: @current_user, id_usuario: id, activo: activo)
  	end
end
