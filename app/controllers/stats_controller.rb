class StatsController < ApplicationController

  layout "layout_stats"

  # views

  def week
  	# cargar logs semana
  	@logs = Log.all
  	
  end

  def meta
  	idMeta = item_stats_params
    nombre = Meta.find_by(id: idMeta).nombre

    stats = stats_meta idMeta

  	render template: "stats/meta", locals: {:meta => nombre, :stats => stats}
  end

  def proyecto
    idProyecto = item_stats_params
    nombre = Proyecto.find_by(id: idProyecto).nombre

    stats = stats_proyecto idProyecto

    render template: "stats/proyecto", locals: {:proyecto => nombre, :stats => stats} 
  end

  def usuario
    @idUsuario = item_stats_params

  end


  # stats getters requests

  def stats_for
    params_stats_info 


    info = {}
    if params[:tipo] == "proyecto"
      info[:stats] = stats_proyecto(params[:id])
    elsif params[:tipo] == "meta"
      info[:stats] = stats_meta(params[:id])
    end

    render json: info
  end


  def stats_proyecto(id)

    stats = {}
    stats[:progress] = progress_proyecto id 

    stats[:countMembers] = member_count_proyecto id

    stats
  end

  def stats_meta(id)

    stats = {}

    stats[:progress] = progress_meta id
    stats[:countMembers] = member_count_meta id



    stats
  end

  def stats_usuario
  end


  private

  def progress_proyecto(id)
    metas = Meta.where(proyecto_id: id)
    total = metas.count
    metas.select(:id)

    progress = 0

    metas.each do |meta|
      res = progress_meta(meta.id)
      progress += res
    end

    if total > 0
      progress = (progress/total).round(2)
    end

    progress
  end


  def progress_meta(id)
    tasks = Tarea.where(meta_id: id)
    qTasks = tasks.count
    

    qFinished = tasks.where(estado: "Finalizada").count

    progress = 0



    if qTasks >0
      progress = (100*(qFinished.to_f/qTasks)).round(2)
    end

    progress
  end



  def gerente_stats(datos, id)

  end

  def lider_stats(datos, id)

  end

  def revisor_stats(datos, id)

  end

  def integrante_stats(datos, id)
  end


  def usuario_stats (id, tipo)

    datos= {}
    if tipo == "Gerente"
      gerente_stats datos, id
    elsif tipo == "Lider"
      lider_stats datos, id
    elsif tipo == "Revisor"
      revisor_stats datos, id
    else
      integrante_stats datos, id
    end

    datos
  end


  def member_count_proyecto(id)
    tareas = Meta.where(proyecto_id: id).select(:id)
    .joins("INNER JOIN tareas ON tareas.meta_id == meta.id")
    .joins("INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id")
    
    tareas.distinct.count("usuarios.id")
  end


  def member_count_meta(id)
    tareas = Tarea.where(meta_id: id).select(:id)
    .joins("INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id")
    
    tareas.distinct.count("usuarios.id")
  end






  # params getter

  def item_stats_params
    params.require(:id)
  end

  def params_stats_info
    params.require(:tipo)
    params.require(:id)
  end

end
