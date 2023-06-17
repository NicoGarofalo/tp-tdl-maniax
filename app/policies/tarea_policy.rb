# frozen_string_literal: true

class TareaPolicy
  attr_reader :tarea, :usuario_act

  def initialize(usuario_act, tarea)
    @tarea = tarea
    @usuario_act = usuario_act
  end

  def create?
    @usuario_act.usuario_tipo == 'Líder'
  end

  def show?
    @usuario_act.usuario_tipo == 'Revisor' || @usuario_act.usuario_tipo == 'Integrante'
  end

  def update?
    estado_es_de_revisor = @tarea.estado == 'Cumplido' || @tarea.estado == 'Pendiente'
    estado_es_de_integrante = @tarea.estado == 'Finalizado'

    es_revisor = @tarea.revisor_id == @usuario_act.id && @usuario_act.usuario_tipo == 'Revisor' && estado_es_de_revisor
    es_integrante = @tarea.integrante_id == @usuario_act.id && @usuario_act.usuario_tipo == 'Integrante' && estado_es_de_integrante

    es_revisor || es_integrante
  end
end
