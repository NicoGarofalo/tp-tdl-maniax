class UsuariosController < ApplicationController
  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save
      #UserMailer.with(user: @usuario).welcome_email.deliver_now
      redirect_to iniciar_sesion_path, notice: "¡Registro exitoso! Inicia sesión con tu cuenta."
    else
      puts @usuario.errors.full_messages
      render :new
    end
  end

  def gerente_home
    @proyectos = Proyecto.where(gerente_id: @usuario.id)
    render :gerente_home
  end

  def admin
    @usuarios = Usuario.all
  end


  def lider_home
      @proyectos = Proyecto.where(lider_id: @usuario.id)
      render :lider_home
  end  

  def integrante_home
    @tareas = Tarea.where(integrante_id: @usuario.id)
    render :integrante_home
  end

  def home
    @idUsuario = session[:usuario_id]
    @usuario = Usuario.find_by(id: @idUsuario)

    if @usuario.usuario_tipo == 'Gerente'
      gerente_home()
    elsif @usuario.usuario_tipo == 'Líder'
      lider_home()
    elsif @usuario.usuario_tipo == 'Integrante'
      integrante_home()


    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:usuario_tipo, :nombre, :apellido, :email, :password, :password_confirmation)
  end
end