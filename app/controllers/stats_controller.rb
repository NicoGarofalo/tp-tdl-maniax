class StatsController < ApplicationController
  def week
  	# cargar logs semana
  	@logs = Log.all
  	
  end

  def meta
  	idMeta = item_stats_params
    nombre = Meta.find_by(id: idMeta).nombre

    stats = load_stat_progress_meta idMeta

	render template: "stats/meta", locals: {:meta => nombre, :stats => stats}

  end

  def proyecto
  	idProyecto = item_stats_params
    nombre = Proyecto.find_by(id: idProyecto).nombre

    stats = load_stats_progress_proyecto idProyecto

	render template: "stats/proyecto", locals: {:proyecto => nombre, :stats => stats}
	
  end

  def load_stats_progress_proyecto(id)
  	metas = Meta.where(proyecto_id: id)
  	res = {:metas => {}}

  	progress = 0
  	metas.each do |meta|
  		res[:metas][meta.nombre] = load_stat_progress_meta(meta.id)

  		progress += res[:metas][meta.nombre][:progress]
  	end

  	res[:progress] = 0
  	if metas.count > 0
	  	res[:progress] = progress/metas.count
	end
  	res
  end

  def load_stat_progress_meta(id)
  	tasks = Tarea.where(meta_id: id)
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
