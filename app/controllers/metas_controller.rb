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
    @meta.chequear_fecha_vencimiento

    if @meta.save
      @meta.proyecto.chequear_fecha_vencimiento
      flash[:notice] = 'Meta creada exitosamente.'
      puts 'Meta guardada exitosamente'

      proyecto = Proyecto.find(@meta.proyecto_id)
      proyecto.chequear_fecha_vencimiento
      proyecto.save

      create_log_entry(@meta) # Llamada a la función create_log_entry para registrar la creación de la meta en el registro de logs
      create_notifications(@meta) # Llamada a la función create_notifications para crear notificaciones relacionadas con la creación de la meta
      send_meta_created_emails(@meta) # Enviar correos electrónicos de creación al gerente y al líder

      redirect_to proyecto_show_path(id: @meta.proyecto_id)
    else
      flash[:notice] = 'Meta fallo en creacion.'
      puts 'Meta fallo al guardarse'
    end
  end

  def show
    @meta = Meta.find(params[:id])
    @tareas = @meta.tareas
    @proyecto = @meta.proyecto
    @idUsuario = current_user.id
    @usuario = current_user
    @lider_id = @meta.proyecto.lider.id
    @gerente_id = @meta.proyecto.gerente.id

    return unless @tareas.nil? || @tareas.empty?

    flash.now[:notice] = 'Sin tareas'
  end

  def finalizar
    @meta = Meta.find(params[:id])
    @meta.finalizar
    @meta.save

    # Enviar correo electrónico al gerente
    UserMailer.meta_finalizada_email(@meta.proyecto.gerente, @meta).deliver_now

    # Enviar correo electrónico al líder
    UserMailer.meta_finalizada_email(@meta.proyecto.lider, @meta).deliver_now

    # Registrar en el log
    Log.create(
      tipo_log: 'Meta Finalizada',
      subject_id: @meta.id.to_s,
      mensaje: 'La meta ha sido marcada como finalizada',
      obligatorio_id: @meta.proyecto.lider_id,
      opcional_id: @meta.proyecto.gerente_id
    )

    # Verificar si quedan metas pendientes en el proyecto
    proyecto = @meta.proyecto
    if proyecto.finalizo?
      proyecto.save
      UserMailer.proyecto_completado_email(proyecto).deliver_now
      Log.create(
        tipo_log: 'Proyecto Completado',
        subject_id: proyecto.id.to_s,
        mensaje: 'El proyecto ha sido marcado como completado',
        obligatorio_id: proyecto.gerente_id,
        opcional_id: proyecto.lider_id
      )
    end
    redirect_to user_home_path
  end

  def enviar_notificacion_por_correo
    Meta.find_each do |meta|
      # fecha = meta.fecha_vencimiento.to_date
      lider = meta.proyecto.lider
      unless meta.finalizado?
        if meta.vence_hoy?
          puts "Enviando correo de que vence hoy a #{lider.nombre} para la meta #{meta.nombre}"
          UserMailer.meta_vence_hoy_email(lider, meta).deliver_now
        end
        if meta.vence_en_una_semana?
          puts "Enviando correo de que vence en una semana a #{lider.nombre} para la meta #{meta.nombre}"
          UserMailer.meta_vence_pronto_email(lider, meta).deliver_now
        end
        if meta.vencio?
          meta.save
          puts "Enviando correo de que venció a #{lider.nombre} para la meta #{meta.nombre}"
          UserMailer.meta_vencio_email(lider, meta).deliver_now
          Log.create(
            tipo_log: 'Meta Vencida',
            subject_id: meta.id.to_s,
            mensaje: 'La meta se ha pasado de la fecha de vencimiento.',
            obligatorio_id: lider.id,
            opcional_id: meta.proyecto.gerente_id
          )
        end
      end
    end
  end

  def delete(meta = nil)
    @meta = if meta.nil?
              Meta.find(params[:id])
            else
              meta
            end
    Tarea.where(meta_id: @meta.id).find_each do |tarea|
      TareasController.new.delete(tarea)
    end
    if @meta.update(borrado: true)
      proyecto = @meta.proyecto
      metas = proyecto.metas
      metas_filtradas = metas.select { |meta| meta.estado != 'Finalizado' && !meta.borrado }
      proyecto.estado = if metas_filtradas.empty?
                          'Completado'
                        else
                          'Pendiente'
                        end
      proyecto.save
    end
    return unless meta.nil?

    flash[:notice] = 'Meta eliminada exitosamente'
    redirect_to proyecto_show_path(id: proyecto.id)
  end

  private

  def meta_show_params
    params.require(:id)
  end

  def meta_params
    params.require(:meta).permit(:proyecto_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end

  def create_log_entry(meta)
    Log.create(
      tipo_log: 'Creación de Meta',
      subject_id: meta.id.to_s,
      mensaje: "#{current_user.nombre} creó la meta #{meta.nombre} para el proyecto #{Proyecto.find(meta.proyecto_id).nombre}",
      obligatorio_id: meta.proyecto.gerente_id,
      opcional_id: meta.proyecto.lider_id
    )
  end

  def create_notifications(meta)
    Notificacion.create(
      usuario_id: meta.proyecto.gerente_id,
      notificacion_tipo: 'Meta Creada',
      mensaje: "Has creado la meta #{meta.nombre} para el proyecto #{meta.proyecto.nombre}",
      fecha_hora: Time.now
    )

    Notificacion.create(
      usuario_id: meta.proyecto.lider_id,
      notificacion_tipo: 'Meta Asignada',
      mensaje: "Has sido asignado como líder de la meta #{meta.nombre} para el proyecto #{meta.proyecto.nombre}",
      fecha_hora: Time.now
    )
  end

  def send_meta_created_emails(meta)
    gerente = Usuario.find(meta.proyecto.gerente_id)
    lider = Usuario.find(meta.proyecto.lider_id)
    UserMailer.meta_created_email(gerente, meta).deliver_now
    UserMailer.meta_created_email_lider(lider, meta).deliver_now
  end
end
