class ProyectosController < ApplicationController
  include Pundit

  def new
    @proyecto = Proyecto.new
    @lideres = Usuario.where(usuario_tipo: 'Líder')
  end


  def create
    @proyecto = Proyecto.new(proyecto_params)
    @proyecto.gerente_id = session[:usuario_id]
    @proyecto.estado = "Pendiente"
    authorize @proyecto
    
    if @proyecto.save
      @usuario = Usuario.find_by(id: session[:usuario_id])
      #UserMailer.project_created_email(@usuario, @proyecto).deliver_now

      # Obtener al líder del proyecto
      @lider = Usuario.find(@proyecto.lider_id)
      #UserMailer.project_assigned_email(@lider, @proyecto).deliver_now

      flash[:notice] = "Proyecto creado exitosamente"
      redirect_to controller: "proyectos",action: "view" , id: @proyecto.id
    else
      flash[:notice] = "creacion proyecto fallo"
      render :new
    end
  end

  def view
    @idProyecto = proyecto_view_id
    @proyecto = Proyecto.find_by(id: @idProyecto)
    @nombreGerente = Usuario.find_by(id: @proyecto.gerente_id).nombre
    @nombreLider = Usuario.find_by(id: @proyecto.lider_id).nombre

    @idUsuario = session[:usuario_id]
    @metas = Meta.where(proyecto_id: @idProyecto)
  end

  private

  def proyecto_view_id
    params.require(:id)
  end

  def proyecto_params
    params.require(:proyecto).permit(:gerente_id, :lider_id, :fecha_vencimiento, :nombre, :descripcion, :estado)
  end

  def current_user
    @usuario_act ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
    @usuario_act
  end
end