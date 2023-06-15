# frozen_string_literal: true

class SesionesController < ApplicationController
  layout 'layout_general'

  def new
    return if session[:usuario_id].nil?

    puts 'Ya existia una sesion'
    redirect_to user_home_path
  end

  def create
    # byebug
    usuario = Usuario.find_by(email: params[:email])
    if usuario&.authenticate(params[:password])
      # Autenticación exitosa
      session[:usuario_id] = usuario.id
      session[:current_user] = usuario
      flash[:notice] = 'Inicio de sesión exitoso'
      redirect_to user_home_path
      puts 'Inicio de sesión exitoso'
    else
      # Autenticación fallida
      flash[:alert] = 'Email o contraseña inválidos'
      redirect_to iniciar_sesion_path
      puts 'Inicio de sesión fallido'
      puts "Contraseña recibida: #{params[:password_digest]}"
    end
  end

  def destroy
    session[:usuario_id] = nil
    session[:current_user] = nil
    flash[:notice] = 'Sesión cerrada correctamente'
    redirect_to iniciar_sesion_path
    puts 'Sesión cerrada'
  end

  def success
    @usuario = Usuario.find_by(id: session[:usuario_id])
  end
end
