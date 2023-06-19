# frozen_string_literal: true

class CreateProyectos < ActiveRecord::Migration[7.0]
  def change
    create_table :proyectos do |t|
      t.references :gerente, null: false, foreign_key: { to_table: :usuarios }
      t.references :lider, null: false, foreign_key: { to_table: :usuarios }
      t.date :fecha_vencimiento
      t.string :nombre
      t.text :descripcion
      t.string :estado

      t.timestamps
    end
  end
end
