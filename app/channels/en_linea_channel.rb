# frozen_string_literal: true

class EnLineaChannel < ApplicationCable::Channel

  def initialize(connection, identifier, params = {})
    super(connection,identifier,params)
  end

  def conexiones
    connections_array = []

    connection.server.connections.each do |conn|
      conn_hash = {}

      conn_hash[:current_user] = conn.current_user
      connections_array << conn_hash
    end

    connections_array
  end
  def get_subs


    #Thread.new do

    #end
    connections_array = {}

    connection.server.connections.each do |conn|
      
      if connections_array.key?(conn.current_user.id)
        puts "-----------------> ya existia key?? #{conn.current_user}"
      else # solo agregas una vez
        connections_array[conn.current_user.id.to_s] = conn.current_user
      end
    end

    EnLineaChannel.broadcast_to(current_user, enLinea: connections_array, action: 'get')
  end

  def subscribed
    puts "------------> #{current_user.nombre} subscribed , #{connection.server.connections.length()} conns"
    stream_for 'online'
    stream_for current_user

  end

  def unsubscribed
    puts "------------> #{current_user.nombre} unsubscribed , #{connection.server.connections.length()} left"
    notificarCambio(false)
  end

  def appear(data)
    notificarCambio(true)
  end

  def away
    notificarCambio(false)
  end

  private

  def notificarCambio(activo)

    EnLineaChannel.broadcast_to('online', nuevo: current_user, id_usuario: current_user.id, activo: activo,
                                          action: 'update')
  end
end
