class UserMailer < ApplicationMailer
  def welcome_email(usuario)
    @usuario = usuario
    mail(to: @usuario.email, subject: "¡Bienvenido a nuestro sitio web!")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @usuario.id, notificacion_tipo: 'Bienvenida', mensaje: 'Has recibido un correo de bienvenida', fecha_hora: DateTime.now)
  end

  def project_created_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "Proyecto creado exitosamente")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Proyecto Creado', mensaje: 'Has recibido un correo de creación de proyecto', fecha_hora: DateTime.now)
  end

  def project_assigned_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "Proyecto asignado a ti")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Proyecto Asignado', mensaje: 'Has recibido un correo de asignación de proyecto', fecha_hora: DateTime.now)
  end

  def meta_created_email(user, meta)
    @user = user
    @meta = meta
    @proyecto = meta.proyecto
    mail(to: @user.email, subject: "Meta creada exitosamente")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Meta Creada', mensaje: 'Has recibido un correo de creación de meta', fecha_hora: DateTime.now)
  end

  def tarea_created_email(usuario, tarea)
    @usuario = usuario
    @tarea = tarea
    @meta = tarea.meta
    @proyecto = tarea.meta.proyecto
    mail(to: @usuario.email, subject: "Nueva tarea creada")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @usuario.id, notificacion_tipo: 'Tarea Creada', mensaje: 'Has recibido un correo de creación de tarea', fecha_hora: DateTime.now)
  end

  def project_due_today_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "¡El proyecto vence hoy!")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Proyecto Vencimiento', mensaje: 'Has recibido un correo de vencimiento de proyecto (hoy)', fecha_hora: DateTime.now)
  end

  def project_due_soon_email(user, project)
    @user = user
    @project = project
    mail(to: @user.email, subject: "¡El proyecto vence pronto!")

    # Crear notificación para el usuario
    Notificacion.create(usuario_id: @user.id, notificacion_tipo: 'Proyecto Vencimiento', mensaje: 'Has recibido un correo de vencimiento próximo de proyecto', fecha_hora: DateTime.now)
  end
end