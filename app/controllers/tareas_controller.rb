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
    @tarea.estado = if @tarea.fecha_vencimiento < Date.today
                      'Vencido'
                    else
                      'Pendiente'
                    end

    if @tarea.save
      puts 'exitosamente creada la tarea'
      flash[:notice] = 'Tarea creada exitosamente.'

      # Actualizar el estado de la meta a 'Pendiente'
      meta = Meta.find(@tarea.meta_id)
      meta.estado = if meta.fecha_vencimiento < Date.today
                      'Vencido'
                    else
                      'Pendiente'
                    end
      meta.save

      create_log_entry(@tarea)
      create_notifications(@tarea)
      send_email_notifications(@tarea)
      redirect_to meta_show_path(id: @tarea.meta_id)
    else
      flash[:notice] = 'Creacion Tarea fallo.'
      puts @tarea.errors.full_messages
    end
  end

  def show
    @tarea = Tarea.find(params[:id])
  end

  def completar
    @tarea = Tarea.find(params[:id])
    @tarea.estado = 'Completado'
    @tarea.save
    UserMailer.tarea_completada_integrante_email(@tarea).deliver_now
    UserMailer.tarea_completada_revisor_email(@tarea).deliver_now
    Log.create(
      tipo_log: 'Tarea Completada',
      subject_id: @tarea.id.to_s,
      mensaje: 'La tarea ha sido marcada como completada',
      obligatorio_id: @tarea.integrante_id,
      opcional_id: @tarea.revisor_id
    )
    redirect_to user_home_path
  end

  def finalizar
    @tarea = Tarea.find(params[:id])
    @tarea.estado = 'Finalizado'
    @tarea.save
    UserMailer.tarea_finalizada_email(@tarea.meta.proyecto.lider, @tarea).deliver_now
    UserMailer.tarea_finalizada_email(@tarea.revisor, @tarea).deliver_now
    UserMailer.tarea_finalizada_email(@tarea.integrante, @tarea).deliver_now
    Log.create(
      tipo_log: 'Tarea Finalizada',
      subject_id: @tarea.id.to_s,
      mensaje: 'La tarea ha sido marcada como finalizada',
      obligatorio_id: @tarea.revisor_id,
      opcional_id: @tarea.integrante_id
    )
    meta = @tarea.meta
    if meta.tareas.pendientes.empty?
      meta.estado = 'Completado'
      meta.save
      UserMailer.meta_completada_email(meta).deliver_now
      usuario_finalizador = @tarea.integrante
      Log.create(
        tipo_log: 'Meta Completada',
        subject_id: meta.id.to_s,
        mensaje: 'La meta ha sido marcada como completada',
        obligatorio_id: meta.proyecto.lider_id,
        opcional_id: usuario_finalizador.id
      )
    end
    redirect_to user_home_path
  end

  def pendiente
    @tarea = Tarea.find(params[:id])
    @tarea.estado = if @tarea.fecha_vencimiento < Date.today
                      'Vencido'
                    else
                      'Pendiente'
                    end
    @tarea.save
    UserMailer.tarea_devuelta_pendiente_revisor_email(@tarea).deliver_now
    UserMailer.tarea_devuelta_pendiente_integrante_email(@tarea).deliver_now
    Log.create(
      tipo_log: "Tarea Devuelta a #{@tarea.estado}",
      subject_id: @tarea.id.to_s,
      mensaje: "La tarea #{@tarea} ha sido devuelta a estado #{@tarea.estado}",
      obligatorio_id: @tarea.revisor_id,
      opcional_id: @tarea.integrante_id
    )
    redirect_to user_home_path
  end

  def enviar_notificacion_por_correo
    Tarea.find_each do |tarea|
      fecha = tarea.fecha_vencimiento.to_date
      revisor = tarea.revisor
      integrante = tarea.integrante
      if tarea.estado != 'Finalizado'
        if fecha == Date.today
          puts "Enviando correo de que vence hoy a #{revisor.nombre} y a #{integrante.nombre} para la tarea #{tarea.nombre}"
          UserMailer.tarea_vence_hoy_email(revisor, tarea).deliver_now
          UserMailer.tarea_vence_hoy_email(integrante, tarea).deliver_now
        end
        if fecha == 1.week.from_now.to_date
          puts "Enviando correo de que vence en una semana a #{revisor.nombre} y a #{integrante.nombre} para la tarea #{tarea.nombre}"
          UserMailer.tarea_vence_pronto_email(revisor, tarea).deliver_now
          UserMailer.tarea_vence_pronto_email(integrante, tarea).deliver_now
        end
        if fecha < Date.today && tarea.estado == 'Pendiente'
          tarea.estado = 'Vencido'
          tarea.save
          puts "Enviando correo de que venció a #{revisor.nombre} y a #{integrante.nombre} para la tarea #{tarea.nombre}"
          UserMailer.tarea_vencio_email(revisor, tarea).deliver_now
          UserMailer.tarea_vencio_email(integrante, tarea).deliver_now
          Log.create(
            tipo_log: 'Tarea Vencida',
            subject_id: tarea.id.to_s,
            mensaje: 'La tarea se ha pasado de la fecha de vencimiento.',
            obligatorio_id: integrante.id,
            opcional_id: revisor.id
          )
        end
      end
    end
  end

  private

  def tarea_new_params
    params.require(:meta_id)
  end

  def tarea_params
    params.require(:tarea).permit(:meta_id, :revisor_id, :integrante_id, :fecha_vencimiento, :nombre, :descripcion,
                                  :estado)
  end

  def create_log_entry(tarea)
    Log.create(
      tipo_log: 'Creación de Tarea',
      subject_id: tarea.id.to_s,
      mensaje: "#{current_user.nombre} creó la tarea #{tarea.nombre} para la meta #{Meta.find(tarea.meta_id).nombre}",
      obligatorio_id: tarea.meta.proyecto.lider_id,
      opcional_id: tarea.revisor_id
    )
  end

  def create_notifications(tarea)
    Notificacion.create(
      usuario_id: tarea.meta.proyecto.lider_id,
      notificacion_tipo: 'Tarea Asignada',
      mensaje: "Has creado la tarea #{tarea.nombre} para la meta #{tarea.meta.nombre} del proyecto #{tarea.meta.proyecto.nombre}",
      fecha_hora: Time.now
    )
    Notificacion.create(
      usuario_id: tarea.revisor_id,
      notificacion_tipo: 'Tarea Asignada',
      mensaje: "Has sido asignado como revisor de la tarea #{tarea.nombre} para la meta #{tarea.meta.nombre} del proyecto #{tarea.meta.proyecto.nombre}",
      fecha_hora: Time.now
    )

    Notificacion.create(
      usuario_id: tarea.integrante_id,
      notificacion_tipo: 'Tarea Asignada',
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

end
