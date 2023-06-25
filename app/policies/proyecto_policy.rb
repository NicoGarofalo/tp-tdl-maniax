# frozen_string_literal: true

class ProyectoPolicy
  
  class Scope
    def initialize(usuario_act, proyecto)
      @usuario_act  = usuario_act
      @proyecto = proyecto
    end

    def resolve
      if @usuario_act.esGerente
        @proyecto.where(gerente_id: @usuario_act.id)
      else
        @proyecto.where(lider_id: @usuario_act.id)
      end
    end

    private

    attr_reader :usuario_act, :proyecto
  end
  attr_reader :proyecto, :usuario

  def initialize(usuario, proyecto)
    @usuario = usuario
    @proyecto = proyecto
  end

  def create?
    @usuario.esGerente
  end

  # El estado cumplido != finalizado para proyecto? Para que lo usariamos?
  def update?
    @usuario.esGerente && @proyecto.estado == 'Finalizado'
  end

  def show?
    @usuario.esGerente || @usuario.esLider
  end
end
