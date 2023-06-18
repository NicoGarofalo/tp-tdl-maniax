# frozen_string_literal: true

class ProyectoPolicy
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
