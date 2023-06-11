class MetasController < ApplicationController
  def new
    @meta = Meta.new
  end

  def show
    @idUsuario = session[:usuario_id]
    @idMeta = meta_show_params
    @meta = Meta.find_by(id: @idMeta)
    @lider_id = Proyecto.find_by(id: @meta.proyecto_id).lider_id


    @tareas = Tarea.where(meta_id: @idMeta)
  end

  def add
    @id_proyecto = meta_new_params
  end
  
  def create
    @meta = Meta.new(meta_params)
    @meta.estado = "Pendiente" # Establecer el estado como "Pendiente"

    if @meta.save
      puts "Meta guardada exitosamente"
      flash[:notice] = "Meta creada exitosamente."
      redirect_to success_path
    else
      flash[:notice] = "Meta fallo en creacion."
      puts "Meta fallo al guardarse"
      render :new
    end
  end

  private

  def meta_params
    params.require(:meta).permit(:proyecto_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end
end