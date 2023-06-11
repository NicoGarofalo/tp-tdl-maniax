class TareasController < ApplicationController
  def new
    @idUsuario = session[:usuario_id]
    @idMeta = tarea_new_params
    @tarea = Tarea.new
  end

  def add
    @idUsuario = session[:usuario_id]
    @idMeta = tarea_new_params
  end

  def create
    
    @tarea = Tarea.new(tarea_params)
    @tarea.estado = "Pendiente" # Establecer el estado como "Pendiente"

    if @tarea.save
      puts "exitosamente creada la tarea"
      flash[:notice] = "Tarea creada exitosamente."
      redirect_to success_path
    else
      flash[:notice] = "Creacion Tarea fallo."
      puts @tarea.errors.full_messages # Imprimir los errores en la consola
      render :new
    end
  end

  private

  def tarea_new_params
    params.require(:meta_id)
  end

  def tarea_params
    params.require(:tarea).permit(:meta_id, :revisor_id, :integrante_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end
end