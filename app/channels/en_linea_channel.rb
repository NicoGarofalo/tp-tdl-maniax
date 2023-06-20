class EnLineaChannel < ApplicationCable::Channel
  def subscribed

  	if(@nombre.nil?)
	  	@nombre = "Misaka"
	end

	current_user = Usuario.find_by(params[:id]);

    puts "-----------------> SE SUBSCRIBIO ? "+@nombre
    puts "USUARIO ES Y FUE "
    puts current_user
    puts "----------------------------"
    #current_user.appear
  end

  def unsubscribed
  	puts "-----------------> SE DE SUBSCRIBIO ? "+@nombre
    #current_user.disappear
  end

  def appear(data)
  	#ActionCable.server.broadcast("chat_#{params[:room]}", data)


  	if(!@nombre.nil?)
	  	puts "YA APARECIDO? "+@nombre
	end

  	puts data
  	@nombre = data['nm']
  	puts "--------->se conecto ... "+@nombre
    #current_user.appear(on: data['appearing_on'])
  	EnLineaChannel.broadcast_to("all", nuevo: @nombre, activo: true)

  end

  def away
  	puts "------------------>se desconecto ... "+@nombre
    #current_user.away
  end

end
