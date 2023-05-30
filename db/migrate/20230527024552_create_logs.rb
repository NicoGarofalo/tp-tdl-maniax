class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :tipo_log
      t.references :proyecto, null: false, foreign_key: true
      t.text :mensaje
      t.datetime :fecha_hora

      t.timestamps
    end
  end
end
