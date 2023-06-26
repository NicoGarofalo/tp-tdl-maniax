# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
set :output, 'log/cron.log'
set :environment, 'development'
require File.expand_path('../config/environment', __dir__)

every 1.day, at: '10:00 am' do
  runner 'puts Date.today'
  runner 'ProyectosController.new.enviar_notificacion_por_correo'
  runner 'MetasController.new.enviar_notificacion_por_correo'
  runner 'TareasController.new.enviar_notificacion_por_correo'
end
