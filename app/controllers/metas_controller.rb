class MetasController < ApplicationController
  def new
    @meta = Meta.new
  end

  def create
    @meta = Meta.new(meta_params)
    @meta.estado = "Pendiente" # Establecer el estado como "Pendiente"

    if @meta.save
      flash[:notice] = "Meta creada exitosamente."
      redirect_to success_path
    else
      render :new
    end
  end

  private

  def meta_params
    params.require(:meta).permit(:proyecto_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end
end