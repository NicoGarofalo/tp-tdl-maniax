# frozen_string_literal: true
class Usuario < ApplicationRecord
  validates :usuario_tipo, :nombre, :apellido, :email, :password_digest, presence: {message: 'es un campo obligatorio'}
  validates :password_digest, length: {minimum: 6, message: 'minimo debe tener 6 caracteres'}
  has_secure_password
  has_many :proyectos, foreign_key: :gerente_id, dependent: :nullify
  has_many :proyectos, foreign_key: :lider_id, dependent: :nullify
  has_many :tareas, foreign_key: :revisor_id, dependent: :nullify
  has_many :tareas, foreign_key: :integrante_id, dependent: :nullify


  def cambiar_rol
    raise CambioRolInvalidoError if !cambio_de_rol_es_valido
    raise TareasPendientesError if tiene_tareas_pendientes

    if self.esIntegrante
      self.usuario_tipo = 'Revisor'
    else
      self.usuario_tipo = 'Integrante'
    end
  end

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

  private

  def tiene_tareas_pendientes
    self.tareas.each do |tarea|
      return true if !tarea.finalizado?
    end
    return false
  end

  def cambio_de_rol_es_valido
    return self.esIntegrante || self.esRevisor
  end
end
