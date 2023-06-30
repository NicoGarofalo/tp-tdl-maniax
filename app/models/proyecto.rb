# frozen_string_literal: true

class Proyecto < ApplicationRecord
  belongs_to :gerente, class_name: 'Usuario'
  belongs_to :lider, class_name: 'Usuario'
  has_many :metas, class_name: 'Meta', dependent: :destroy

  def cargar_gerente(gerente_id)
    self.gerente_id = gerente_id
  end

  def chequear_fecha_vencimiento
    self.estado = if fecha_vencimiento < Date.today
                    'Vencido'
                  else
                    'Pendiente'
                  end
  end

  def finalizo?
    if metas.pendientes.empty?
      self.estado = 'Completado'
      return true
    end
    false
  end

  def finalizado?
    estado == 'Finalizado' && borrado == false
  end

  def completado?
    estado == 'Completado' && borrado == false
  end

  # count members
  def count_members
    tareas = Meta.where(proyecto_id: id, borrado: false).select(:id)
                 .joins('INNER JOIN tareas ON tareas.meta_id == meta.id')
                 .joins('INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id')

    tareas.distinct.count('usuarios.id') + 1 # el lider?
  end

  def self.member_count(id)
    tareas = Meta.where(proyecto_id: id, borrado: false).select(:id)
                 .joins('INNER JOIN tareas ON tareas.meta_id == meta.id')
                 .joins('INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id')

    tareas.distinct.count('usuarios.id') + 1 # el lider?
  end

  # progress
  def self.progress_of(id)
    metas = Meta.where(proyecto_id: id, borrado: false)
    total = metas.count
    metas.select(:id)

    progress = 0
    metas.each do |meta|
      res = Meta.progress_of(meta.id)
      progress += res
    end

    progress = (progress / total).round(2) if total.positive?
    progress
  end

  scope :no_borradas, -> { where(borrado: false) }
end
