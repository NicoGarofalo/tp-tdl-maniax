# frozen_string_literal: true

class ProyectosController < ApplicationController
  include Pundit

  def new
    @usuario = current_user
    redirect_to '/home' unless @usuario.esGerente

    @proyecto = Proyecto.new

    @lideres = Usuario.where(usuario_tipo: 'Líder')
  end

  def create
    @proyecto = Proyecto.new(proyecto_params)
    @proyecto.gerente_id = session[:usuario_id]
    @proyecto.estado = 'Pendiente'
    authorize @proyecto

    if @proyecto.save
      @usuario = Usuario.find_by(id: session[:usuario_id])
      UserMailer.project_created_email(@usuario, @proyecto).deliver_now

      # Obtener al líder del proyecto
      @lider = Usuario.find(@proyecto.lider_id)
      UserMailer.project_assigned_email(@lider, @proyecto).deliver_now

      create_log_entry(@proyecto) # Crear entrada en la tabla "logs"
      create_notifications(@proyecto) # Crear notificaciones

      schedule_email_notifications(@proyecto) # Programar notificaciones por correo electrónico

      flash[:notice] = 'Proyecto creado exitosamente'
      redirect_to controller: 'proyectos', action: 'view', id: @proyecto.id
    else
      flash[:notice] = 'creacion proyecto fallo'
      render :new
    end
  end

  def stats_meta(id)
    stats = {}

    stats[:progress] = Meta.progress_of id
    stats[:countMembers] = Meta.member_count id

    stats
  end

  def params_meta(meta)
    param = {}

    param[:stats] = stats_meta meta.id
    param[:meta] = meta

    param
  end

  def view
    idProyecto = proyecto_view_id
    @proyecto = Proyecto.find_by(id: idProyecto)
    @usuario  = current_user

    @metas = Meta.where(proyecto_id: idProyecto).map { |m| params_meta m }
  end

  private

  def create_log_entry(proyecto)
    Log.create(
      tipo_log: 'Creación de Proyecto',
      subject_id: proyecto.id.to_s,
      mensaje: "#{current_user.nombre} creó el proyecto #{proyecto.nombre} y asignó a #{Usuario.find(proyecto.lider_id).nombre} como líder",
      obligatorio_id: proyecto.gerente_id,
      opcional_id: proyecto.lider_id
    )
  end

  def create_notifications(proyecto)
    Notificacion.create(
      usuario_id: proyecto.gerente_id,
      notificacion_tipo: 'Proyecto Creado',
      mensaje: "Has creado el proyecto #{proyecto.nombre}",
      fecha_hora: Time.now
    )

    Notificacion.create(
      usuario_id: proyecto.lider_id,
      notificacion_tipo: 'Proyecto Asignado',
      mensaje: "Has sido asignado como líder del proyecto #{proyecto.nombre}",
      fecha_hora: Time.now
    )
  end

  def proyecto_view_id
    params.require(:id)
  end

  def proyecto_params
    params.require(:proyecto).permit(:gerente_id, :lider_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end

  def current_user
    return unless session[:usuario_id]

    Usuario.find_by(id: session[:usuario_id])
  end

  def schedule_email_notifications(proyecto)
    vencimiento_date = proyecto.fecha_vencimiento.to_date

    # Notificar al gerente una semana antes del vencimiento
    una_semana_antes = vencimiento_date - 1.week
    enviar_notificacion_por_correo(una_semana_antes, proyecto.gerente_id, proyecto)

    # Notificar al gerente el día del vencimiento
    enviar_notificacion_por_correo(vencimiento_date, proyecto.gerente_id, proyecto)

    # Notificar al líder una semana antes del vencimiento
    enviar_notificacion_por_correo(una_semana_antes, proyecto.lider_id, proyecto)

    # Notificar al líder el día del vencimiento
    enviar_notificacion_por_correo(vencimiento_date, proyecto.lider_id, proyecto)
  end

  def enviar_notificacion_por_correo(fecha, usuario_id, proyecto)
    if fecha == Date.today
      usuario = Usuario.find(usuario_id)
      UserMailer.project_due_today_email(usuario, proyecto).deliver_now
    elsif fecha == 1.week.from_now.to_date
      usuario = Usuario.find(usuario_id)
      UserMailer.project_due_soon_email(usuario, proyecto).deliver_now
    end
  end

  def schedule_email_notifications(proyecto)
    vencimiento_date = proyecto.fecha_vencimiento.to_date

    # Notificar al gerente una semana antes del vencimiento
    una_semana_antes = vencimiento_date - 1.week
    enviar_notificacion_por_correo(una_semana_antes, proyecto.gerente_id, proyecto)

    # Notificar al gerente el día del vencimiento
    enviar_notificacion_por_correo(vencimiento_date, proyecto.gerente_id, proyecto)

    # Notificar al líder una semana antes del vencimiento
    enviar_notificacion_por_correo(una_semana_antes, proyecto.lider_id, proyecto)

    # Notificar al líder el día del vencimiento
    enviar_notificacion_por_correo(vencimiento_date, proyecto.lider_id, proyecto)
  end

  def enviar_notificacion_por_correo(fecha, usuario_id, proyecto)
    if fecha == Date.today
      usuario = Usuario.find(usuario_id)
      UserMailer.project_due_today_email(usuario, proyecto).deliver_now
    elsif fecha == 1.week.from_now.to_date
      usuario = Usuario.find(usuario_id)
      UserMailer.project_due_soon_email(usuario, proyecto).deliver_now
    end
  end
end
