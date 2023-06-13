class Proyecto < ApplicationRecord
  belongs_to :gerente, class_name: 'Usuario'
  belongs_to :lider, class_name: 'Usuario'
  has_many :metas, class_name: 'Meta', dependent: :destroy

  def count_members
    tareas = Meta.where(proyecto_id: id).select(:id)
    .joins("INNER JOIN tareas ON tareas.meta_id == meta.id")
    .joins("INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id")
    
    tareas.distinct.count("usuarios.id")+1# el lider?
  end

  def self.member_count(id)
    tareas = Meta.where(proyecto_id: id).select(:id)
    .joins("INNER JOIN tareas ON tareas.meta_id == meta.id")
    .joins("INNER JOIN usuarios ON usuarios.id == tareas.integrante_id OR usuarios.id == tareas.revisor_id")
    
    tareas.distinct.count("usuarios.id")+1# el lider?
  end

end