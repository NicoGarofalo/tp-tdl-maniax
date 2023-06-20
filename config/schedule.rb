# Use this file to easily define all of your cron jobs.
set :output, 'log/cron.log'
set :environment, 'production'
require File.expand_path('../config/environment', __dir__)

every 1.day, at: '8:02 pm' do
  Proyecto.find_each do |proyecto|
    controller = ProyectosController.new
    controller.schedule_email_notifications(proyecto)
  end
end