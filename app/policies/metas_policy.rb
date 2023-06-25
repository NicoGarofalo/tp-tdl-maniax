# frozen_string_literal: true

class MetasPolicy
  attr_reader :meta, :usuario

  def initialize(meta, usuario)
    @meta = meta
    @usuario = usuario
  end

  def create?
    @usuario_act.esGerente
  end

  def update?
    @usuario_act.esGerente
  end

  def delete?
    @usuario_act.esGerente
  end
end
