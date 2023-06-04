class MetasController < ApplicationController
  def new
    @id_proyecto = meta_new_params
    @meta = Meta.new
  end

  def show
    @meta = Meta.find_by(id: meta_show_params)
  end

  def add
    @id_proyecto = meta_new_params
  end

  def create
    @dataMeta = meta_params

    @dataMeta["proyecto_id"] = params["proyecto_id"]
    @meta = Meta.new(@dataMeta)
    @meta.estado = "Pendiente" # Establecer el estado como "Pendiente"

    if @meta.save
      flash[:notice] = "Meta creada exitosamente."
    else
      flash[:notice] = "Meta fallo en creacion."
    end
  end

  private

  def meta_new_params
    params.require(:proyecto_id)
  end

  def meta_show_params
    params.require(:id)
  end

  def meta_params
    params.require(:meta).permit(:fecha_vencimiento, :nombre, :descripcion, :estado)
  end
end