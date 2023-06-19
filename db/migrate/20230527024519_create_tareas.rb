# frozen_string_literal: true

class CreateTareas < ActiveRecord::Migration[7.0]
  def change
    create_table :tareas do |t|
      t.references :meta, null: false, foreign_key: true
      t.references :revisor, null: false, foreign_key: { to_table: :usuarios }
      t.references :integrante, null: false, foreign_key: { to_table: :usuarios }
      t.date :fecha_vencimiento
      t.string :nombre
      t.text :descripcion
      t.string :estado

      t.timestamps
    end
  end
end
