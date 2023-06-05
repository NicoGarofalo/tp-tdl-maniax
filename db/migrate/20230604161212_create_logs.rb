class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :tipo_log
      t.integer :proyecto_id
      t.integer :subject_id
      t.string :mensaje
      t.date :fecha_hora

      t.timestamps
    end
  end
end
