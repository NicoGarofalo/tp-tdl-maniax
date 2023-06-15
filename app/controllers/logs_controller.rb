# frozen_string_literal: true

class LogsController < ApplicationController
  def new
    @log = Log.new
  end

  def create
    @log = Log.new(log_params)
  end

  private

  def log_params
    params.require(:log).permit(:tipo_log, :subject_id, :mensaje, :obligatorio_id, :opcional_id)
  end
end
