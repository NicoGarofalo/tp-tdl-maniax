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
    @lider = user
    @proyecto = project
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
end