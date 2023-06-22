# frozen_string_literal: true

class NotificacionesController < ApplicationController
  layout 'layout_base_nav'

  def new
    @notificacion = Notificacion.new
  end

  def create
    @notificacion = Notificacion.new(notificacion_params)
  end

  def show
    @usuario = current_user
    @notificaciones = Notificacion.where(usuario_id: @usuario.id)
    render :show
  end

  private

  def notificacion_params
    params.require(:notificacion).permit(:usuario_id, :notificacion_tipo, :mensaje, :fecha_hora)
  end

  def current_user
    return unless session[:usuario_id]

    Usuario.find_by(id: session[:usuario_id])
  end
end
