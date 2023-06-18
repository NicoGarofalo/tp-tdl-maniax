# frozen_string_literal: true

class UsuariosPolicy
  attr_reader :usuario_act, :usuario

  def initialize(usuario_act, usuario)
    @usuario = usuario
    @usuario_act = usuario_act
  end

  def create?
    @usuario_act.esGerente
  end

  def show_all?
    @usuario_act.esGerente || @usuario_act.esLider
  end

  def update?
    @usuario == @usuario_act || @usuario_act.esGerente
  end
end
