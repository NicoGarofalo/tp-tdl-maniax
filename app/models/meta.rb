# frozen_string_literal: true

class Meta < ApplicationRecord
  belongs_to :proyecto


  # member counting
  def count_members
    Meta.member_count(id)
  end

  def self.member_count(id)
    tareas = Tarea.where(meta_id: id).select(:id)
                  .joins('INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id')

    tareas.distinct.count('usuarios.id')
  end

  def self.progress_of(id)
    tasks = Tarea.where(meta_id: id)
    qTasks = tasks.count


    qFinished = tasks.where(estado: 'Finalizada').count

    progress = 0

    progress = (100 * (qFinished.to_f / qTasks)).round(2) if qTasks.positive?

    progress
  end
  has_many :tareas

  scope :pendientes, -> { where(estado: 'Pendiente') }
  scope :con_estado_distinto_finalizado, -> { where.not(estado: 'Finalizado') }
end
