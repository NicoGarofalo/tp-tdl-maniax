# frozen_string_literal: true

class CreateUsuarios < ActiveRecord::Migration[7.0]
  def change
    create_table :usuarios do |t|
      t.string :usuario_tipo
      t.string :nombre
      t.string :apellido
      t.string :email
      t.string :password_digest # Agregar campo de contraseña con el tipo "string"

      t.timestamps
    end
  end
end
