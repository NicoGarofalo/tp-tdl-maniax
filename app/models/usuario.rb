# frozen_string_literal: true

class Usuario < ApplicationRecord
  validates :usuario_tipo, :nombre, :apellido, :email, :password, presence: {message: 'es un campo obligatorio'}
  validates :password, length: {minimum: 6, message: 'minimo debe tener 6 caracteres'}
  has_secure_password
  has_many :proyectos, foreign_key: :gerente_id, dependent: :nullify
  has_many :proyectos, foreign_key: :lider_id, dependent: :nullify
  has_many :tareas, foreign_key: :revisor_id, dependent: :nullify
  has_many :tareas, foreign_key: :integrante_id, dependent: :nullify

  def nombre_completo
    nombre + " " + apellido
  end

  def esGerente
    usuario_tipo == 'Gerente'
  end

  def esLider
    usuario_tipo == 'Líder'
  end

  def esIntegrante
    usuario_tipo == 'Integrante'
  end

  def esRevisor
    usuario_tipo == 'Revisor'
  end

  def esManager
    usuario_tipo == 'Manager'
  end
end
