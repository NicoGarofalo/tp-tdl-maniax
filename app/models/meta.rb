# frozen_string_literal: true

class Meta < ApplicationRecord
  belongs_to :proyecto

  def chequear_fecha_vencimiento()
    self.estado = if self.fecha_vencimiento < Date.today
      'Vencido'
    else
      'Pendiente'
    end  
  end

  def finalizar
    self.estado = 'Finalizado'
  end

  def finalizado?
    return self.estado == 'Finalizado'
  end

  def completado?
    return self.estado == 'Completado'
  end


  def vencio?
    if self.fecha_vencimiento.to_date < Date.today && self.estado == 'Pendiente'
      self.estado = 'Vencido'
      return true
    end
    return false
  end

  def vence_hoy?
    return self.fecha_vencimiento.to_date == Date.today
  end

  def vence_en_una_semana?
    return self.fecha_vencimiento.to_date == 1.week.from_now.to_date
  end

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


    qFinished = tasks.where(estado: 'Finalizado').count

    progress = 0

    progress = (100 * (qFinished.to_f / qTasks)).round(2) if qTasks.positive?

    progress
  end
  has_many :tareas

  scope :pendientes, -> { where(estado: 'Pendiente') }
  scope :con_estado_distinto_finalizado, -> { where.not(estado: 'Finalizado') }
end

