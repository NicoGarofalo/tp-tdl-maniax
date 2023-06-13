class StatsController < ApplicationController

  layout "layout_stats"

  # views

  def week
  	# cargar logs semana
  	@logs = Log.all
  	
  end

  def meta
    meta = Meta.find_by(id: item_stats_params)

    stats = stats_meta meta

  	render partial: "stats/meta", locals: {:meta => meta, :stats => stats} 
  end

  def proyecto
    idProyecto = item_stats_params
    proyecto = Proyecto.find_by(id: idProyecto)


    nombre_lider = Usuario.find_by(id: proyecto.lider_id).nombre

    stats = stats_proyecto proyecto
    
    datos = {
      :stats => stats,
      :proyecto => proyecto,
      :nombre_lider => nombre_lider
    }

    render partial: "stats/proyecto", locals: datos
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
    stats[:countMembers] = Proyecto.member_count id

    stats
  end

  def stats_meta(id)
    stats = {}
    
    stats[:progress] = progress_meta id
    stats[:countMembers] = Meta.member_count id

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

  # params getter

  def item_stats_params
    params.require(:id)
  end

  def params_stats_info
    params.require(:tipo)
    params.require(:id)
  end

end
