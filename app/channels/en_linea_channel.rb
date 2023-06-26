# frozen_string_literal: true

class EnLineaChannel < ApplicationCable::Channel

  def initialize(connection, identifier, params = {})
    super(connection,identifier,params)

    # puts "IDENTIFIER INITED WITH WAS "
    # p identifier
    # puts "-------"
    # p params
    # puts "-------"
    # p connection
    # puts "--------------------------------------------"
  end

  def self.conexiones
    connections_array = []

    variable = EnLineaChannel new

    variable.connection.server.connections.each do |conn|
      conn_hash = {}

      conn_hash[:current_user] = conn.current_user
      # conn_hash[:subscriptions_identifiers] = conn.subscriptions.identifiers.map {|k| JSON.parse k}

      connections_array << conn_hash

      # puts "--------------> CONEXION"
      # p conn
      # puts "##"
    end

    connections_array
  end
  def get_subs
    connections_array = {}

    connection.server.connections.each do |conn|
      
      if connections_array.key?(conn.current_user.id)
        puts "-----------------> ya existia key??"
        p conn.current_user
        puts "------------------------------------"
      else # solo agregas una vez
        puts "------------> Agegando activo?... "
        connections_array[conn.current_user.id.to_s] = conn.current_user
      end
    end
    puts "----------> Final activos ========"
    p connections_array
    puts "-------------------"

    # ide_receiver = id[]
    EnLineaChannel.broadcast_to(current_user, enLinea: connections_array, action: 'get')
  end

  def subscribed
    

    # puts "Se Suscribio... #{current_user}"

    # puts '--------------------------------CONECCTIONS ..........'

    # puts '-----'
    connections_array = []
    #  conn_hash = {}

    #  conn_hash[:current_user] = conn.current_user.nombre
      # conn_hash[:subscriptions_identifiers] = conn.subscriptions.identifiers.map {|k| JSON.parse k}

    #  connections_array << conn_hash

      # puts "--------------> CONEXION"
      # p conn
      # puts "##"
    #end
    #p connections_array
    # puts '------------------------------>Subscriptores'
    stream_for 'online'
    stream_for current_user
  end

  def self.progress_of(id); end

  def unsubscribed
    #puts "Se desuscribio(desconecto)... #{current_user}"
    #puts "-----------------> SE DE SUBSCRIBIO ? #{current_user.nombre}"
    notificarCambio(false)
  end

  def appear(data)
    #puts "--------->se conecto ...? id?= #{data['id']}"
    #puts "--------->id current user es ...id?= #{current_user.id}"

    notificarCambio(true)
  end

  def away
    #puts "--------->se desconecto ...? id?= #{data['id']}"
    #puts "--------->id current user es ...id?= #{current_user.id}"
    notificarCambio(false)
  end

  private

  def notificarCambio(activo)
    EnLineaChannel.broadcast_to('online', nuevo: current_user, id_usuario: current_user.id, activo: activo,
                                          action: 'update')
  end
end
