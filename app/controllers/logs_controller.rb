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
    @logs = policy_scope(Log)
    render :index
  end

  private

  def log_params
    params.require(:log).permit(:tipo_log, :subject_id, :mensaje, :obligatorio_id, :opcional_id)
  end

end
