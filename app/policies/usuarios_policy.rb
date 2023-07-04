# frozen_string_literal: true

class UsuariosPolicy
  attr_reader :usuario_act, :usuario

  def initialize(usuario_act, usuario)
    @usuario = usuario
    @usuario_act = usuario_act
  end

  def create?
    @usuario_act.esManager
  end

  def show_all?
    @usuario_act.esGerente || @usuario_act.esLider || @usuario_act.esManager
  end

  def update?
    @usuario == @usuario_act || @usuario_act.esGerente
  end

  def cambiar_rol?
    @usuario_act.esManager
  end
end
