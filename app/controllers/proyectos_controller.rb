class ProyectosController < ApplicationController
  def new
    @proyecto = Proyecto.new
    @lideres = Usuario.where(usuario_tipo: 'Líder')
  end

  def create
    @proyecto = Proyecto.new(proyecto_params)
    @proyecto.gerente_id = session[:usuario_id]
    @proyecto.estado = "Pendiente"

    if @proyecto.save
      @usuario = Usuario.find_by(id: session[:usuario_id])
      UserMailer.project_created_email(@usuario, @proyecto).deliver_now

      # Obtener al líder del proyecto
      @lider = Usuario.find(@proyecto.lider_id)
      UserMailer.project_assigned_email(@lider, @proyecto).deliver_now

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