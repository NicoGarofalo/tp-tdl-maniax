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
    estado == 'Finalizado' && borrado == false
  end

  def completado?
    estado == 'Completado' && borrado == false
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

  scope :pendientes, -> { where(estado: 'Pendiente', borrado: false) }
  scope :con_estado_distinto_finalizado, -> { where.not(estado: 'Finalizado', borrado: true) }
  scope :no_borradas, -> { where(borrado: false) }
end
