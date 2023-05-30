class Tarea < ApplicationRecord
  belongs_to :meta
  belongs_to :revisor, class_name: 'Usuario'
  belongs_to :integrante, class_name: 'Usuario'
end