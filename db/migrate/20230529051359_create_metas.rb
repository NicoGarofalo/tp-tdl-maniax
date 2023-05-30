class CreateMetas < ActiveRecord::Migration[7.0]
  def change
    create_table :metas do |t|
      t.references :proyecto, null: false, foreign_key: true
      t.date :fecha_vencimiento
      t.string :nombre
      t.text :descripcion
      t.string :estado

      t.timestamps
    end
  end
end
