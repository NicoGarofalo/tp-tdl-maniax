class Usuario < ApplicationRecord
  has_secure_password
  validates :usuario_tipo, :nombre, :apellido, :email, :password_digest, presence: true
  validates :password_digest, length: { minimum: 6 }
  has_many :proyectos, foreign_key: :gerente_id, dependent: :nullify
  has_many :proyectos, foreign_key: :lider_id, dependent: :nullify
  has_many :tareas, foreign_key: :revisor_id, dependent: :nullify
  has_many :tareas, foreign_key: :integrante_id, dependent: :nullify



  def esGerente
  	return usuario_tipo == "Gerente"
  end
end