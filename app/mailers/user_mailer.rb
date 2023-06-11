class UserMailer < ApplicationMailer
  def welcome_email(usuario)
    @usuario = usuario
    mail(to: @usuario.email, subject: "¡Bienvenido a nuestro sitio web!")

    # Crear notificación para el usuario
    # Notificacion.create(usuario_id: @usuario.id, notificacion_tipo: 'Bienvenida', mensaje: '¡Bienvenido a nuestro sitio web!', fecha_hora: DateTime.now)
  end

  def project_created_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "Proyecto creado exitosamente")
  end

  def project_assigned_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "Proyecto asignado a ti")

  end

  def meta_created_email(user, meta)
    @user = user
    @meta = meta
    mail(to: @user.email, subject: "Meta creada exitosamente")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Meta', mensaje: 'Has creado una nueva meta', fecha_hora: DateTime.now)
  end

  def tarea_created_email(lider, integrante, tarea)
    @lider = lider
    @integrante = integrante
    @tarea = tarea
    mail(to: [@lider.email, @integrante.email], subject: "Tarea creada exitosamente")
  end
end