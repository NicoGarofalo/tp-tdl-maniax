# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email(usuario)
    @usuario = usuario
    mail(to: @usuario.email, subject: '¡Bienvenido a nuestro sitio web!')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @usuario.id, notificacion_tipo: 'Bienvenida',
                        mensaje: 'Has recibido un correo de bienvenida', fecha_hora: DateTime.now)
  end

  def project_created_email(gerente, proyecto)
    @gerente = gerente
    @proyecto = proyecto
    mail(to: @gerente.email, subject: 'Proyecto creado exitosamente')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @gerente.id, notificacion_tipo: 'Proyecto Creado',
                        mensaje: 'Has recibido un correo de creación de proyecto', fecha_hora: DateTime.now)
  end

  def project_assigned_email(lider, proyecto)
    @lider = lider
    @proyecto = proyecto
    mail(to: @lider.email, subject: 'Proyecto asignado a ti')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @lider.id, notificacion_tipo: 'Proyecto Asignado',
                        mensaje: 'Has recibido un correo de asignación de proyecto', fecha_hora: DateTime.now)
  end

  def meta_created_email(gerente, meta)
    @gerente = gerente
    @meta = meta
    mail(to: @gerente.email, subject: 'Meta creada exitosamente')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @gerente.id, notificacion_tipo: 'Meta Creada',
                        mensaje: 'Has recibido un correo de creación de meta', fecha_hora: DateTime.now)
  end

  def meta_created_email_lider(lider, meta)
    @lider = lider
    @meta = meta
    mail(to: @lider.email, subject: '¡Se ha creado una nueva meta!')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @lider.id, notificacion_tipo: 'Meta Creada',
                        mensaje: 'Has recibido un correo de creación de meta', fecha_hora: DateTime.now)
  end

  def tarea_created_email_lider(lider, tarea)
    @lider = lider
    @tarea = tarea
    mail(to: @lider.email, subject: 'Tarea creada exitosamente para el líder')

    # Crear notificación para el líder
    Notificacion.create(usuario_id: @lider.id, notificacion_tipo: 'Tarea Creada',
                        mensaje: 'Has recibido un correo de creación de tarea', fecha_hora: DateTime.now)
  end

  def tarea_created_email_revisor(revisor, tarea)
    @revisor = revisor
    @tarea = tarea
    mail(to: @revisor.email, subject: 'Tarea creada exitosamente para el revisor')

    # Crear notificación para el revisor
    Notificacion.create(usuario_id: @revisor.id, notificacion_tipo: 'Tarea Creada',
                        mensaje: 'Has recibido un correo de creación de tarea', fecha_hora: DateTime.now)
  end

  def tarea_created_email_integrante(integrante, tarea)
    @integrante = integrante
    @tarea = tarea
    mail(to: @integrante.email, subject: 'Tarea creada exitosamente para el integrante')

    # Crear notificación para el integrante
    Notificacion.create(usuario_id: @integrante.id, notificacion_tipo: 'Tarea Creada',
                        mensaje: 'Has recibido un correo de creación de tarea', fecha_hora: DateTime.now)
  end

  def project_due_today_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: '¡El proyecto vence hoy!')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Proyecto Vencimiento',
                        mensaje: 'Has recibido un correo de vencimiento de proyecto (hoy)', fecha_hora: DateTime.now)
  end

  def project_due_soon_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: '¡El proyecto vence pronto!')

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Proyecto Vencimiento',
                        mensaje: 'Has recibido un correo de vencimiento próximo de proyecto', fecha_hora: DateTime.now)
  end

  def tarea_completada_integrante_email(tarea)
    @tarea = tarea
    @integrante = tarea.integrante
    mail(to: @integrante.email, subject: 'Tarea completada')

    # Crear notificación para el integrante
    Notificacion.create(
      usuario_id: @integrante.id,
      notificacion_tipo: 'Tarea Completada',
      mensaje: 'La tarea ha sido marcada como completada',
      fecha_hora: DateTime.now
    )
  end

  def tarea_completada_revisor_email(tarea)
    @tarea = tarea
    @revisor = tarea.revisor
    mail(to: @revisor.email, subject: 'Tarea completada por el integrante')

    # Crear notificación para el revisor
    Notificacion.create(
      usuario_id: @tarea.revisor_id,
      notificacion_tipo: 'Tarea Completada',
      mensaje: 'La tarea ha sido marcada como completada por el integrante y está lista para revisión',
      fecha_hora: DateTime.now
    )
  end

  def tarea_finalizada_email(usuario, tarea)
    @usuario = usuario
    @tarea = tarea
    mail(to: @usuario.email, subject: 'Tarea finalizada')

    # Crear notificación
    Notificacion.create(
      usuario_id: @usuario.id,
      notificacion_tipo: "Tarea Finalizada",
      mensaje: "La tarea #{@tarea} ha sido marcada como finalizada",
      fecha_hora: Time.now
    )
  end

  def tarea_devuelta_pendiente_revisor_email(tarea)
    @tarea = tarea
    @revisor = tarea.revisor
    mail(to: @revisor.email, subject: 'Tarea devuelta a pendiente')

    # Crear notificación
    Notificacion.create(
      usuario_id: @tarea.revisor_id,
      notificacion_tipo: "Tarea Devuelta a Pendiente",
      mensaje: "Has devuelto la tarea #{@tarea} a estado Pendiente",
      fecha_hora: Time.now
    )
  end

  def tarea_devuelta_pendiente_integrante_email(tarea)
    @tarea = tarea
    @integrante = tarea.integrante
    mail(to: @integrante.email, subject: 'Tarea devuelta a pendiente')

    # Crear notificación para el integrante
    Notificacion.create(
      usuario_id: @integrante.id,
      notificacion_tipo: 'Tarea Devuelta a Pendiente',
      mensaje: "La tarea #{@tarea} ha sido devuelta a estado Pendiente. Vuelve a realizarla.",
      fecha_hora: DateTime.now
    )
  end

  def meta_completada_email(meta)
    @meta = meta
    @lider = meta.proyecto.lider
    mail(to: @lider.email, subject: '¡Meta completada!')

    # Crear notificación para el líder
    Notificacion.create(
      usuario_id: @lider.id,
      notificacion_tipo: 'Meta Completada',
      mensaje: "La meta #{@meta} ha sido marcada como completada.",
      fecha_hora: DateTime.now
    )
  end

  def meta_finalizada_email(usuario, meta)
    @usuario = usuario
    @meta = meta
    mail(to: @usuario.email, subject: '¡Meta finalizada!')

    # Create a notification for the user
    Notificacion.create(
      usuario_id: @usuario.id,
      notificacion_tipo: 'Meta Finalizada',
      mensaje: 'Has recibido un correo de finalización de meta',
      fecha_hora: DateTime.now
    )
  end

  def proyecto_completado_email(proyecto)
    @proyecto = proyecto
    @gerente = proyecto.gerente
    mail(to: @gerente.email, subject: '¡Proyecto completado!')

    # Crear notificación para el líder
    Notificacion.create(
      usuario_id: @gerente.id,
      notificacion_tipo: 'Proyecto Completado',
      mensaje: "El proyecto #{@proyecto} ha sido marcado como completado.",
      fecha_hora: DateTime.now
    )
  end

  def proyecto_finalizado_email(usuario, proyecto)
    @usuario = usuario
    @proyecto = proyecto
    mail(to: @usuario.email, subject: '¡Proyecto finalizado!')

    # Create a notification for the user
    Notificacion.create(
      usuario_id: @usuario.id,
      notificacion_tipo: 'Proyecto Finalizado',
      mensaje: 'Has recibido un correo de finalización del proyecto',
      fecha_hora: DateTime.now
    )
  end

  def meta_vence_pronto_email(lider, meta)
    @lider = lider
    @meta = meta
    mail(to: @lider.email, subject: '¡La meta vence pronto!')

    Notificacion.create(usuario_id: @lider.id, notificacion_tipo: 'Meta Vencimiento',
                        mensaje: 'Has recibido un correo de vencimiento próximo de meta', fecha_hora: DateTime.now)
  end

  def meta_vence_hoy_email(lider, meta)
    @lider = lider
    @meta = meta
    mail(to: @lider.email, subject: '¡La meta vence hoy!')

    Notificacion.create(usuario_id: @lider.id, notificacion_tipo: 'Meta Vencimiento',
                        mensaje: 'Has recibido un correo de vencimiento de meta (hoy)', fecha_hora: DateTime.now)
  end

  def tarea_vence_pronto_email(usuario, tarea)
    @usuario = usuario
    @tarea = tarea
    mail(to: @usuario.email, subject: '¡La tarea vence pronto!')

    Notificacion.create(usuario_id: @usuario.id, notificacion_tipo: 'Tarea Vencimiento',
                        mensaje: 'Has recibido un correo de vencimiento próximo de tarea', fecha_hora: DateTime.now)
  end

  def tarea_vence_hoy_email(usuario, tarea)
    @usuario = usuario
    @tarea = tarea
    mail(to: @usuario.email, subject: '¡La tarea vence hoy!')

    Notificacion.create(usuario_id: @usuario.id, notificacion_tipo: 'Tarea Vencimiento',
                        mensaje: 'Has recibido un correo de vencimiento de tarea (hoy)', fecha_hora: DateTime.now)
  end
end