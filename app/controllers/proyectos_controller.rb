# frozen_string_literal: true

class ProyectosController < ApplicationController
  include Pundit
  layout 'layout_base_nav'

  def new
    @usuario = current_user
    puts 'user act es'
    p @usuario
    redirect_to '/home' unless @usuario.esGerente

    @proyecto = Proyecto.new
    @lideres = Usuario.where(usuario_tipo: 'Líder')
  end

  def create
    @proyecto = Proyecto.new(proyecto_params)
    @proyecto.cargar_gerente(session[:usuario_id])
    @proyecto.chequear_fecha_vencimiento

    authorize @proyecto

    if @proyecto.save
      @usuario = Usuario.find_by(id: session[:usuario_id])
      UserMailer.project_created_email(@usuario, @proyecto).deliver_now

      # Obtener al líder del proyecto
      @lider = Usuario.find(@proyecto.lider_id)
      UserMailer.project_assigned_email(@lider, @proyecto).deliver_now

      create_log_entry(@proyecto) # Crear entrada en la tabla "logs"
      create_notifications(@proyecto) # Crear notificaciones

      flash[:notice] = 'Proyecto creado exitosamente'
      redirect_to controller: 'proyectos', action: 'show', id: @proyecto.id
    else
      flash[:error] = @proyecto.errors.full_messages
      @lideres = Usuario.where(usuario_tipo: 'Líder')
      @usuario = current_user
      redirect_to controller: 'proyectos', action: 'new'
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

  def show
    @proyecto = Proyecto.find_by(id: params[:id])
    @nombreGerente = Usuario.find_by(id: @proyecto.gerente_id)&.nombre
    @nombreLider = Usuario.find_by(id: @proyecto.lider_id)&.nombre
    @usuario = current_user
    @idProyecto = @proyecto.id
    @metas = Meta.where(proyecto_id: @idProyecto).map { |m| params_meta(m) }
  end

  def finalizar
    @proyecto = Proyecto.find(params[:id])
    @proyecto.estado = 'Finalizado'
    @proyecto.save

    # Enviar correo electrónico al gerente
    UserMailer.proyecto_finalizado_email(@proyecto.gerente, @proyecto).deliver_now

    # Enviar correo electrónico al líder
    UserMailer.proyecto_finalizado_email(@proyecto.lider, @proyecto).deliver_now

    # Registrar en el log
    Log.create(
      tipo_log: 'Proyecto Finalizado',
      subject_id: @proyecto.id.to_s,
      mensaje: 'El proyecto ha sido marcado como finalizado',
      obligatorio_id: @proyecto.gerente_id,
      opcional_id: @proyecto.lider_id
    )
    redirect_to user_home_path
  end

  def enviar_notificacion_por_correo
    Proyecto.find_each do |proyecto|
      fecha = proyecto.fecha_vencimiento.to_date
      gerente = proyecto.gerente
      if proyecto.estado != 'Finalizado'
        if fecha == Date.today
          puts "Enviando correo de que vence hoy a #{gerente.nombre} para el proyecto #{proyecto.nombre}"
          UserMailer.project_due_today_email(gerente, proyecto).deliver_now
        end
        if fecha == 1.week.from_now.to_date
          puts "Enviando correo de que vence en una semana a #{gerente.nombre} para el proyecto #{proyecto.nombre}"
          UserMailer.project_due_soon_email(gerente, proyecto).deliver_now
        end
        if fecha < Date.today && proyecto.estado == 'Ṕendiente'
          proyecto.estado = 'Vencido'
          proyecto.save
          puts "Enviando correo de que el proyecto venció a #{gerente.nombre} para el proyecto #{proyecto.nombre}"
          UserMailer.project_overdue_email(gerente, proyecto).deliver_now
          Log.create(
            tipo_log: 'Proyecto Vencido',
            subject_id: proyecto.id.to_s,
            mensaje: 'El proyecto se ha pasado de la fecha de vencimiento.',
            obligatorio_id: gerente.id,
            opcional_id: proyecto.lider_id
          )
        end
      end
    end
  end

  def delete
    @proyecto = Proyecto.find(params[:id])
    authorize @proyecto
    Meta.where(proyecto_id: @proyecto.id).find_each do |meta|
      MetasController.new.delete(meta)
    end
    @proyecto.update(borrado: true)
    flash[:notice] = 'Proyecto eliminado exitosamente'
    redirect_to user_home_path
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
end
