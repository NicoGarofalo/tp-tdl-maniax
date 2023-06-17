# frozen_string_literal: true

class LogsController < ApplicationController
  layout 'layout_base_nav'
  def new
    @log = Log.new
  end

  def create
    @log = Log.new(log_params)
  end

  def view
    @usuario = current_user
    @logs = Log.all
    render :index
  end

  private

  def log_params
    params.require(:log).permit(:tipo_log, :subject_id, :mensaje, :obligatorio_id, :opcional_id)
  end

  def current_user
    return unless session[:usuario_id]

    Usuario.find_by(id: session[:usuario_id])
  end
end
