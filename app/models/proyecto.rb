class Proyecto < ApplicationRecord
  belongs_to :gerente, class_name: 'Usuario'
  belongs_to :lider, class_name: 'Usuario'
  has_many :metas, class_name: 'Meta', dependent: :destroy
end