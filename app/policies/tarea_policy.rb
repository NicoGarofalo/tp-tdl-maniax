# frozen_string_literal: true

class TareaPolicy
  class Scope
    def initialize(usuario, tarea)
      @usuario  = usuario
      @tarea = tarea
    end

    def resolve
      if @usuario.esRevisor
        Tarea.where(revisor_id: @usuario.id)
      else
        Tarea.where(integrante_id: @usuario.id)
      end
    end

    private

    attr_reader :usuario, :tarea
  end


  attr_reader :tarea, :usuario_act

  def initialize(usuario_act, tarea)
    @tarea = tarea
    @usuario_act = usuario_act
  end

  def create?
    @usuario_act.esLider
  end

  def show?
    @usuario_act.esRevisor || @usuario_act.esIntegrante
  end

  def show?
    @usuario_act.esGerente || @usuario_act.esLider
  end

  def update?
    estado_es_de_revisor = @tarea.estado == 'Cumplido' || @tarea.estado == 'Pendiente'
    estado_es_de_integrante = @tarea.estado == 'Finalizado'

    es_revisor = @tarea.revisor_id == @usuario_act.id && @usuario_act.esRevisor && estado_es_de_revisor
    es_integrante = @tarea.integrante_id == @usuario_act.id && @usuario_act.esIntegrante && estado_es_de_integrante

    es_revisor || es_integrante
  end
end
