class Meta < ApplicationRecord
  belongs_to :proyecto


  def count_members
    tareas = Tarea.where(meta_id: id).select(:id)
    .joins("INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id")
    
    tareas.distinct.count("usuarios.id")
  end

  def self.member_count(id)
    tareas = Tarea.where(meta_id: id).select(:id)
    .joins("INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id")
    
    tareas.distinct.count("usuarios.id")
  end


end