# frozen_string_literal: true

class UsuariosController < ApplicationController
  layout 'layout_base_nav'

  def new
    @usuario = Usuario.new

    render 'usuarios/new', layout: 'layouts/layout_general'
  end

  def create
    @usuario = Usuario.new(usuario_params)
    if @usuario.save
      UserMailer.welcome_email(@usuario).deliver_now
      redirect_to iniciar_sesion_path, notice: '¡Registro exitoso! Inicia sesión con tu cuenta.'
    else
      puts @usuario.errors.full_messages
      render :new
    end
  end

  def gerente_home
    @proyectos = Proyecto.where(gerente_id: @usuario.id)
    render :gerente_home
  end

  def user_list
    @usuarios = Usuario.all
    @usuario = current_user
  end

  def lider_home
    @proyectos = Proyecto.where(lider_id: @usuario.id)
    render :lider_home
  end

  def revisor_integrante_home
    @tareas = if @usuario.usuario_tipo == 'Revisor'
                Tarea.where(revisor_id: @usuario.id)
              else
                Tarea.where(integrante_id: @usuario.id)
              end
    render :revisor_integrante_home
  end

  def stats_proyecto(id)
    stats = {}

    stats[:progress] = Proyecto.progress_of id
    stats[:countMembers] = Proyecto.member_count id

    stats
  end

  def params_proyecto(proyecto)
    param = {}

    param[:stats] = stats_proyecto proyecto.id
    param[:proyecto] = proyecto
    param[:nombre_lider] = proyecto.lider.nombre

    param
  end

  def gerente_lider_home
    proyectosList = if @usuario.usuario_tipo == 'Gerente'
                      Proyecto.where(gerente_id: @usuario.id)

                    else
                      Proyecto.where(lider_id: @usuario.id)
                    end

    @proyectos = proyectosList.map { |p| params_proyecto p }
    render :gerente_lider_home
  end

  def home
    @usuario = current_user
    if @usuario.usuario_tipo == 'Gerente' || @usuario.usuario_tipo == 'Líder'
      gerente_lider_home
    elsif @usuario.usuario_tipo == 'Revisor' || @usuario.usuario_tipo == 'Integrante'
      revisor_integrante_home
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:usuario_tipo, :nombre, :apellido, :email, :password, :password_confirmation)
  end

  def current_user
    return unless session[:usuario_id]

    Usuario.find_by(id: session[:usuario_id])
  end
end