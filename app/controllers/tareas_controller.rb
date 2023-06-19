# frozen_string_literal: true

class TareasController < ApplicationController
  def new
    @idUsuario = session[:usuario_id]
    @idMeta = tarea_new_params
    @tarea = Tarea.new
    @meta_id = params[:meta_id]
  end

  def add
    @idUsuario = session[:usuario_id]
    @idMeta = tarea_new_params
    @meta_id = params[:meta_id] # Asignar el valor de params[:meta_id] a @meta_id
    puts "meta_id: #{@meta_id}" # o logger.debug("meta_id: #{@meta_id}")
  end

  def create
    @tarea = Tarea.new(tarea_params)
    @tarea.estado = 'Pendiente'

    if @tarea.save
      puts 'exitosamente creada la tarea'
      flash[:notice] = 'Tarea creada exitosamente.'
      # redirect_to success_path
      create_log_entry(@tarea) # Llamada a la función create_log_entry para registrar la creación de la tarea en el registro de logs"
      create_notifications(@tarea) # Llamada a la función create_notifications para crear notificaciones relacionadas con la creación de la tarea
      send_email_notifications(@tarea) # Llamada a la función send_email_notifications para enviar notificaciones por correo relacionadas con la tarea
      redirect_to meta_show_path(id: @tarea.meta_id)
    else
      flash[:notice] = 'Creacion Tarea fallo.'
      puts @tarea.errors.full_messages # Imprimir los errores en la consola
      # render :new
    end
  end

  def show
    @tarea = Tarea.find(params[:id])
  end

  private

  def tarea_new_params
    params.require(:meta_id)
  end

  def tarea_params
    params.require(:tarea).permit(:meta_id, :revisor_id, :integrante_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end

  def create_log_entry(tarea)
    log = Log.create(
      tipo_log: "Creación de Tarea",
      subject_id: tarea.id.to_s,
      mensaje: "#{current_user.nombre} creó la tarea #{tarea.nombre} para la meta #{Meta.find(tarea.meta_id).nombre}",
      obligatorio_id: tarea.meta.proyecto.lider_id,
      opcional_id: tarea.revisor_id
    )
  end

  def create_notifications(tarea)
    lider_notification = Notificacion.create(
      usuario_id: tarea.meta.proyecto.lider_id,
      notificacion_tipo: "Tarea Asignada",
      mensaje: "Has creado la tarea #{tarea.nombre} para la meta #{tarea.meta.nombre} del proyecto #{tarea.meta.proyecto.nombre}",
      fecha_hora: Time.now
    )

    revisor_notification = Notificacion.create(
      usuario_id: tarea.revisor_id,
      notificacion_tipo: "Tarea Asignada",
      mensaje: "Has sido asignado como revisor de la tarea #{tarea.nombre} para la meta #{tarea.meta.nombre} del proyecto #{tarea.meta.proyecto.nombre}",
      fecha_hora: Time.now
    )

    integrante_notification = Notificacion.create(
      usuario_id: tarea.integrante_id,
      notificacion_tipo: "Tarea Asignada",
      mensaje: "Has sido asignado como integrante de la tarea #{tarea.nombre} para la meta #{tarea.meta.nombre} del proyecto #{tarea.meta.proyecto.nombre}",
      fecha_hora: Time.now
    )
  end

  def send_email_notifications(tarea)
    proyecto = tarea.meta.proyecto
    lider = proyecto.lider
    revisor = Usuario.find(tarea.revisor_id)
    integrante = Usuario.find(tarea.integrante_id)

    UserMailer.tarea_created_email_lider(lider, tarea).deliver_now
    UserMailer.tarea_created_email_revisor(revisor, tarea).deliver_now
    UserMailer.tarea_created_email_integrante(integrante, tarea).deliver_now
  end


  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end
end