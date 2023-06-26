# frozen_string_literal: true

class CreateNotificaciones < ActiveRecord::Migration[7.0]
  def change
    create_table :notificaciones do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :notificacion_tipo
      t.text :mensaje
      t.datetime :fecha_hora

      t.timestamps
    end
  end
end
