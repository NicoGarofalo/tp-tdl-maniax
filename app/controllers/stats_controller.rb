class StatsController < ApplicationController
  def week
  	# cargar logs semana
  	@logs = Log.all
  	
  end

  def meta
  	@idMeta = item_stats_params
    @meta = Meta.find_by(id: @idMeta)

    @stats = load_stat_progress_meta

  end

  def proyecto
  	@idProyecto = item_stats_params
    @proyecto = Proyecto.find_by(id: @idProyecto)

    @stats = load_stats_progress_proyecto @idProyecto

  end


  def load_stats_progress_proyecto(id)
  	#metas = Meta.where(proyecto_id: @idProyecto)

  	{:total => 112,
  	 :done => 23,
  	 :finished => 11,
  	 :progress => (34.3)
  	 }
  end

  def load_stat_progress_meta
  	tasks = Tarea.where(meta_id: @idMeta)
  	qTasks = tasks.count
  	qFinished = 0
  	qDone = 0

  	tasks.each do |task|
  		if task.estado == "Hecha"
  			qDone += 1
  		elsif task.estado == "Finalizada"
  			qFinished += 1
  		end
  	end

  	progress = 0
  	if qTasks >0
  		progress = (100*(qFinished.to_f/qTasks)).round(2)
  	end

  	{:total => qTasks,
  	 :done => qDone,
  	 :finished => qFinished,
  	 :progress => progress
  	 }
  end

  def load_stat_progress_proyecto
  end


  def load_stats

  end

  private

  def item_stats_params
    params.require(:id)
  end
end
