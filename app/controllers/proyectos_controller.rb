class ProyectosController < ApplicationController
  def new
    @proyecto = Proyecto.new
    @lideres = Usuario.where(usuario_tipo: 'Líder')
  end

  def create
    @proyecto = Proyecto.new(proyecto_params)
    @proyecto.gerente_id = session[:usuario_id] # Obtener el ID del gerente de la sesión
    @proyecto.estado = "Pendiente" # Establecer el estado como "Pendiente"

    if @proyecto.save
      flash[:notice] = "Proyecto creado exitosamente"
      redirect_to success_path
    else
      render :new
    end
  end

  private

  def proyecto_params
    params.require(:proyecto).permit(:gerente_id, :lider_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end
end