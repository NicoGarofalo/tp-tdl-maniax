# frozen_string_literal: true

class LogPolicy
  attr_reader :log, :usuario_act

  def initialize(usuario_act, log)
    @log = log
    @usuario_act = usuario_act
  end

  # Aca meter scopes para saber cuales logs traer en base a rol
  def show?
    @usuario_act.esLider || @usuario_act.esGerente
  end
end
