# frozen_string_literal: true

class EnLineaChannel < ApplicationCable::Channel
  def get_subs
    connections_array = []

    connection.server.connections.each do |conn|
      conn_hash = {}

      conn_hash[:current_user] = conn.current_user
      # conn_hash[:subscriptions_identifiers] = conn.subscriptions.identifiers.map {|k| JSON.parse k}

      connections_array << conn_hash

      # puts "--------------> CONEXION"
      # p conn
      # puts "##"
    end

    # ide_receiver = id[]
    EnLineaChannel.broadcast_to('online', enLinea: connections_array, action: 'get')
  end

  def subscribed
    puts "Se Suscribio... #{current_user}"

    puts 'Subscriptores ..........'

    puts '-----'
    # p ActionCable.server.remote_connections().where()
    puts '----------------->Subscriptores'
    stream_for 'online'
  end

  def self.progress_of(id); end

  def unsubscribed
    puts "Se desuscribio(desconecto)... #{current_user}"
    puts "-----------------> SE DE SUBSCRIBIO ? #{current_user.nombre}"
    notificarCambio(false)
  end

  def appear(data)
    puts "--------->se conecto ...? id?= #{data['id']}"
    puts "--------->id current user es ...id?= #{current_user.id}"

    notificarCambio(true)
  end

  def away
    puts "--------->se desconecto ...? id?= #{data['id']}"
    puts "--------->id current user es ...id?= #{current_user.id}"
    notificarCambio(false)
  end

  private

  def notificarCambio(activo)
    EnLineaChannel.broadcast_to('online', nuevo: current_user, id_usuario: current_user.id, activo:,
                                          action: 'update')
  end
end
