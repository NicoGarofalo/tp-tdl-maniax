class Meta < ApplicationRecord
  belongs_to :proyecto
  has_many :tareas
end