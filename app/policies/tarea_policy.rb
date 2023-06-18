# frozen_string_literal: true

class TareaPolicy
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

  def update?
    estado_es_de_revisor = @tarea.estado == 'Cumplido' || @tarea.estado == 'Pendiente'
    estado_es_de_integrante = @tarea.estado == 'Finalizado'

    es_revisor = @tarea.revisor_id == @usuario_act.id && @usuario_act.esRevisor && estado_es_de_revisor
    es_integrante = @tarea.integrante_id == @usuario_act.id && @usuario_act.esIntegrante && estado_es_de_integrante

    es_revisor || es_integrante
  end
end
