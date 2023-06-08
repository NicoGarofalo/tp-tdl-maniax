class TareasController < ApplicationController
  def new
    @tarea = Tarea.new
  end

  def create
    @tarea = Tarea.new(tarea_params)
    @tarea.estado = "Pendiente" # Establecer el estado como "Pendiente"

    if @tarea.save
      flash[:notice] = "Tarea creada exitosamente."
      redirect_to success_path
    else
      puts @tarea.errors.full_messages # Imprimir los errores en la consola
      render :new
    end
  end

  private

  def tarea_params
    params.require(:tarea).permit(:meta_id, :revisor_id, :integrante_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end
end