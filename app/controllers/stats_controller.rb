class StatsController < ApplicationController
  def week
  	# cargar logs semana
  	@logs = Log.all
  	
  end

  def load_stats

  end
end
