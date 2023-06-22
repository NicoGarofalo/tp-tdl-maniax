# frozen_string_literal: true

class LogPolicy
  class Scope
    def initialize(usuario, log)
      @usuario  = usuario
      @log = log
    end

    def resolve
      if usuario.esGerente
        @log.all
      else
        @log.where("obligatorio_id = ? OR opcional_id = ?", @usuario.id, @usuario.id)
      end
    end

    private

    attr_reader :usuario, :scope
  end

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
