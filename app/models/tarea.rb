# frozen_string_literal: true

class Tarea < ApplicationRecord
  belongs_to :meta
  belongs_to :revisor, class_name: 'Usuario'
  belongs_to :integrante, class_name: 'Usuario'

  def initialize(params)
    super
    self.estado = 'Pendiente'
  end

  def finalizado?
    return self.estado == 'Finalizado'
  end

  def completado?
    return self.estado == 'Completado'
  end

  def cambiar_estado(nuevo_estado)
    return false unless estado_valido(nuevo_estado)
    return false if estado === 'Finalizado' || estado === 'Vencido'
    return false if estado === 'Pendiente' && nuevo_estado === 'Finalizado'

    self.estado = nuevo_estado
    true
  end

  private

  def estado_valido(estado)
    return false unless %w[Pendiente Finalizado Vencido Cumplido].include?(estado)

    true
  end

  scope :pendientes, -> { where(estado: 'Pendiente') }
  scope :con_estado_distinto_finalizado, -> { where.not(estado: 'Finalizado') }
end
