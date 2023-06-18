# frozen_string_literal: true

class Tarea < ApplicationRecord
  belongs_to :meta
  belongs_to :revisor, class_name: 'Usuario'
  belongs_to :integrante, class_name: 'Usuario'

  def cambiar_estado(nuevo_estado)
    return false if estado === 'Finalizado' || estado === 'Vencido'
    return false if estado === 'Pendiente' && nuevo_estado === 'Finalizado'

    self.estado = nuevo_estado
    true
  end
end
