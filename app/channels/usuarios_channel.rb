# frozen_string_literal: true

class UsuariosChannel < ApplicationCable::Channel


  def render_usuario_item(usuario,policy)

    UsuariosController.render(
      partial: "usuarios/item_usuario",
      locals: {item_usuario: usuario, policyUser: policy});
  end

  def get_usuarios
    # cargar usuarios
    usuarios = Usuario.all
    UsuariosChannel.broadcast_to(current_user, count: usuarios.count, action:"get_start")

    policy = UsuariosPolicy.new(current_user,current_user)
    Thread.new do 
    usuarios.each do |usuario|
      Thread.new do
        UsuariosChannel.broadcast_to(current_user,id_usuario: usuario.id,
          view_usuario: render_usuario_item(usuario, policy), action:"get")        
      end
      sleep(1)
    end    
  end


  end

  def subscribed
    puts "------------> #{current_user.nombre} subscribed to usuarios, #{connection.server.connections.length()} conns"
    stream_for current_user
  end

  def unsubscribed
    puts "------------> #{current_user.nombre} unsubscribed from usuarios, #{connection.server.connections.length()} left"
  end
end
