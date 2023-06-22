# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end
end
