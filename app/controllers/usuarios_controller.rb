class UsuariosController < ApplicationController
  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save
      UserMailer.welcome_email(@usuario).deliver_now
      redirect_to iniciar_sesion_path, notice: "¡Registro exitoso! Inicia sesión con tu cuenta."
    else
      puts @usuario.errors.full_messages
      render :new
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:usuario_tipo, :nombre, :apellido, :email, :password, :password_confirmation)
  end
end