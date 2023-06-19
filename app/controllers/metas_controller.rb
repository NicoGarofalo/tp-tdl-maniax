# frozen_string_literal: true

class MetasController < ApplicationController
  def new
    @meta = Meta.new
    @idProyecto = params[:proyecto_id] # Asignar el valor de proyecto_id a @idProyecto
  end

  def add
    @id_proyecto = meta_new_params
  end

  def create
    @usuario = current_user
    puts meta_params
    @meta = Meta.new(meta_params)
    @meta.estado = 'Pendiente' # Establecer el estado como "Pendiente"

    if @meta.save
      flash[:notice] = 'Meta creada exitosamente.'
      puts 'Meta guardada exitosamente'
      flash[:notice] = "Meta creada exitosamente."
      create_log_entry(@meta) # Llamada a la función create_log_entry para registrar la creación de la meta en el registro de logs
      create_notifications(@meta) # Llamada a la función create_notifications para crear notificaciones relacionadas con la creación de la meta
      schedule_email_notifications(@meta) # Llamada a la función schedule_email_notifications para programar notificaciones por correo relacionadas con la fecha de vencimiento de la meta

      # Enviar correos electrónicos de creación al gerente y al líder
      send_meta_created_emails(@meta)

      redirect_to proyecto_view_path(id: @meta.proyecto_id)
    else
      flash[:notice] = 'Meta fallo en creacion.'
      puts 'Meta fallo al guardarse'
    end
    redirect_to proyecto_view_path(meta_params.proyecto_id)
  end

  def show
    @meta = Meta.find(params[:id])
    @tareas = @meta.tareas
    @proyecto = @meta.proyecto
    @idUsuario = current_user.id

    if @tareas.nil? || @tareas.empty?
      flash.now[:notice] = "Sin tareas"
    end
  end

  private

  def current_user
    return unless session[:usuario_id]

    Usuario.find_by(id: session[:usuario_id])
  end

  def meta_show_params
    params.require(:id)
  end

  def meta_params
    params.require(:meta).permit(:proyecto_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end

  def create_log_entry(meta)
    log = Log.create(
      tipo_log: "Creación de Meta",
      subject_id: meta.id.to_s,
      mensaje: "#{current_user.nombre} creó la meta #{meta.nombre} para el proyecto #{Proyecto.find(meta.proyecto_id).nombre}",
      obligatorio_id: meta.proyecto.gerente_id,
      opcional_id: meta.proyecto.lider_id
    )
  end

  def create_notifications(meta)
    gerente_notification = Notificacion.create(
      usuario_id: meta.proyecto.gerente_id,
      notificacion_tipo: "Meta Creada",
      mensaje: "Has creado la meta #{meta.nombre} para el proyecto #{meta.proyecto.nombre}",
      fecha_hora: Time.now
    )

    lider_notification = Notificacion.create(
      usuario_id: meta.proyecto.lider_id,
      notificacion_tipo: "Meta Asignada",
      mensaje: "Has sido asignado como líder de la meta #{meta.nombre} para el proyecto #{meta.proyecto.nombre}",
      fecha_hora: Time.now
    )
  end

  def schedule_email_notifications(meta)
    vencimiento_date = meta.fecha_vencimiento.to_date

    # Notificar al gerente una semana antes del vencimiento
    una_semana_antes = vencimiento_date - 1.week
    enviar_notificacion_por_correo(una_semana_antes, meta.proyecto.gerente_id, meta)

    # Notificar al gerente el día del vencimiento
    enviar_notificacion_por_correo(vencimiento_date, meta.proyecto.gerente_id, meta)

    # Notificar al líder una semana antes del vencimiento
    enviar_notificacion_por_correo(una_semana_antes, meta.proyecto.lider_id, meta)

    # Notificar al líder el día del vencimiento
    enviar_notificacion_por_correo(vencimiento_date, meta.proyecto.lider_id, meta)
  end

  def enviar_notificacion_por_correo(fecha, usuario_id, meta)
    if fecha == Date.today
      usuario = Usuario.find(usuario_id)
      UserMailer.meta_due_today_email(usuario, meta).deliver_now
    elsif fecha == 1.week.from_now.to_date
      usuario = Usuario.find(usuario_id)
      UserMailer.meta_due_soon_email(usuario, meta).deliver_now
    end
  end

  def send_meta_created_emails(meta)
    gerente = Usuario.find(meta.proyecto.gerente_id)
    lider = Usuario.find(meta.proyecto.lider_id)

    UserMailer.meta_created_email(gerente, meta).deliver_now
    UserMailer.meta_created_email(lider, meta).deliver_now
  end

  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end
end