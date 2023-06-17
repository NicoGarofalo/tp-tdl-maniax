# frozen_string_literal: true

class NotificacionesController < ApplicationController
  def new
    @notificacion = Notificacion.new
  end

  def create
    @notificacion = Notificacion.new(notificacion_params)
  end

  private

  def notificacion_params
    params.require(:notificacion).permit(:usuario_id, :notificacion_tipo, :mensaje, :fecha_hora)
  end
end
